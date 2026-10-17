import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/blocker_category.dart';
import '../models/journal_entry.dart';
import '../services/firebase_service.dart';
import '../services/purchase_service.dart';
import '../l10n/app_strings.dart';

class AppState extends ChangeNotifier {
  static const MethodChannel _screenTimeChannel = MethodChannel('com.nora.blocker/screentime');

  bool _isLoading = true;
  bool _isOnboarded = false;
  bool _isSubscribed = false;
  String _activePlan = 'annual'; // 'monthly' or 'annual'
  bool _isInTrial = false;
  DateTime? _trialEndsAt;
  ThemeMode _themeMode = ThemeMode.system;
  String _languagePreference = 'system'; // 'system', 'tr', 'en'
  String _resolvedLanguage = 'tr';

  UserProfile _userProfile = UserProfile.defaultProfile();
  List<BlockerCategory> _categories = BlockerCategory.getDefaultCategories();
  List<String> _customBlockedDomains = [];
  List<Map<String, dynamic>> _serverBlockedSites = [];
  List<String> _serverBlockedDomains = [];
  List<String> _serverBlockedBundleIds = [];
  bool _isBlockerEnabled = true;
  bool _strictShieldMode = true;
  bool _antiBypassEnabled = true;
  List<JournalEntry> _journalEntries = [];

  String _nativeAuthStatus = 'unknown'; // 'approved', 'denied', 'notDetermined', 'unsupported', 'unknown'
  int _shieldedAppsCount = 0;
  int _shieldedCategoriesCount = 0;
  int _shieldedWebDomainsCount = 0;

  // VPN & Proxy bypass detection
  bool _isVpnActive = false;
  bool _isProxyActive = false;
  String _vpnInterface = '';
  Timer? _vpnPollingTimer;

  bool get isLoading => _isLoading;
  bool get isOnboarded => _isOnboarded;
  bool get isSubscribed => _isSubscribed;
  String get activePlan => _activePlan;
  bool get isInTrial => _isInTrial;
  DateTime? get trialEndsAt => _trialEndsAt;
  int get trialDaysRemaining {
    if (!_isInTrial || _trialEndsAt == null) return 0;
    final diff = _trialEndsAt!.difference(DateTime.now()).inHours;
    if (diff <= 0) return 0;
    return (diff / 24).ceil();
  }
  ThemeMode get themeMode => _themeMode;
  String get languagePreference => _languagePreference;
  String get languageCode => _resolvedLanguage;
  Locale get locale => Locale(_resolvedLanguage);
  AppStrings get strings => AppStrings.get(_resolvedLanguage);
  UserProfile get userProfile => _userProfile;
  List<BlockerCategory> get categories => _categories;
  List<String> get customBlockedDomains => _customBlockedDomains;
  List<Map<String, dynamic>> get serverBlockedSites => _serverBlockedSites;
  List<String> get serverBlockedDomains => _serverBlockedDomains;
  List<String> get serverBlockedBundleIds => _serverBlockedBundleIds;
  bool get isBlockerEnabled => _isBlockerEnabled;
  bool get strictShieldMode => _strictShieldMode;
  bool get antiBypassEnabled => _antiBypassEnabled;
  List<JournalEntry> get journalEntries => _journalEntries;
  String get nativeAuthStatus => _nativeAuthStatus;
  int get shieldedAppsCount => _shieldedAppsCount;
  int get shieldedCategoriesCount => _shieldedCategoriesCount;
  int get shieldedWebDomainsCount => _shieldedWebDomainsCount;
  bool get hasShieldedApps => (_shieldedAppsCount + _shieldedCategoriesCount + _shieldedWebDomainsCount) > 0;

  bool get isVpnActive => _isVpnActive;
  bool get isProxyActive => _isProxyActive;
  String get vpnInterface => _vpnInterface;
  bool get isBypassThreatActive => _isVpnActive || _isProxyActive;

