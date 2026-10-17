import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../firebase_options.dart';
import '../l10n/app_strings.dart';
import '../models/blocker_category.dart';
import 'predictive_domain_engine.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  debugPrint('FCM Background message: ${message.messageId} | data: ${message.data}');
  await FirebaseService.handleSilentPushSync(message.data);
}

class FirebaseService {
  FirebaseService._();

  static const String _prefUserIdKey = 'nora_firebase_user_id';
  static const String _prefSubscribedNonPremiumTopicKey = 'nora_fcm_non_premium_topic';
  static const String _prefSubscribedPremiumTopicKey = 'nora_fcm_premium_topic';
  static const String _prefLastClickedCampaignIdKey = 'nora_last_clicked_campaign_id';
  static const String _prefLastClickedCampaignTimeKey = 'nora_last_clicked_campaign_time';
  static const String _prefLastClickedCampaignScreenKey = 'nora_last_clicked_campaign_screen';

  /// Global callback triggered when a user taps a notification with an actionable payload
  static void Function(Map<String, dynamic> data)? onNotificationAction;

  /// Global callback triggered when a silent push updates the blocked filter list
  static void Function(List<String> domains)? onSilentPushFilterUpdated;

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static String? _currentUserId;
  static String? _latestFcmToken;
  static String? _lastHandledNotificationId;
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSnapshotSubscription;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _blockedSitesSnapshotSubscription;
  static bool _isWaitingForApns = false;

  static String? get currentUserId => _currentUserId;
  static String? get latestFcmToken => _latestFcmToken;

  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseMessaging? _messaging;
  static FirebaseFirestore? _firestore;
  static FirebaseInAppMessaging? _inAppMessaging;
  static FlutterLocalNotificationsPlugin? _localNotifications;

