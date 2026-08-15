import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/blocker_category.dart';
import '../models/journal_entry.dart';

class AppState extends ChangeNotifier {
  static const MethodChannel _screenTimeChannel = MethodChannel('com.nora.blocker/screentime');

  bool _isLoading = true;
  bool _isOnboarded = false;
  bool _isSubscribed = false;
  String _activePlan = 'annual'; // 'monthly' or 'annual'

  UserProfile _userProfile = UserProfile.defaultProfile();
  List<BlockerCategory> _categories = BlockerCategory.getDefaultCategories();
  List<String> _customBlockedDomains = [];
  bool _isBlockerEnabled = true;
  bool _strictShieldMode = true;
  List<JournalEntry> _journalEntries = [];

  String _nativeAuthStatus = 'unknown'; // 'approved', 'denied', 'notDetermined', 'unsupported', 'unknown'
  int _shieldedAppsCount = 0;
  int _shieldedCategoriesCount = 0;

  bool get isLoading => _isLoading;
  bool get isOnboarded => _isOnboarded;
  bool get isSubscribed => _isSubscribed;
  String get activePlan => _activePlan;
  UserProfile get userProfile => _userProfile;
  List<BlockerCategory> get categories => _categories;
  List<String> get customBlockedDomains => _customBlockedDomains;
  bool get isBlockerEnabled => _isBlockerEnabled;
  bool get strictShieldMode => _strictShieldMode;
  List<JournalEntry> get journalEntries => _journalEntries;
  String get nativeAuthStatus => _nativeAuthStatus;
  int get shieldedAppsCount => _shieldedAppsCount;
  int get shieldedCategoriesCount => _shieldedCategoriesCount;
  bool get hasShieldedApps => (_shieldedAppsCount + _shieldedCategoriesCount) > 0;

  AppState() {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboarded = prefs.getBool('nora_is_onboarded') ?? false;
      _isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
      _activePlan = prefs.getString('nora_active_plan') ?? 'annual';
      _isBlockerEnabled = true;
      _strictShieldMode = true;

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
    } catch (e) {
      debugPrint('Error loading app state: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> fetchShieldedAppInfo() async {
    if (kIsWeb) return;
    try {
      final res = await _screenTimeChannel.invokeMethod('getShieldedAppInfo');
      if (res != null && res is Map) {
        _shieldedAppsCount = (res['appsCount'] as num?)?.toInt() ?? 0;
        _shieldedCategoriesCount = (res['catsCount'] as num?)?.toInt() ?? 0;
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

    final Set<String> domainsToBlock = {};
    final Set<String> bundleIdsToBlock = {};

    // Add custom domains
    domainsToBlock.addAll(_customBlockedDomains);

    // Add category sample domains & bundle IDs
    for (final cat in _categories) {
      if (cat.isEnabled) {
        domainsToBlock.addAll(cat.sampleDomains);
        bundleIdsToBlock.addAll(cat.sampleBundleIds);
      }
    }

    // Default high risk gambling domains & mobile API endpoints
    final presetDomains = [
      'bets10.com',
      'api.bets10.com',
      'm.bets10.com',
      'casinomaxi.com',
      'api.casinomaxi.com',
      'olymptrade.com',
      'api.olymptrade.com',
      'sweetbonanza.net',
      'tempobet.com',
      'api.tempobet.com',
      '1xbet.com',
      'api.1xbet.com',
      'mobilbahis.com',
      'superbahis.com',
      'binomo.com',
      'nesine.com',
      'api.nesine.com',
      'm.nesine.com',
      'dms.nesine.com',
      'ws.nesine.com',
      'iddaa.nesine.com',
      'misli.com',
      'api.misli.com',
      'm.misli.com',
      'mobile.misli.com',
      'bilyoner.com',
      'api.bilyoner.com',
      'm.bilyoner.com',
      'tuttur.com',
      'api.tuttur.com',
      'm.tuttur.com',
      'oley.com',
      'api.oley.com',
      'birebin.com',
      'api.birebin.com',
      'iddaa.com',
      'api.iddaa.com',
      'm.iddaa.com',
    ];
    domainsToBlock.addAll(presetDomains);

    // Default mobile app bundle IDs (Turkish & Global gambling apps)
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
      'com.bets10.app',
      'com.1xbet.app',
      'com.olymptrade',
      'com.iqoption',
      'com.binomo',
    ];
    bundleIdsToBlock.addAll(presetBundleIds);

    try {
      await _screenTimeChannel.invokeMethod('setBlockedDomains', {
        'domains': domainsToBlock.toList(),
        'bundleIds': bundleIdsToBlock.toList(),
      });
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

  Future<void> activateSubscription({required String plan}) async {
    _isSubscribed = true;
    _activePlan = plan;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nora_is_subscribed', true);
    await prefs.setString('nora_active_plan', plan);
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

  Future<void> addCustomDomain(String domain) async {
    final clean = domain.trim().toLowerCase().replaceAll(RegExp(r'https?://'), '').replaceAll(RegExp(r'/.*'), '');
    if (clean.isNotEmpty && !_customBlockedDomains.contains(clean)) {
      _customBlockedDomains.add(clean);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('nora_custom_domains', _customBlockedDomains);

      await syncNativeFilters();
    }
  }

  Future<void> removeCustomDomain(String domain) async {
    _customBlockedDomains.remove(domain);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nora_custom_domains', _customBlockedDomains);

    await syncNativeFilters();
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isOnboarded = false;
    _isSubscribed = false;
    _userProfile = UserProfile.defaultProfile();
    _categories = BlockerCategory.getDefaultCategories();
    _customBlockedDomains = [];
    _journalEntries = [];
    _isBlockerEnabled = true;
    _strictShieldMode = true;
    notifyListeners();
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

    // Check custom domains
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

    // Keyword & category rules
    final gamblingKeywords = [
      'bet', 'casino', 'slot', 'bahis', 'poker', 'rulet', 'bonanza',
      'iddaa', 'kumar', 'forex', 'binomo', 'olymptrade', 'leverage',
      'tempobet', 'bets10', '1xbet', 'mobilbahis', 'superbahis', 'casinomaxi',
      'nesine', 'misli', 'bilyoner', 'tuttur', 'oley', 'birebin',
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
}