  AppState() {
    _resolvedLanguage = _computeResolvedLanguage(_languagePreference);
    try {
      WidgetsBinding.instance.platformDispatcher.onLocaleChanged = () {
        if (_languagePreference == 'system') {
          final newLang = _computeResolvedLanguage('system');
          if (newLang != _resolvedLanguage) {
            _resolvedLanguage = newLang;
            notifyListeners();
          }
        }
      };
    } catch (_) {}
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboarded = prefs.getBool('nora_is_onboarded') ?? false;
      _isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
      _activePlan = prefs.getString('nora_active_plan') ?? 'annual';
      _isInTrial = prefs.getBool('nora_is_in_trial') ?? false;
      final trialEndsAtMs = prefs.getInt('nora_trial_ends_at_ms');
      if (trialEndsAtMs != null) {
        _trialEndsAt = DateTime.fromMillisecondsSinceEpoch(trialEndsAtMs);
      }
      _isBlockerEnabled = prefs.getBool('nora_blocker_enabled') ?? true;
      _strictShieldMode = prefs.getBool('nora_strict_shield') ?? true;
      _antiBypassEnabled = prefs.getBool('nora_anti_bypass') ?? true;

      _languagePreference = prefs.getString('nora_language_preference') ?? 'system';
      _resolvedLanguage = _computeResolvedLanguage(_languagePreference);

      final themeStr = prefs.getString('nora_theme_mode') ?? 'system';
      if (themeStr == 'light') {
        _themeMode = ThemeMode.light;
      } else if (themeStr == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }

      final profileJson = prefs.getString('nora_user_profile');
      if (profileJson != null) {
        _userProfile = UserProfile.fromJson(profileJson);
      }

      _customBlockedDomains = prefs.getStringList('nora_custom_domains') ?? [];

      final journalRaw = prefs.getStringList('nora_journal_entries') ?? [];
      _journalEntries = journalRaw.map((e) => JournalEntry.fromJson(e)).toList();

      final catRaw = prefs.getString('nora_categories');
      if (catRaw != null) {
        final List dynamicList = json.decode(catRaw);
        final loadedCategories = dynamicList.map((e) => BlockerCategory.fromMap(e)).toList();
        final defaults = BlockerCategory.getDefaultCategories();
        final catMap = {for (var c in loadedCategories) c.id: c};
        _categories = defaults.map((def) {
          final cat = catMap[def.id] ?? def;
          cat.isEnabled = true;
          return cat;
        }).toList();
      } else {
        for (final c in _categories) {
          c.isEnabled = true;
        }
      }

      _nativeAuthStatus = prefs.getString('nora_native_auth_status') ?? 'unknown';

      // Check native authorization status & sync filters on launch
      await checkNativePermissions();
      await fetchShieldedAppInfo();
      await syncNativeFilters();
      _startVpnMonitoring();

      // Initial Firebase user & topic sync and attach real-time Firestore listener
      unawaited(_initFirebaseSync());

      // Initial RevenueCat entitlement check & real-time update listener
      unawaited(_initRevenueCatSync());
    } catch (e) {
      debugPrint('Error loading app state: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initRevenueCatSync() async {
    try {
      final customerInfo = await PurchaseService.instance.getCustomerInfo();
      if (customerInfo != null) {
        final isEntitled = PurchaseService.instance.isEntitled(customerInfo);
        final plan = PurchaseService.instance.getActivePlan(customerInfo) ?? _activePlan;
        final inTrial = PurchaseService.instance.isTrial(customerInfo);
        final expDate = PurchaseService.instance.getExpirationDate(customerInfo);

        if (isEntitled != _isSubscribed || plan != _activePlan || inTrial != _isInTrial) {
          _isSubscribed = isEntitled;
          _activePlan = plan;
          _isInTrial = inTrial;
          if (expDate != null) _trialEndsAt = expDate;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('nora_is_subscribed', isEntitled);
          await prefs.setString('nora_active_plan', plan);
          await prefs.setBool('nora_is_in_trial', inTrial);
          if (_trialEndsAt != null) {
            await prefs.setInt('nora_trial_ends_at_ms', _trialEndsAt!.millisecondsSinceEpoch);
          }
          notifyListeners();
          unawaited(FirebaseService.syncUserAndTopics(isPremium: isEntitled));
        }
      }

      // Listen for subscription updates (e.g. renewal, cancellation, family share)
      PurchaseService.instance.addCustomerInfoUpdateListener((customerInfo) async {
        final isEntitled = PurchaseService.instance.isEntitled(customerInfo);
        final plan = PurchaseService.instance.getActivePlan(customerInfo) ?? _activePlan;
        final inTrial = PurchaseService.instance.isTrial(customerInfo);
        final expDate = PurchaseService.instance.getExpirationDate(customerInfo);

        if (isEntitled != _isSubscribed || plan != _activePlan || inTrial != _isInTrial) {
          debugPrint('💎 [AppState] RevenueCat CustomerInfo updated: isEntitled=$isEntitled, plan=$plan, inTrial=$inTrial');
          _isSubscribed = isEntitled;
          _activePlan = plan;
          _isInTrial = inTrial;
          if (expDate != null) _trialEndsAt = expDate;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('nora_is_subscribed', isEntitled);
          await prefs.setString('nora_active_plan', plan);
          await prefs.setBool('nora_is_in_trial', inTrial);
          if (_trialEndsAt != null) {
            await prefs.setInt('nora_trial_ends_at_ms', _trialEndsAt!.millisecondsSinceEpoch);
          }
          notifyListeners();
          unawaited(FirebaseService.syncUserAndTopics(isPremium: isEntitled));
        }
      });
    } catch (e) {
      debugPrint('⚠️ Error initializing RevenueCat sync: $e');
    }
  }

  Future<void> _initFirebaseSync() async {
    try {
      await FirebaseService.initialize();
      await FirebaseService.syncUserAndTopics(isPremium: _isSubscribed);

      FirebaseService.startUserRealtimeListener(
        onPremiumStatusChanged: (remoteIsPremium) async {
          if (_isSubscribed != remoteIsPremium) {
            debugPrint('🔥 [AppState] Real-time isPremium changed from Firestore: $remoteIsPremium');
            _isSubscribed = remoteIsPremium;
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('nora_is_subscribed', remoteIsPremium);
            notifyListeners();
            await FirebaseService.syncUserAndTopics(isPremium: remoteIsPremium);
          }
        },
      );

      // Real-time Firestore listener for server-side blocked sites table
      await FirebaseService.startBlockedSitesRealtimeListener(
        onSitesUpdated: (remoteSites) async {
          _serverBlockedSites = remoteSites;
          _serverBlockedDomains = remoteSites
              .where((s) => s['isEnabled'] != false && s['domain'] != null && (s['domain'] as String).trim().isNotEmpty)
              .map((s) => (s['domain'] as String).trim().toLowerCase())
              .toList();
          _serverBlockedBundleIds = remoteSites
              .where((s) => s['isEnabled'] != false && s['bundleId'] != null && (s['bundleId'] as String).trim().isNotEmpty)
              .map((s) => (s['bundleId'] as String).trim())
              .toList();
          debugPrint('🔥 [AppState] Firestore blocked sites updated: ${_serverBlockedDomains.length} domains, ${_serverBlockedBundleIds.length} bundle IDs');
          notifyListeners();
          await syncNativeFilters();
        },
      );

      // Seed initial default blocked sites into Firestore if collection is empty
      await FirebaseService.seedInitialBlockedSitesIfEmpty(_categories);
    } catch (e) {
      debugPrint('⚠️ Error initializing Firebase sync: $e');
    }
  }

  /// Manually triggers seeding all built-in default categories, preset domains, and app bundle IDs to Firestore
  Future<void> seedBlockedSitesToFirestore({bool force = false}) async {
    await FirebaseService.seedInitialBlockedSitesIfEmpty(_categories, force: force);
  }

  Future<void> checkNativePermissions() async {
    if (kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = await _screenTimeChannel.invokeMethod<String>('checkAuthorizationStatus');
      if (status == 'approved') {
        _nativeAuthStatus = 'approved';
        await prefs.setString('nora_native_auth_status', 'approved');
      } else if (status == 'denied') {
        _nativeAuthStatus = 'denied';
        await prefs.setString('nora_native_auth_status', 'denied');
      } else {
        final savedStatus = prefs.getString('nora_native_auth_status');
        if (savedStatus == 'approved') {
          _nativeAuthStatus = 'approved';
        } else {
          _nativeAuthStatus = status ?? 'unknown';
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking native authorization status: $e');
    }
  }

  Future<void> requestNativePermissions() async {
    if (kIsWeb) return;
    try {
      final result = await _screenTimeChannel.invokeMethod('requestAuthorization');
      if (result == true) {
        _nativeAuthStatus = 'approved';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nora_native_auth_status', 'approved');
        notifyListeners();
        await syncNativeFilters();
      } else {
        _nativeAuthStatus = 'denied';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nora_native_auth_status', 'denied');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error requesting Screen Time authorization (user denied or error): $e');
      _nativeAuthStatus = 'denied';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nora_native_auth_status', 'denied');
      notifyListeners();
    }
  }

  Future<void> revokeNativePermissions() async {
    if (kIsWeb) return;
    try {
      await _screenTimeChannel.invokeMethod('revokeAuthorization');
    } catch (e) {
      debugPrint('Error revoking native Screen Time authorization: $e');
      try {
        await _screenTimeChannel.invokeMethod('clearFilters');
      } catch (_) {}
    } finally {
      _nativeAuthStatus = 'notDetermined';
      _shieldedAppsCount = 0;
      _shieldedCategoriesCount = 0;
      _shieldedWebDomainsCount = 0;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('nora_native_auth_status');
      notifyListeners();
    }
  }

  Future<void> fetchShieldedAppInfo() async {
    if (kIsWeb) return;
    try {
      final res = await _screenTimeChannel.invokeMethod('getShieldedAppInfo');
      if (res != null && res is Map) {
        _shieldedAppsCount = (res['appsCount'] as num?)?.toInt() ?? 0;
        _shieldedCategoriesCount = (res['catsCount'] as num?)?.toInt() ?? 0;
        _shieldedWebDomainsCount = (res['webDomainsCount'] as num?)?.toInt() ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching shielded app info: $e');
    }
  }

  Future<void> selectAppsToBlock() async {
    if (kIsWeb) return;
    try {
      final res = await _screenTimeChannel.invokeMethod('selectAppsToBlock');
      if (res != null && res is Map) {
        _shieldedAppsCount = (res['appsCount'] as num?)?.toInt() ?? 0;
        _shieldedCategoriesCount = (res['catsCount'] as num?)?.toInt() ?? 0;
        _shieldedWebDomainsCount = (res['webDomainsCount'] as num?)?.toInt() ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error selecting apps to block: $e');
    }
  }

  Future<void> syncNativeFilters() async {
    if (kIsWeb) return;

    if (!_isBlockerEnabled) {
      try {
        await _screenTimeChannel.invokeMethod('clearFilters');
      } catch (e) {
        debugPrint('Error clearing native filters: $e');
      }
      return;
    }

    final List<String> prioritizedDomains = [];
    final Set<String> seenDomains = {};
    final Set<String> bundleIdsToBlock = {};

    void addCleanDomain(String d) {
      final clean = d.trim().toLowerCase()
          .replaceAll(RegExp(r'https?://'), '')
          .replaceAll(RegExp(r'/.*'), '')
          .replaceAll(RegExp(r'^www\.'), '');
      if (clean.isNotEmpty && !seenDomains.contains(clean)) {
        seenDomains.add(clean);
        prioritizedDomains.add(clean);
      }
    }

    // 0. Top Priority Dynamic Mirrors & Custom Domains (guarantees inclusion within Apple's 50-domain native cap)
    final topPriorityMirrors = [
      '1-king-837.club',
      'meritking.club',
      'meritking837.com',
      'bets10-912.xyz',
      'jojobet-452.site',
      'cratos-385.top',
      'holiganbet999.vip',
    ];
    for (final domain in topPriorityMirrors) {
      addCleanDomain(domain);
    }

    // 1. User custom blocked domains (Highest user priority)
    for (final domain in _customBlockedDomains) {
      addCleanDomain(domain);
    }

    // 2. Server-managed Firestore blocked sites & bundle IDs
    for (final domain in _serverBlockedDomains) {
      addCleanDomain(domain);
    }
    bundleIdsToBlock.addAll(_serverBlockedBundleIds);

    // 2. Active category sample domains & bundle IDs
    for (final cat in _categories) {
      if (cat.isEnabled) {
        for (final domain in cat.sampleDomains) {
          addCleanDomain(domain);
        }
        bundleIdsToBlock.addAll(cat.sampleBundleIds);
      }
    }

    // 3. Preset core high-risk gambling root domains (WebDomain matches subdomains automatically)
    final presetDomains = [
      // Yasal Türkiye
      'nesine.com', 'misli.com', 'bilyoner.com', 'tuttur.com',
      'oley.com', 'birebin.com', 'iddaa.com', 'millipiyangoonline.com',
      'sisal-sans.com', 'tjk.org', 'atyarisi.com', 'ganyan.com',

      // İllegal Türkiye Bahis, Dynamic Mirror & Casino
      '1-king-837.club', 'meritking.club', 'meritking837.com', 'bets10-912.xyz',
      'jojobet-452.site', 'cratos-385.top', 'holiganbet999.vip',
      'bets10.com', '1xbet.com', 'tempobet.com', 'superbahis.com',
      'mobilbahis.com', 'betboo.com', 'betpas.com', 'sahabet.com',
      'tipobet.com', 'tipobet365.com', 'matbet.com', 'sekabet.com',
      'jojobet.com', 'holiganbet.com', 'grandpashabet.com', 'betwoon.com',
      'mariobet.com', 'retrobet.com', 'meritking.com', 'meritbet.com',
      'restbet.com', 'betebet.com', 'onwin.com', 'paribahis.com',
      'pashagamers.com', 'vegasbet.com', 'piabet.com', 'pinbahis.com',
      'betpark.com', 'betnano.com', 'betgaranti.com', 'betmarlo.com',
      'pokerklas.com', 'klasbahis.com', 'superbetin.com', 'youwin.com',
      'hepsi-bahis.com', 'bahsegel.com', 'betmatik.com', 'dumanbet.com',
      'lordbahis.com', 'lunabit.com', 'cratosbet.com', 'betist.com',
      'interbahis.com', 'hiltonbet.com', 'perabet.com', 'turbobet.com',
      'asyabahis.com', 'supertotobet.com', 'casinomaxi.com', 'casino-metropol.com',
      'discountcasino.com', 'anadolucasino.com', 'vdcasino.com', 'slotbar.com',
      'cratosslot.com', 'mroyun.com',

      // Global Betting & Crypto Casino
      'stake.com', 'stake.us', 'stake.bet', 'roobet.com', 'rollbit.com',
      'bc.game', 'gamdom.com', 'duelbits.com', 'shuffle.com', 'bet365.com',
      'unibet.com', 'bwin.com', 'betway.com', 'williamhill.com',
      'paddypower.com', 'ladbrokes.com', 'betfair.com', 'skybet.com',
      'betfred.com', 'bovada.lv', 'betonline.ag', 'sportsbetting.ag',
      'parimatch.com', 'mostbet.com', 'melbet.com', 'linebet.com',
      'megapari.com', 'betwinner.com', '22bet.com', 'fonbet.ru',
      'winline.ru', 'sportsbet.io', '1xbit.com', 'sweetbonanza.net',
      'pinup.casino', 'pin-up.bet', 'spinpalace.com', 'slots.io',
      '888casino.com', '888poker.com', '888sport.com', '888.com',
      'pokerstars.com', 'ggpoker.com', 'partypoker.com', 'cloudbet.com',
      'bitstarz.com', 'fortunejack.com', 'betsson.com', 'leovegas.com',
      'casumo.com', 'mrgreen.com', 'dunder.com', 'rizk.com', 'guts.com',
      'wildcasino.ag', 'slotozal.com', 'vulkan-casino.com', 'rubyfortune.com',
      'jackpotcitycasino.com', 'royalvegascasino.com', 'pragmaticplay.com',
      'evolution.com',

      // Forex & Trading Risk
      'olymptrade.com', 'iqoption.com', 'binomo.com', 'pocketoption.com',
      'quotex.io', 'quotex.com', 'expertoption.com', 'deriv.com',
      'binary.com', 'highlow.net', 'exness-leverage.com', 'forex-broker.net',

      // Gambling Ads Networks
      'bet-adnetwork.com', 'popup-gambling.net', 'betting-click.org',
      'gambling-pop.com', 'affiliate-bet.net', 'casinopopup.com',
      'betadserver.com',
    ];
    for (final domain in presetDomains) {
      addCleanDomain(domain);
    }

    // Mobile app bundle IDs (Turkish & Global gambling apps)
    final presetBundleIds = [
      'com.dms.nesine',
      'com.nesine.iphone',
      'com.nesine.app',
      'com.misli.iphone',
      'com.misli.app',
      'com.bilyoner.iphone',
      'com.bilyoner.app',
      'com.tuttur.iphone',
      'com.tuttur.app',
      'com.oley.iphone',
      'com.birebin.iphone',
      'com.iddaa.iphone',
      'com.iddaa.app',
      'com.sisal.millipiyango',
      'org.tjk.mobile',
      'com.bets10.app',
      'com.1xbet.app',
      'com.tempobet.app',
      'com.mobilbahis.app',
      'com.superbahis.app',
      'com.betboo.app',
      'com.tipobet.app',
      'com.matbet.app',
      'com.jojobet.app',
      'com.holiganbet.app',
      'com.bet365',
      'com.unibet.app',
      'com.bwin.app',
      'com.mostbet.app',
      'com.melbet.app',
      'com.parimatch.app',
      'com.betway.app',
      'com.casinomaxi.app',
      'com.pinup.casino',
      'com.spinpalace.app',
      'com.casinometropol.app',
      'com.stake.app',
      'com.roobet.app',
      'com.pokerstars.app',
      'com.ggpoker.app',
      'com.888casino',
      'com.leovegas.app',
      'com.olymptrade',
      'com.iqoption',
      'com.binomo',
      'com.pocketoption',
      'com.quotex',
      'com.exness.app',
      'com.expertoption',
    ];
    bundleIdsToBlock.addAll(presetBundleIds);

    try {
      await _screenTimeChannel.invokeMethod('setBlockedDomains', {
        'domains': prioritizedDomains,
        'bundleIds': bundleIdsToBlock.toList(),
      });
      await _syncAntiBypassSettings();
    } catch (e) {
      debugPrint('Error syncing native filters: $e');
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
    _isOnboarded = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_is_onboarded', true);
    await prefs.setString('nora_user_profile', profile.toJson());
  }

  Future<void> activateSubscription({
    required String plan,
    bool isTrial = true,
    DateTime? trialEndsAt,
  }) async {
    _isSubscribed = true;
    _activePlan = plan;
    _isInTrial = isTrial;
    _trialEndsAt = trialEndsAt ??
        (isTrial
            ? DateTime.now().add(Duration(days: plan == 'annual' ? 7 : 3))
            : null);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_is_subscribed', true);
    await prefs.setString('nora_active_plan', plan);
    await prefs.setBool('nora_is_in_trial', _isInTrial);
    if (_trialEndsAt != null) {
      await prefs.setInt('nora_trial_ends_at_ms', _trialEndsAt!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('nora_trial_ends_at_ms');
    }

    // Instant real-time update to Firestore and FCM topic
    unawaited(FirebaseService.syncUserAndTopics(isPremium: true));

    // Cancel any pending 5-minute abandoned trial push notification
    unawaited(FirebaseService.cancelAbandonedTrialNotification());

    // Record conversion attribution for notification campaign analytics
    unawaited(FirebaseService.recordConversionAttribution(plan: plan));
  }

  String _computeResolvedLanguage(String pref) {
    if (pref == 'tr' || pref == 'en') return pref;
    try {
      final locales = WidgetsBinding.instance.platformDispatcher.locales;
      if (locales.isNotEmpty) {
        final code = locales.first.languageCode.toLowerCase();
        return code.startsWith('tr') ? 'tr' : 'en';
      }
      final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode.toLowerCase();
      return code.startsWith('tr') ? 'tr' : 'en';
    } catch (_) {
      return 'en';
    }
  }

  Future<void> setLanguage(String pref) async {
    if (_languagePreference == pref) return;
    _languagePreference = pref;
    _resolvedLanguage = _computeResolvedLanguage(pref);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nora_language_preference', pref);

    unawaited(FirebaseService.syncUserAndTopics(isPremium: _isSubscribed));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString('nora_theme_mode', str);
  }

  Future<void> toggleBlocker(bool enabled) async {
    _isBlockerEnabled = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_blocker_enabled', enabled);

    await syncNativeFilters();
  }

  Future<void> toggleStrictShield(bool enabled) async {
    _strictShieldMode = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_strict_shield', enabled);
  }

  Future<void> toggleCategory(String categoryId) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _categories[index].isEnabled = !_categories[index].isEnabled;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final mapped = _categories.map((c) => c.toMap()).toList();
      await prefs.setString('nora_categories', json.encode(mapped));

      await syncNativeFilters();
    }
  }

  Future<Map<String, dynamic>?> presentAddCustomDomainSheet() async {
    if (kIsWeb) return null;
    try {
      final res = await _screenTimeChannel.invokeMethod('presentAddDomainSheet', {
        'languageCode': languageCode,
      });
      if (res != null && res is Map) {
        final domain = res['domain'] as String?;
        if (domain != null && domain.trim().isNotEmpty) {
          await addCustomDomain(domain);
          return Map<String, dynamic>.from(res);
        }
      }
      return null;
    } on MissingPluginException {
      debugPrint('[Nora] Native add domain sheet not yet loaded in running binary. Rebuilding app is required.');
      rethrow;
    } catch (e) {
      debugPrint('Error presenting native add domain sheet: $e');
      return null;
    }
  }

  Future<JournalEntry?> presentAddJournalEntrySheet() async {
    if (kIsWeb) return null;
    try {
      final res = await _screenTimeChannel.invokeMethod('presentAddJournalEntrySheet', {
        'languageCode': languageCode,
      });
      if (res != null && res is Map) {
        final defaultMood = languageCode == 'tr' ? 'Sakin' : 'Calm';
        final mood = (res['mood'] as String?) ?? defaultMood;
        final cravingLevel = (res['cravingLevel'] as num?)?.toInt() ?? 1;
        final rawTriggers = res['triggers'] ?? res['triggersEncountered'];
        final triggers = rawTriggers is List ? List<String>.from(rawTriggers) : <String>[];
        final note = (res['note'] as String?) ?? '';

        final entry = JournalEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          cravingLevel: cravingLevel,
          mood: mood,
          triggersEncountered: triggers,
          note: note,
        );
        await addJournalEntry(entry);
        return entry;
      }
      return null;
    } on MissingPluginException {
      debugPrint('[Nora] Native journal entry sheet not yet loaded in running binary.');
      rethrow;
    } catch (e) {
      debugPrint('Error presenting native journal entry sheet: $e');
      return null;
    }
  }

  Future<void> addCustomDomain(String domain) async {
    final clean = domain.trim().toLowerCase().replaceAll(RegExp(r'https?://'), '').replaceAll(RegExp(r'/.*'), '');
    if (clean.isNotEmpty && !_customBlockedDomains.contains(clean)) {
      _customBlockedDomains.add(clean);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('nora_custom_domains', _customBlockedDomains);

      // Also persist to Firestore server database so it syncs across all devices automatically
      unawaited(FirebaseService.addBlockedSiteToFirestore(domain: clean, category: 'custom'));

      await syncNativeFilters();
    }
  }

  Future<void> removeCustomDomain(String domain) async {
    _customBlockedDomains.remove(domain);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nora_custom_domains', _customBlockedDomains);

    unawaited(FirebaseService.removeBlockedSiteFromFirestore(domain));

    await syncNativeFilters();
  }

  /// Adds a new blocked site directly to Firestore server database
  Future<void> addBlockedSiteToServer({
    required String domain,
    String? category,
    String? bundleId,
    String? title,
    String? description,
  }) async {
    await FirebaseService.addBlockedSiteToFirestore(
      domain: domain,
      category: category,
      bundleId: bundleId,
      title: title,
      description: description,
    );
  }

  /// Removes a blocked site directly from Firestore server database
  Future<void> removeBlockedSiteFromServer(String domain) async {
    await FirebaseService.removeBlockedSiteFromFirestore(domain);
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    _journalEntries.insert(0, entry);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final raw = _journalEntries.map((e) => e.toJson()).toList();
    await prefs.setStringList('nora_journal_entries', raw);
  }

  Future<void> resetQuitDate() async {
    final updated = UserProfile(
      monthlySpend: _userProfile.monthlySpend,
      hoursPerDay: _userProfile.hoursPerDay,
      selectedAddictions: _userProfile.selectedAddictions,
      selectedTriggers: _userProfile.selectedTriggers,
      mainMotivation: _userProfile.mainMotivation,
      quitDate: DateTime.now(),
      currencySymbol: _userProfile.currencySymbol,
    );
    await saveUserProfile(updated);
  }

  Future<void> resetFullApp() async {
    await revokeNativePermissions();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isOnboarded = false;
    _isSubscribed = false;
    _isInTrial = false;
    _trialEndsAt = null;
    _languagePreference = 'system';
    _resolvedLanguage = _computeResolvedLanguage('system');
    _userProfile = UserProfile.defaultProfile();
    _categories = BlockerCategory.getDefaultCategories();
    _customBlockedDomains = [];
    _journalEntries = [];
    _isBlockerEnabled = true;
    _strictShieldMode = true;
    _nativeAuthStatus = 'notDetermined';
    _shieldedAppsCount = 0;
    _shieldedCategoriesCount = 0;
    _shieldedWebDomainsCount = 0;
    notifyListeners();

    // Instant real-time update to Firestore and FCM topic
    unawaited(FirebaseService.syncUserAndTopics(isPremium: false));
  }

  // Domain Check Engine Simulation
  DomainCheckResult checkDomain(String urlOrDomain) {
    if (!_isBlockerEnabled) {
      return DomainCheckResult(
        domain: urlOrDomain,
        isBlocked: false,
        reason: 'Koruma Kalkanı kapalı.',
      );
    }

    final clean = urlOrDomain.trim().toLowerCase().replaceAll(RegExp(r'https?://'), '').replaceAll(RegExp(r'/.*'), '');

    // 1. Check Firestore server-managed blocked domains
    for (final serverDomain in _serverBlockedDomains) {
      if (clean.contains(serverDomain) || serverDomain.contains(clean)) {
        return DomainCheckResult(
          domain: clean,
          isBlocked: true,
          matchedCategory: 'Sunucu Tarafından Engellenen Site (Firestore)',
          reason: 'Bu alan adı Firestore veritabanı tarafından otomatik olarak engellenmiştir.',
        );
      }
    }

    // 2. Check custom domains
    for (final custom in _customBlockedDomains) {
      if (clean.contains(custom)) {
        return DomainCheckResult(
          domain: clean,
          isBlocked: true,
          matchedCategory: 'Özel Engelleme Listesi',
          reason: 'Bu alan adı sizin özel engelleme listenizde yer alıyor.',
        );
      }
    }

    // 3. Dynamic Mirror Pattern & TLD Filter (Catches generated domains like 1-king-837.club, meritking837.com, bets10-912.xyz)
    final dynamicMirrorResult = _checkDynamicMirrorPattern(clean);
    if (dynamicMirrorResult != null) {
      return dynamicMirrorResult;
    }

    // 4. Keyword & category rules
    final gamblingKeywords = [
      'bet', 'casino', 'slot', 'bahis', 'poker', 'rulet', 'bonanza',
      'iddaa', 'kumar', 'forex', 'binomo', 'olymptrade', 'leverage',
      'tempobet', 'bets10', '1xbet', 'mobilbahis', 'superbahis', 'casinomaxi',
      'nesine', 'misli', 'bilyoner', 'tuttur', 'oley', 'birebin',
      'stake', 'roobet', 'rollbit', 'bwin', 'unibet', 'bet365', 'betway',
      'parimatch', 'mostbet', 'melbet', 'meritking', 'matbet', 'jojobet',
      'sekabet', 'holiganbet', 'cratos', 'grandpashabet', 'parimatch',
    ];

    for (final cat in _categories) {
      if (!cat.isEnabled) continue;

      for (final sample in cat.sampleDomains) {
        if (clean.contains(sample) || sample.contains(clean)) {
          return DomainCheckResult(
            domain: clean,
            isBlocked: true,
            matchedCategory: cat.title,
            reason: '${cat.title} kategorisi kapsamında erişim engellendi!',
          );
        }
      }
    }

    for (final kw in gamblingKeywords) {
      if (clean.contains(kw)) {
        return DomainCheckResult(
          domain: clean,
          isBlocked: true,
          matchedCategory: 'Otomatik Bahis & Kumar Tespiti',
          reason: 'Zararlı kumar/bahis anahtar kelimesi ("$kw") tespit edildi!',
        );
      }
    }

    return DomainCheckResult(
      domain: clean,
      isBlocked: false,
      reason: 'Güvenli alan adı. Herhangi bir kumar/bahis içeriği tespit edilmedi.',
    );
  }

  /// Advanced dynamic mirror pattern and TLD detection (e.g., 1-king-837.club, meritking837.com, bets10-912.xyz)
  DomainCheckResult? _checkDynamicMirrorPattern(String cleanDomain) {
    final suspiciousTlds = {
      'club', 'xyz', 'site', 'fun', 'online', 'top', 'vip', 'link', 'bet',
      'casino', 'live', 'win', 'monster', 'cyou', 'bid', 'click', 'party',
      'trade', 'rest', 'tokyo', 'zone', 'cc', 'icu', 'website', 'work', 'shop'
    };

    final brandRoots = [
      'king', 'merit', 'bets', 'bet', 'jojo', 'mat', 'seka', 'holigan',
      'slot', 'casino', 'pash', 'cratos', 'bahis', 'bonanza', 'win', 'spin',
      'rulet', 'poker', 'woon', 'mario', 'retro', 'parimatch', 'mostbet',
      'melbet', 'stake', 'roobet', 'tipobet', 'tempobet', '1xbet',
      'mobilbahis', 'superbahis', 'casinomaxi', 'bwin', 'unibet'
    ];

    final parts = cleanDomain.split('.');
    if (parts.length >= 2) {
      final tld = parts.last;
      final domainBody = parts[parts.length - 2];

      // 1. Dynamic mirror pattern: hyphenated/numbered prefix/suffix + gambling brand (e.g. 1-king-837, meritking-837)
      final mirrorPattern = RegExp(
        r'^(?:\d+[-_]?)?(?:' + brandRoots.join('|') + r')(?:[-_]?\d+)?$',
        caseSensitive: false,
      );

      if (mirrorPattern.hasMatch(domainBody)) {
        return DomainCheckResult(
          domain: cleanDomain,
          isBlocked: true,
          matchedCategory: 'Dinamik Ayna Kumar Sitesi (AI Pattern Filter)',
          reason: 'Dinamik illegal kumar ayna adresi ("$domainBody.$tld") otomatik kalkan tarafından engellendi.',
        );
      }

      // 2. Suspicious TLD + Gambling brand root
      if (suspiciousTlds.contains(tld)) {
        for (final root in brandRoots) {
          if (domainBody.contains(root)) {
            return DomainCheckResult(
              domain: cleanDomain,
              isBlocked: true,
              matchedCategory: 'Şüpheli TLD Kumar Ayna Filtresi',
              reason: 'Şüpheli kumar uzantısı (.$tld) ve kumar markası ("$root") tespit edilerek erişim engellendi.',
            );
          }
        }
      }
    }
    return null;
  }

  void _startVpnMonitoring() {
    _vpnPollingTimer?.cancel();
    checkVpnStatus();
    _vpnPollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkVpnStatus();
    });
  }

  Future<void> checkVpnStatus() async {
    try {
      final res = await _screenTimeChannel.invokeMethod('checkVpnStatus');
      if (res is Map) {
        final vpn = res['isVpnActive'] as bool? ?? false;
        final proxy = res['isProxyActive'] as bool? ?? false;
        final iface = res['interface'] as String? ?? '';
        if (vpn != _isVpnActive || proxy != _isProxyActive || iface != _vpnInterface) {
          _isVpnActive = vpn;
          _isProxyActive = proxy;
          _vpnInterface = iface;
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  Future<void> toggleAntiBypass(bool enabled) async {
    _antiBypassEnabled = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_anti_bypass', enabled);

    await _syncAntiBypassSettings();
    await FirebaseService.updateAntiBypassStatus(enabled: enabled);
  }

  Future<void> _syncAntiBypassSettings() async {
    try {
      // Restrict removing Nora, while ensuring App Store remains visible and accessible
      await _screenTimeChannel.invokeMethod('setAntiBypassProtection', {
        'denyAppRemoval': _antiBypassEnabled,
        'denyAppInstallation': false,
      });
    } catch (e) {
      debugPrint('Error syncing anti-bypass settings: $e');
    }
  }

  @override
  void dispose() {
    _vpnPollingTimer?.cancel();
    FirebaseService.stopUserRealtimeListener();
    super.dispose();
  }
}