  static FirebaseAnalytics get analytics =>
      _analytics ?? FirebaseAnalytics.instance;
  static FirebaseCrashlytics get crashlytics =>
      _crashlytics ?? FirebaseCrashlytics.instance;
  static FirebaseMessaging get messaging =>
      _messaging ?? FirebaseMessaging.instance;
  static FirebaseFirestore get firestore =>
      _firestore ?? FirebaseFirestore.instance;
  static FirebaseInAppMessaging get inAppMessaging =>
      _inAppMessaging ?? FirebaseInAppMessaging.instance;
  static FlutterLocalNotificationsPlugin get localNotifications =>
      _localNotifications ?? FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kIsWeb ||
          (defaultTargetPlatform != TargetPlatform.iOS &&
              defaultTargetPlatform != TargetPlatform.macOS)) {
        debugPrint(
            'FirebaseService: Platform ${defaultTargetPlatform.name} is not configured yet. Skipping Firebase init.');
        return;
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _messaging = FirebaseMessaging.instance;
      _firestore = FirebaseFirestore.instance;
      _inAppMessaging = FirebaseInAppMessaging.instance;

      // Crashlytics setup
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Firestore settings (offline persistence)
      _firestore?.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // In-App Messaging setup: ensure messages are not suppressed
      try {
        await _inAppMessaging?.setMessagesSuppressed(false);
        await _inAppMessaging?.setAutomaticDataCollectionEnabled(true);
      } catch (e) {
        debugPrint('Error setting up In-App Messaging: $e');
      }

      // Local notifications setup for foreground banner display
      try {
        _localNotifications = FlutterLocalNotificationsPlugin();
        const darwinSettings = DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );
        const initSettings = InitializationSettings(
          iOS: darwinSettings,
          macOS: darwinSettings,
        );
        await _localNotifications?.initialize(
          settings: initSettings,
          onDidReceiveNotificationResponse: (response) {
            debugPrint('Local notification clicked: ${response.payload}');
            if (response.payload != null && response.payload!.isNotEmpty) {
              try {
                final Map<String, dynamic> data = json.decode(response.payload!);
                onNotificationAction?.call(data);
              } catch (_) {
                onNotificationAction?.call({'screen': 'paywall', 'payload': response.payload});
              }
            } else {
              onNotificationAction?.call({'screen': 'paywall'});
            }
          },
        );
      } catch (e) {
        debugPrint('Error initializing local notifications: $e');
      }

      // FCM Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Presentation options for foreground notifications
      await _messaging?.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen for foreground messages & show banner via local notifications only when not auto-presented by iOS
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM Foreground message: ${message.notification?.title} - ${message.notification?.body}');
        // Handle any incoming silent push filter synchronization immediately
        handleSilentPushSync(message.data);

        // On iOS, setForegroundNotificationPresentationOptions already presents the push banner natively.
        // Calling _localNotifications?.show() on iOS causes the exact same notification to appear twice!
        if (defaultTargetPlatform != TargetPlatform.iOS) {
          final notification = message.notification;
          if (notification != null) {
            _localNotifications?.show(
              id: notification.hashCode,
              title: notification.title,
              body: notification.body,
              notificationDetails: const NotificationDetails(
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                ),
              ),
              payload: message.data.toString(),
            );
          }
        }
      });

      // Listen for background-to-foreground notification clicks
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        debugPrint('FCM Message opened from background: ${message.data}');
        final msgId = message.messageId;
        if (msgId != null && msgId == _lastHandledNotificationId) {
          debugPrint('FCM duplicate message ignored: $msgId');
          return;
        }
        if (msgId != null) {
          _lastHandledNotificationId = msgId;
        }
        final campaignId = message.data['campaign_id'] ?? message.data['campaign'];
        if (campaignId != null && campaignId.toString().isNotEmpty) {
          await recordNotificationClick(
            campaignId: campaignId.toString(),
            data: message.data,
          );
        }
        onNotificationAction?.call(message.data);
      });

      _messaging?.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token refreshed: $newToken');
        _latestFcmToken = newToken;
        if (_currentUserId != null && _firestore != null) {
          try {
            _firestore?.collection('users').doc(_currentUserId).set({
              'fcmToken': newToken,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          } catch (e) {
            debugPrint('Error updating refreshed FCM token in Firestore: $e');
          }
        }
        try {
          final prefs = await SharedPreferences.getInstance();
          final isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
          await _subscribeToBroadcastTopics();
          await syncUserAndTopics(isPremium: isSubscribed, fcmToken: newToken);
        } catch (e) {
          debugPrint('Error resyncing topics on token refresh: $e');
        }
      });

      _isInitialized = true;
      debugPrint('FirebaseService initialized successfully.');
    } catch (e, stack) {
      debugPrint('FirebaseService initialization failed: $e');
      if (kDebugMode) {
        debugPrintStack(stackTrace: stack);
      }
    }
  }

  // --- Notification Permission & Campaign Topic Subscription ---

  static bool _hasRequestedPermission = false;
  static bool get hasRequestedPermission => _hasRequestedPermission;

  /// Requests notification permissions, retrieves tokens and subscribes to campaign topics.
  /// Intentionally called after the splash screen finishes and the first screen renders.
  static Future<NotificationSettings?> requestNotificationPermissions() async {
    if (_hasRequestedPermission) return null;
    _hasRequestedPermission = true;

    try {
      if (!_isInitialized) {
        await initialize();
      }

      final settings = await _messaging?.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('FCM authorization status: ${settings?.authorizationStatus}');

      // On iOS, APNs token generation is asynchronous between device and Apple.
      // We must wait for the APNs token to be ready before minting the FCM token
      // and registering for broadcast campaign topics.
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        String? apnsToken = await _messaging?.getAPNSToken();
        int attempts = 0;
        while (apnsToken == null && attempts < 15) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await _messaging?.getAPNSToken();
          attempts++;
        }
        if (apnsToken != null) {
          debugPrint('🔥 [FCM] APNs Token ready after $attempts attempts: $apnsToken');
        } else {
          debugPrint('⏳ [FCM] APNs Token not yet ready after 7.5s. Polling in background...');
          final prefs = await SharedPreferences.getInstance();
          final isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
          _waitForApnsAndResync(isPremium: isSubscribed);
        }
      }

      // Retrieve FCM registration token (now linked to APNs)
      String? token;
      try {
        token = await _messaging?.getToken();
        if (token != null) {
          _latestFcmToken = token;
          debugPrint('''
======================================================================
🔥 [NORA FCM REGISTRATION TOKEN]
Copy this token to send test notifications from Firebase Console:
$token
======================================================================''');
        }
      } catch (tokenError) {
        debugPrint('⏳ [FCM] APNs token is still pending, FCM token will be fetched once APNs completes: $tokenError');
      }

      // Subscribe to default campaign topics so broadcast campaigns always arrive
      await _subscribeToBroadcastTopics();

      // Sync non-premium / language topic & Firestore user table with token
      try {
        final prefs = await SharedPreferences.getInstance();
        final isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
        await syncUserAndTopics(isPremium: isSubscribed, fcmToken: token);
      } catch (e) {
        debugPrint('⚠️ [FCM] Initial user sync error after token fetch: $e');
      }

      return settings;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return null;
    }
  }

  /// Subscribes to common broadcast campaign topics
  static Future<void> _subscribeToBroadcastTopics() async {
    try {
      await _messaging?.subscribeToTopic('all');
      await _messaging?.subscribeToTopic('nora_users');
      await _messaging?.subscribeToTopic('campaigns');
      debugPrint('🔥 [FCM] Successfully subscribed to broadcast topics ("all", "nora_users", "campaigns")');
    } catch (e) {
      debugPrint('⚠️ [FCM] Topic subscription error: $e');
    }
  }

  /// Polls asynchronously for APNs token on iOS when not immediately available at startup.
  static void _waitForApnsAndResync({required bool isPremium}) {
    if (_isWaitingForApns || defaultTargetPlatform != TargetPlatform.iOS) return;
    _isWaitingForApns = true;

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final apns = await _messaging?.getAPNSToken();
        if (apns != null) {
          timer.cancel();
          _isWaitingForApns = false;
          debugPrint('🔥 [FCM] APNs token arrived asynchronously: $apns');
          final token = await _messaging?.getToken();
          if (token != null) {
            _latestFcmToken = token;
          }
          await _subscribeToBroadcastTopics();
          await syncUserAndTopics(isPremium: isPremium, fcmToken: token);
        } else if (timer.tick >= 30) {
          timer.cancel();
          _isWaitingForApns = false;
          debugPrint('⚠️ [FCM] APNs token polling timed out after 30s.');
        }
      } catch (e) {
        debugPrint('⚠️ [FCM] Error polling for APNs token: $e');
      }
    });
  }

  // --- User Document & Real-time Language/Topic Management ---

  /// Retrieves or creates a persistent unique user ID for this install.
  static Future<String> getOrCreateUserId() async {
    if (_currentUserId != null && _currentUserId!.isNotEmpty) {
      return _currentUserId!;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.getString(_prefUserIdKey);
      if (id == null || id.isEmpty) {
        final rand = (Random().nextInt(900000) + 100000).toString();
        id = 'user_${DateTime.now().millisecondsSinceEpoch}_$rand';
        await prefs.setString(_prefUserIdKey, id);
      }
      _currentUserId = id;
      await setUserId(id);
      return id;
    } catch (e) {
      debugPrint('Error getting or creating user ID: $e');
      final fallback = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _currentUserId = fallback;
      return fallback;
    }
  }

  /// Extracts the device language code (e.g. 'tr', 'en', 'de').
  /// Defaults to 'en' if undetectable or empty.
  static String getDeviceLanguage() {
    try {
      final code = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
      final clean = code.replaceAll(RegExp(r'[^a-z]'), '');
      return clean.isNotEmpty ? clean : 'en';
    } catch (_) {
      return 'en';
    }
  }

  /// Returns full locale string (e.g. 'tr_TR', 'en_US').
  static String getDeviceLocale() {
    try {
      return PlatformDispatcher.instance.locale.toString();
    } catch (_) {
      return 'en';
    }
  }

  /// Generates the topic name for a non-premium user in a specific language.
  /// Example: 'non_premium_tr', 'non_premium_en'.
  static String getNonPremiumTopicForLanguage(String languageCode) {
    final clean = languageCode.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return 'non_premium_${clean.isNotEmpty ? clean : 'en'}';
  }

  /// Generates the topic name for a premium user in a specific language.
  /// Example: 'premium_tr', 'premium_en'.
  static String getPremiumTopicForLanguage(String languageCode) {
    final clean = languageCode.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return 'premium_${clean.isNotEmpty ? clean : 'en'}';
  }

  /// Synchronizes user profile and FCM topic subscription in real-time.
  ///
  /// - When [isPremium] is false:
  ///   Subscribes to `non_premium_<deviceLanguage>` (e.g. 'non_premium_tr')
  ///   and unsubscribes from premium topics (`premium_<lang>`, 'premium_users').
  ///
  /// - When [isPremium] is true:
  ///   Subscribes to `premium_<deviceLanguage>` (e.g. 'premium_tr') and 'premium_users'
  ///   and unsubscribes from `non_premium_<deviceLanguage>`.
  static Future<void> syncUserAndTopics({
    required bool isPremium,
    String? fcmToken,
  }) async {
    try {
      final userId = await getOrCreateUserId();
      final lang = getDeviceLanguage();
      final targetNonPremiumTopic = getNonPremiumTopicForLanguage(lang);
      final targetPremiumTopic = getPremiumTopicForLanguage(lang);
      const globalPremiumTopic = 'premium_users';

      final prefs = await SharedPreferences.getInstance();
      final previousNonPremiumTopic = prefs.getString(_prefSubscribedNonPremiumTopicKey);
      final previousPremiumTopic = prefs.getString(_prefSubscribedPremiumTopicKey);

      if (fcmToken != null && fcmToken.isNotEmpty) {
        _latestFcmToken = fcmToken;
      }

      // On iOS, verify APNs token availability before attempting topic subscription.
      // Calling subscribeToTopic without APNs token on iOS throws [apns-token-not-set].
      bool canSubscribeToTopics = true;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apns = await _messaging?.getAPNSToken();
        if (apns == null) {
          canSubscribeToTopics = false;
          debugPrint('⏳ [FCM] APNs token not yet available on iOS. Deferring topic subscription...');
          _waitForApnsAndResync(isPremium: isPremium);
        }
      }

      // Handle FCM Topic Subscriptions
      if (canSubscribeToTopics) {
        if (!isPremium) {
        // 1. Unsubscribe from all premium topics
        final premiumTopicsToRemove = {
          ...?previousPremiumTopic != null ? [previousPremiumTopic] : null,
          targetPremiumTopic,
          globalPremiumTopic,
        };
        for (final topic in premiumTopicsToRemove) {
          try {
            await _messaging?.unsubscribeFromTopic(topic);
            debugPrint('🔥 [FCM] Unsubscribed from premium topic: $topic (User not premium)');
          } catch (e) {
            debugPrint('⚠️ [FCM] Error unsubscribing from $topic: $e');
          }
        }
        await prefs.remove(_prefSubscribedPremiumTopicKey);

        // 2. Unsubscribe from old non-premium topic if language changed
        if (previousNonPremiumTopic != null && previousNonPremiumTopic != targetNonPremiumTopic) {
          try {
            await _messaging?.unsubscribeFromTopic(previousNonPremiumTopic);
            debugPrint('🔥 [FCM] Unsubscribed from old non-premium topic: $previousNonPremiumTopic');
          } catch (e) {
            debugPrint('⚠️ [FCM] Error unsubscribing from $previousNonPremiumTopic: $e');
          }
        }

        // 3. Subscribe to current language non-premium topic
        try {
          await _messaging?.subscribeToTopic(targetNonPremiumTopic);
          await prefs.setString(_prefSubscribedNonPremiumTopicKey, targetNonPremiumTopic);
          debugPrint('🔥 [FCM] Subscribed to non-premium topic: $targetNonPremiumTopic');
        } catch (e) {
          debugPrint('⚠️ [FCM] Error subscribing to $targetNonPremiumTopic: $e');
        }
      } else {
        // User is Premium:
        // 1. Unsubscribe from all non-premium topics immediately!
        final nonPremiumTopicsToRemove = {
          ...?previousNonPremiumTopic != null ? [previousNonPremiumTopic] : null,
          targetNonPremiumTopic,
        };
        for (final topic in nonPremiumTopicsToRemove) {
          try {
            await _messaging?.unsubscribeFromTopic(topic);
            debugPrint('🔥 [FCM] Unsubscribed from non-premium topic: $topic (User is Premium)');
          } catch (e) {
            debugPrint('⚠️ [FCM] Error unsubscribing from $topic: $e');
          }
        }
        await prefs.remove(_prefSubscribedNonPremiumTopicKey);

        // 2. Unsubscribe from old premium topic if language changed
        if (previousPremiumTopic != null && previousPremiumTopic != targetPremiumTopic) {
          try {
            await _messaging?.unsubscribeFromTopic(previousPremiumTopic);
            debugPrint('🔥 [FCM] Unsubscribed from old premium topic: $previousPremiumTopic');
          } catch (e) {
            debugPrint('⚠️ [FCM] Error unsubscribing from $previousPremiumTopic: $e');
          }
        }

        // 3. Subscribe to language-based premium topic (e.g. premium_tr) and global premium topic
        try {
          await _messaging?.subscribeToTopic(targetPremiumTopic);
          await _messaging?.subscribeToTopic(globalPremiumTopic);
          await prefs.setString(_prefSubscribedPremiumTopicKey, targetPremiumTopic);
          debugPrint('🔥 [FCM] Subscribed to premium topics: "$targetPremiumTopic" and "$globalPremiumTopic"');
        } catch (e) {
          debugPrint('⚠️ [FCM] Error subscribing to premium topics: $e');
        }
      }
    }

      // Sync with Firestore 'users' collection
      if (_isInitialized && _firestore != null) {
        try {
          final docRef = firestore.collection('users').doc(userId);
          final Map<String, dynamic> updateData = {
            'userId': userId,
            'isPremium': isPremium,
            'deviceLanguage': lang,
            'deviceLocale': getDeviceLocale(),
            'activeTopic': isPremium ? targetPremiumTopic : targetNonPremiumTopic,
            'premiumTopic': isPremium ? targetPremiumTopic : null,
            'nonPremiumTopic': isPremium ? null : targetNonPremiumTopic,
            'platform': defaultTargetPlatform.name,
            'antiBypassEnabled': prefs.getBool('nora_anti_bypass') ?? true,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          if (_latestFcmToken != null && _latestFcmToken!.isNotEmpty) {
            updateData['fcmToken'] = _latestFcmToken;
          }

          await docRef.set(updateData, SetOptions(merge: true));

          // Ensure createdAt is populated on first creation
          final snapshot = await docRef.get();
          if (!snapshot.exists || snapshot.data()?['createdAt'] == null) {
            await docRef.set({
              'createdAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }

          debugPrint('🔥 [Firestore SUCCESS] users/$userId tablosuna yazıldı: isPremium=$isPremium, lang=$lang, activeTopic=${updateData['activeTopic']}, fcmToken=${_latestFcmToken ?? "bekleniyor"}');
        } catch (firestoreErr) {
          debugPrint('❌ [Firestore ERROR] users tablosuna yazılamadı: $firestoreErr');
          if (firestoreErr.toString().contains('permission-denied') ||
              firestoreErr.toString().contains('PERMISSION_DENIED')) {
            debugPrint('🚨 [Firestore] Yetki Hatası (PERMISSION_DENIED)! Firebase Console -> Firestore Database -> Rules (Kurallar) kısmında yazma iznini (allow read, write: if true;) açmanız gerekiyor.');
          }
        }
      } else {
        debugPrint('⚠️ [Firestore] Firestore henüz başlatılmadı (_isInitialized=$_isInitialized, _firestore=$_firestore)');
      }
    } catch (e) {
      debugPrint('⚠️ Error in syncUserAndTopics: $e');
    }
  }

  /// Starts listening to the user document in Cloud Firestore in real time.
  /// If an administrator or remote service changes `isPremium` in Firestore,
  /// this triggers immediately to update local subscription and topics.
  static void startUserRealtimeListener({
    required void Function(bool isPremium) onPremiumStatusChanged,
  }) {
    _userSnapshotSubscription?.cancel();
    if (!_isInitialized || _firestore == null || _currentUserId == null) {
      return;
    }

    try {
      _userSnapshotSubscription = firestore
          .collection('users')
          .doc(_currentUserId)
          .snapshots()
          .listen((snapshot) {
        if (!snapshot.exists) return;
        final data = snapshot.data();
        if (data != null && data.containsKey('isPremium')) {
          final remoteIsPremium = data['isPremium'] as bool? ?? false;
          onPremiumStatusChanged(remoteIsPremium);
        }
      }, onError: (e) {
        debugPrint('⚠️ Error listening to users/$_currentUserId: $e');
      });
      debugPrint('🔥 [Firestore] Real-time listener active for users/$_currentUserId');
    } catch (e) {
      debugPrint('⚠️ Failed to start real-time listener: $e');
    }
  }

  /// Stops the real-time listener if needed.
  static void stopUserRealtimeListener() {
    _userSnapshotSubscription?.cancel();
    _userSnapshotSubscription = null;
  }

  /// Synchronizes the Anti-Bypass protection status with Firestore so backend
  /// Cloud Functions and Cloud Scheduler can trigger immediate alert notifications
  /// and ongoing monitoring when disabled.
  static Future<void> updateAntiBypassStatus({required bool enabled}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      final userId = await getOrCreateUserId();
      if (_isInitialized && _firestore != null) {
        final docRef = firestore.collection('users').doc(userId);
        final Map<String, dynamic> updateData = {
          'antiBypassEnabled': enabled,
          'antiBypassUpdatedAt': FieldValue.serverTimestamp(),
        };
        if (!enabled) {
          updateData['antiBypassDisabledAt'] = FieldValue.serverTimestamp();
        } else {
          updateData['antiBypassReEnabledAt'] = FieldValue.serverTimestamp();
        }
        if (_latestFcmToken != null && _latestFcmToken!.isNotEmpty) {
          updateData['fcmToken'] = _latestFcmToken;
        }
        await docRef.set(updateData, SetOptions(merge: true));
        debugPrint('🛡️ [Anti-Bypass] Firestore updated: antiBypassEnabled=$enabled');
      }
    } catch (e) {
      debugPrint('⚠️ Error updating Anti-Bypass status in Firestore: $e');
    }
  }

  // --- In-App Messaging Helper ---

  static Future<void> triggerInAppMessage(String eventName) async {
    try {
      await inAppMessaging.triggerEvent(eventName);
      debugPrint('FIAM event triggered: $eventName');
    } catch (e) {
      debugPrint('Error triggering In-App Message event: $e');
    }
  }

  // --- Analytics Convenience Helpers ---

  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('Error logging analytics event "$name": $e');
    }
  }

  static Future<void> setUserId(String? userId) async {
    if (!_isInitialized) return;
    try {
      await analytics.setUserId(id: userId);
      await crashlytics.setUserIdentifier(userId ?? '');
    } catch (e) {
      debugPrint('Error setting userId: $e');
    }
  }

  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized) return;
    try {
      await analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      debugPrint('Error logging screen view "$screenName": $e');
    }
  }

  // --- Crashlytics Convenience Helpers ---

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;
    try {
      await crashlytics.recordError(
        exception,
        stack,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('Error recording crashlytics error: $e');
    }
  }

  static Future<void> log(String message) async {
    if (!_isInitialized) return;
    try {
      await crashlytics.log(message);
    } catch (e) {
      debugPrint('Error writing crashlytics log: $e');
    }
  }

  // --- Notification Analytics & Conversion Attribution ---

  /// Records a notification open/click event for analytics and conversion attribution.
  static Future<void> recordNotificationClick({
    required String campaignId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLastClickedCampaignIdKey, campaignId);
      await prefs.setInt(_prefLastClickedCampaignTimeKey, now.millisecondsSinceEpoch);
      if (data?['screen'] != null) {
        await prefs.setString(_prefLastClickedCampaignScreenKey, data!['screen'].toString());
      }

      final userId = await getOrCreateUserId();

      // 1. Update user document with last clicked notification
      if (_isInitialized && _firestore != null) {
        final userRef = firestore.collection('users').doc(userId);
        await userRef.set({
          'lastNotificationClicked': {
            'campaignId': campaignId,
            'clickedAt': FieldValue.serverTimestamp(),
            'screen': data?['screen'] ?? 'paywall',
          },
          'totalNotificationClicks': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // 2. Add to user notification interaction history
        final historyId = 'click_${now.millisecondsSinceEpoch}_$campaignId';
        await userRef.collection('notification_history').doc(historyId).set({
          'campaignId': campaignId,
          'action': 'click',
          'clickedAt': FieldValue.serverTimestamp(),
          'data': data ?? {},
        });

        // 3. Atomically update campaign analytics document
        final campaignRef = firestore.collection('notification_campaigns').doc(campaignId);
        await campaignRef.set({
          'campaignId': campaignId,
          'totalOpens': FieldValue.increment(1),
          'lastClickedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // Log analytics event
      await logEvent(
        name: 'notification_opened_custom',
        parameters: {
          'campaign_id': campaignId,
          'screen': data?['screen']?.toString() ?? 'paywall',
        },
      );

      debugPrint('📊 [Analytics] Recorded notification click for campaign "$campaignId" (User: $userId)');
    } catch (e) {
      debugPrint('⚠️ Error recording notification click: $e');
    }
  }

  /// Attributes a premium subscription purchase to the notification that led to it.
  /// Checks if the user clicked a notification within the attribution window (default: 7 days).
  static Future<void> recordConversionAttribution({
    required String plan,
    Duration attributionWindow = const Duration(days: 7),
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final campaignId = prefs.getString(_prefLastClickedCampaignIdKey);
      final clickedTimeMs = prefs.getInt(_prefLastClickedCampaignTimeKey);

      if (campaignId == null || clickedTimeMs == null) {
        debugPrint('ℹ️ [Attribution] Direct purchase (no prior notification click tracked).');
        return;
      }

      final clickedTime = DateTime.fromMillisecondsSinceEpoch(clickedTimeMs);
      final now = DateTime.now();
      final difference = now.difference(clickedTime);

      if (difference > attributionWindow) {
        debugPrint('ℹ️ [Attribution] Notification click for "$campaignId" occurred ${difference.inDays} days ago (outside attribution window).');
        return;
      }

      final timeSinceClickMinutes = (difference.inSeconds / 60.0).toStringAsFixed(1);
      final userId = await getOrCreateUserId();

      if (_isInitialized && _firestore != null) {
        // 1. Update user document with converting notification
        final userRef = firestore.collection('users').doc(userId);
        await userRef.set({
          'convertingNotification': {
            'campaignId': campaignId,
            'plan': plan,
            'convertedAt': FieldValue.serverTimestamp(),
            'timeSinceClickMinutes': double.tryParse(timeSinceClickMinutes) ?? 0.0,
          },
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // 2. Atomically increment conversion count in campaign
        final campaignRef = firestore.collection('notification_campaigns').doc(campaignId);
        await campaignRef.set({
          'campaignId': campaignId,
          'totalConversions': FieldValue.increment(1),
          'lastConvertedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // 3. Create independent conversion document for reporting
        final conversionId = 'conv_${now.millisecondsSinceEpoch}_$userId';
        await firestore.collection('conversions').doc(conversionId).set({
          'conversionId': conversionId,
          'userId': userId,
          'plan': plan,
          'attributedCampaignId': campaignId,
          'convertedAt': FieldValue.serverTimestamp(),
          'timeSinceClickMinutes': double.tryParse(timeSinceClickMinutes) ?? 0.0,
          'deviceLanguage': getDeviceLanguage(),
          'platform': defaultTargetPlatform.name,
        });
      }

      // Log analytics
      await logEvent(
        name: 'premium_conversion_attributed',
        parameters: {
          'campaign_id': campaignId,
          'plan': plan,
          'time_since_click_min': double.tryParse(timeSinceClickMinutes) ?? 0.0,
        },
      );

      debugPrint('''
======================================================================
🎯 [CONVERSION ATTRIBUTION SUCCESS]
User: $userId
Plan: $plan
Attributed Campaign: $campaignId
Time to convert: $timeSinceClickMinutes minutes
======================================================================''');
    } catch (e) {
      debugPrint('⚠️ Error recording conversion attribution: $e');
    }
  }

  /// Checks whether the application was launched from a terminated state by tapping a notification.
  static Future<void> checkInitialNotification() async {
    try {
      final initialMessage = await _messaging?.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('FCM Initial message launched app: ${initialMessage.data}');
        final msgId = initialMessage.messageId;
        if (msgId != null && msgId == _lastHandledNotificationId) {
          debugPrint('FCM duplicate initial message ignored: $msgId');
          return;
        }
        if (msgId != null) {
          _lastHandledNotificationId = msgId;
        }
        final campaignId = initialMessage.data['campaign_id'] ?? initialMessage.data['campaign'];
        if (campaignId != null && campaignId.toString().isNotEmpty) {
          await recordNotificationClick(
            campaignId: campaignId.toString(),
            data: initialMessage.data,
          );
        }
        onNotificationAction?.call(initialMessage.data);
      }

      // Check if launched by tapping a local notification
      final launchDetails = await _localNotifications?.getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        final payload = launchDetails.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final Map<String, dynamic> data = json.decode(payload);
            onNotificationAction?.call(data);
          } catch (_) {
            onNotificationAction?.call({'screen': 'paywall', 'payload': payload});
          }
        } else {
          onNotificationAction?.call({'screen': 'paywall'});
        }
      }
    } catch (e) {
      debugPrint('Error checking initial notification: $e');
    }
  }

  static const int abandonedTrialNotificationId = 99999;
  static const MethodChannel _screenTimeChannel = MethodChannel('com.nora.blocker/screentime');
  static bool _timeZonesInitialized = false;

  /// Schedules a persuasive push notification 5 minutes after leaving the app without starting a trial.
  static Future<void> scheduleAbandonedTrialNotification({
    String? languageCode,
    int delayMinutes = 5,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isSubscribed = prefs.getBool('nora_is_subscribed') ?? false;
      if (isSubscribed) {
        debugPrint('[Notification] User is already subscribed. Skipping abandoned trial reminder.');
        return;
      }

      final s = AppStrings.get(languageCode ?? 'tr');
      final title = s.abandonedTrialNotificationTitle;
      final body = s.abandonedTrialNotificationBody;

      // 1. Native iOS UNUserNotificationCenter trigger (guaranteed delivery by iOS even if app killed)
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await _screenTimeChannel.invokeMethod('scheduleAbandonedTrialNotification', {
            'delaySeconds': delayMinutes * 60.0,
            'title': title,
            'body': body,
          });
        } catch (e) {
          debugPrint('Error invoking native scheduleAbandonedTrialNotification: $e');
        }
      }

      // 2. FlutterLocalNotificationsPlugin zonedSchedule for cross-platform / Android
      try {
        if (!_timeZonesInitialized) {
          tz.initializeTimeZones();
          _timeZonesInitialized = true;
        }

        final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(minutes: delayMinutes));
        const androidDetails = AndroidNotificationDetails(
          'abandoned_trial_channel',
          'Nora Koruma Hatırlatıcı',
          channelDescription: 'Ücretsiz deneme ve kalkan aktivasyon hatırlatıcı bildirimi',
          importance: Importance.max,
          priority: Priority.high,
        );
        const darwinDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        const details = NotificationDetails(android: androidDetails, iOS: darwinDetails);

        await _localNotifications?.zonedSchedule(
          id: abandonedTrialNotificationId,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: json.encode({'screen': 'paywall', 'type': 'abandoned_trial'}),
        );
        debugPrint('🔔 [Notification] Scheduled abandoned trial reminder in $delayMinutes mins: "$title"');
      } catch (e) {
        debugPrint('Error scheduling local zoned notification: $e');
      }
    } catch (e) {
      debugPrint('Error in scheduleAbandonedTrialNotification: $e');
    }
  }

  /// Cancels any pending abandoned trial push notifications once user activates trial or reopens app.
  static Future<void> cancelAbandonedTrialNotification() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await _screenTimeChannel.invokeMethod('cancelAbandonedTrialNotification');
        } catch (_) {}
      }
      await _localNotifications?.cancel(id: abandonedTrialNotificationId);
      debugPrint('🔕 [Notification] Abandoned trial reminder cancelled.');
    } catch (e) {
      debugPrint('Error cancelling abandoned trial notification: $e');
    }
  }

  /// Listens to the `blocked_sites` collection in Cloud Firestore in real time.
  /// Whenever a new site/domain is added, updated, or deleted on the server side (DB),
  /// this callback is triggered immediately to update local and native filters.
  static Future<void> startBlockedSitesRealtimeListener({
    required void Function(List<Map<String, dynamic>> sites) onSitesUpdated,
  }) async {
    _blockedSitesSnapshotSubscription?.cancel();
    if (!_isInitialized) {
      await initialize();
    }
    if (!_isInitialized || _firestore == null) {
      debugPrint('⚠️ [Firestore] Cannot start blocked sites listener: Firebase is not initialized.');
      return;
    }

    try {
      _blockedSitesSnapshotSubscription = firestore
          .collection('blocked_sites')
          .snapshots()
          .listen((snapshot) {
        final List<Map<String, dynamic>> sites = [];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          sites.add(data);
        }
        debugPrint('🔥 [Firestore] Real-time snapshot received: ${sites.length} blocked sites');
        onSitesUpdated(sites);
      }, onError: (e) {
        debugPrint('⚠️ Error listening to blocked_sites collection: $e');
      });
      debugPrint('🔥 [Firestore] Real-time listener active for collection "blocked_sites"');
    } catch (e) {
      debugPrint('⚠️ Failed to start blocked_sites real-time listener: $e');
    }
  }

  /// Stops listening to the `blocked_sites` collection.
  static void stopBlockedSitesRealtimeListener() {
    _blockedSitesSnapshotSubscription?.cancel();
    _blockedSitesSnapshotSubscription = null;
  }

  /// Handles background or foreground silent push notifications to immediately sync and expand filters
  static Future<void> handleSilentPushSync(Map<String, dynamic> data) async {
    final action = data['action']?.toString() ?? data['type']?.toString();
    final isSyncAction = action == 'sync_blocked_sites' ||
        action == 'update_filters' ||
        data.containsKey('domains') ||
        data.containsKey('sync_blocked_sites');

    if (!isSyncAction) return;

    debugPrint('⚡ [SilentPush] Background filter synchronization triggered with data: $data');

    try {
      final List<String> domainsToBlock = [];

      // 1. Parse domains if passed directly in the notification payload
      if (data['domains'] != null) {
        final raw = data['domains'];
        if (raw is List) {
          domainsToBlock.addAll(raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty));
        } else if (raw is String && raw.isNotEmpty) {
          try {
            final decoded = json.decode(raw);
            if (decoded is List) {
              domainsToBlock.addAll(decoded.map((e) => e.toString().trim()).where((e) => e.isNotEmpty));
            } else {
              domainsToBlock.addAll(raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
            }
          } catch (_) {
            domainsToBlock.addAll(raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
          }
        }
      }

      // 2. Automatically apply predictive sequential expansion on incoming dynamic domains
      if (domainsToBlock.isNotEmpty) {
        final predicted = PredictiveDomainEngine.deriveSequencesForList(domainsToBlock, forwardCount: 10);
        domainsToBlock.addAll(predicted);
      }

      // 3. If payload did not include explicit domains, query Firestore blocked_sites
      if (domainsToBlock.isEmpty && _firestore != null) {
        final snapshot = await _firestore!.collection('blocked_sites').get();
        for (final doc in snapshot.docs) {
          final d = doc.data()['domain']?.toString();
          if (d != null && d.trim().isNotEmpty) {
            domainsToBlock.add(d.trim());
          }
        }
        final predicted = PredictiveDomainEngine.deriveSequencesForList(domainsToBlock, forwardCount: 5);
        domainsToBlock.addAll(predicted);
      }

      // 4. Update native iOS Screen Time / WebKit filters via MethodChannel
      if (domainsToBlock.isNotEmpty && !kIsWeb) {
        try {
          await _screenTimeChannel.invokeMethod('setBlockedDomains', {
            'domains': domainsToBlock,
          });
          debugPrint('🛡️ [SilentPush] Synchronized ${domainsToBlock.length} domains to native filters.');
        } catch (e) {
          debugPrint('⚠️ [SilentPush] MethodChannel invoke error: $e');
        }
      }

      // 5. Notify active AppState listener if attached
      if (domainsToBlock.isNotEmpty) {
        onSilentPushFilterUpdated?.call(domainsToBlock);
      }
    } catch (e) {
      debugPrint('⚠️ [SilentPush] Error handling silent push filter sync: $e');
    }
  }

  /// Adds or updates a blocked site entry in Cloud Firestore (`blocked_sites` collection).
  static Future<void> addBlockedSiteToFirestore({
    required String domain,
    String? category,
    String? bundleId,
    String? title,
    String? description,
    bool isEnabled = true,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      if (!_isInitialized || _firestore == null) {
        debugPrint('⚠️ [Firestore] Cannot save blocked site: Firebase is not initialized.');
        return;
      }

      final cleanDomain = domain
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'https?://'), '')
          .replaceAll(RegExp(r'/.*'), '')
          .replaceAll(RegExp(r'^www\.'), '');

      if (cleanDomain.isEmpty) return;

      final docId = cleanDomain.replaceAll('.', '_');
      final docRef = firestore.collection('blocked_sites').doc(docId);

      await docRef.set({
        'domain': cleanDomain,
        'category': category ?? 'custom',
        if (bundleId != null && bundleId.isNotEmpty) 'bundleId': bundleId,
        if (title != null && title.isNotEmpty) 'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'isEnabled': isEnabled,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('🔥 [Firestore] Blocked site saved to DB: $cleanDomain (docId: $docId)');
    } catch (e) {
      debugPrint('⚠️ Error saving blocked site to Firestore: $e');
    }
  }

  /// Removes a blocked site entry from Cloud Firestore.
  static Future<void> removeBlockedSiteFromFirestore(String domain) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      if (!_isInitialized || _firestore == null) return;
      final cleanDomain = domain
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'https?://'), '')
          .replaceAll(RegExp(r'/.*'), '')
          .replaceAll(RegExp(r'^www\.'), '');
      if (cleanDomain.isEmpty) return;

      final docId = cleanDomain.replaceAll('.', '_');
      await firestore.collection('blocked_sites').doc(docId).delete();
      debugPrint('🔥 [Firestore] Blocked site removed from DB: $cleanDomain');
    } catch (e) {
      debugPrint('⚠️ Error deleting blocked site from Firestore: $e');
    }
  }

  /// Seed default categories, built-in preset domains, and app bundle IDs into Firestore `blocked_sites`
  /// if the collection is empty (or when forced), ensuring all app default site information is stored in the database.
  static Future<void> seedInitialBlockedSitesIfEmpty(List<BlockerCategory> categories, {bool force = false}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      if (!_isInitialized || _firestore == null) {
        debugPrint('⚠️ [Firestore] Cannot seed blocked sites: Firebase is not initialized.');
        return;
      }

      if (!force) {
        final snapshot = await firestore.collection('blocked_sites').limit(1).get();
        if (snapshot.docs.isNotEmpty) {
          debugPrint('🔥 [Firestore] blocked_sites collection already populated.');
          return;
        }
      }

      debugPrint('🌱 [Firestore] Seeding all built-in automatic blocked sites and apps to collection "blocked_sites"...');
      final batch = firestore.batch();

      // Track added domains and bundle IDs to avoid duplicates
      final Set<String> seededDomains = {};

      // 1. Seed all default categories, sample domains and bundle IDs
      for (final cat in categories) {
        for (final domain in cat.sampleDomains) {
          final cleanDomain = domain
              .trim()
              .toLowerCase()
              .replaceAll(RegExp(r'https?://'), '')
              .replaceAll(RegExp(r'/.*'), '')
              .replaceAll(RegExp(r'^www\.'), '');
          if (cleanDomain.isEmpty || seededDomains.contains(cleanDomain)) continue;
          seededDomains.add(cleanDomain);

          final docId = cleanDomain.replaceAll('.', '_');
          final docRef = firestore.collection('blocked_sites').doc(docId);
          batch.set(docRef, {
            'domain': cleanDomain,
            'category': cat.id,
            'categoryTitle': cat.title,
            'sampleBundleIds': cat.sampleBundleIds,
            'isEnabled': true,
            'isSystemDefault': true,
            'type': 'domain',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      // 2. Preset core high-risk gambling root domains (Turkish & Global)
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
        final cleanDomain = domain
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'https?://'), '')
            .replaceAll(RegExp(r'/.*'), '')
            .replaceAll(RegExp(r'^www\.'), '');
        if (cleanDomain.isEmpty || seededDomains.contains(cleanDomain)) continue;
        seededDomains.add(cleanDomain);

        final docId = cleanDomain.replaceAll('.', '_');
        final docRef = firestore.collection('blocked_sites').doc(docId);
        batch.set(docRef, {
          'domain': cleanDomain,
          'category': 'preset_high_risk',
          'categoryTitle': 'Otomatik Yüksek Riskli Kumar Siteleri',
          'isEnabled': true,
          'isSystemDefault': true,
          'type': 'domain',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // 3. Preset mobile app bundle IDs
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

      for (final bundleId in presetBundleIds) {
        final cleanBundle = bundleId.trim();
        if (cleanBundle.isEmpty) continue;
        final docId = 'app_${cleanBundle.replaceAll('.', '_')}';
        final docRef = firestore.collection('blocked_sites').doc(docId);
        batch.set(docRef, {
          'bundleId': cleanBundle,
          'category': 'mobile_app',
          'categoryTitle': 'Otomatik Engellenen Mobil Uygulama',
          'isEnabled': true,
          'isSystemDefault': true,
          'type': 'app',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      debugPrint('🌱 [Firestore] Successfully seeded all ${seededDomains.length} domains and ${presetBundleIds.length} app bundle IDs to "blocked_sites" collection.');
    } catch (e) {
      debugPrint('⚠️ Error seeding initial blocked sites to Firestore: $e');
    }
  }
}
