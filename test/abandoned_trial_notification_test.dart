import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/l10n/app_strings.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('Abandoned Trial 5-Minute Notification Job Tests', () {
    test('AppStrings contains persuasive abandoned trial messages in TR and EN', () {
      final tr = AppStrings.get('tr');
      expect(tr.abandonedTrialNotificationTitle, contains('Nora Kalkanın Henüz Aktif Değil'));
      expect(tr.abandonedTrialNotificationBody, contains('0 ₺'));
      expect(tr.abandonedTrialNotificationBody, contains('ücretsiz denemeni'));

      final en = AppStrings.get('en');
      expect(en.abandonedTrialNotificationTitle, contains('Your Nora Shield is Not Active Yet'));
      expect(en.abandonedTrialNotificationBody, contains('risk-free trial'));
    });

    test('scheduleAbandonedTrialNotification invokes native iOS channel with 300s delay and localized copy', () async {
      Map<String, dynamic>? scheduledArgs;
      String? invokedMethod;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          invokedMethod = methodCall.method;
          if (methodCall.method == 'scheduleAbandonedTrialNotification') {
            scheduledArgs = (methodCall.arguments as Map?)?.cast<String, dynamic>();
            return true;
          }
          return null;
        },
      );

      // Schedule for Turkish (default)
      await FirebaseService.scheduleAbandonedTrialNotification(
        languageCode: 'tr',
        delayMinutes: 5,
      );

      expect(invokedMethod, 'scheduleAbandonedTrialNotification');
      expect(scheduledArgs, isNotNull);
      expect(scheduledArgs!['delaySeconds'], 300.0);
      expect(scheduledArgs!['title'], contains('Nora Kalkanın Henüz Aktif Değil'));
      expect(scheduledArgs!['body'], contains('ücretsiz denemeni'));
    });

    test('scheduleAbandonedTrialNotification respects English languageCode', () async {
      Map<String, dynamic>? scheduledArgs;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'scheduleAbandonedTrialNotification') {
            scheduledArgs = (methodCall.arguments as Map?)?.cast<String, dynamic>();
            return true;
          }
          return null;
        },
      );

      await FirebaseService.scheduleAbandonedTrialNotification(
        languageCode: 'en',
        delayMinutes: 5,
      );

      expect(scheduledArgs, isNotNull);
      expect(scheduledArgs!['delaySeconds'], 300.0);
      expect(scheduledArgs!['title'], contains('Your Nora Shield is Not Active Yet'));
      expect(scheduledArgs!['body'], contains('risk-free trial'));
    });

    test('scheduleAbandonedTrialNotification skips scheduling if user is already subscribed', () async {
      SharedPreferences.setMockInitialValues({
        'nora_is_subscribed': true,
      });

      bool wasInvoked = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'scheduleAbandonedTrialNotification') {
            wasInvoked = true;
          }
          return null;
        },
      );

      await FirebaseService.scheduleAbandonedTrialNotification(
        languageCode: 'tr',
        delayMinutes: 5,
      );

      expect(wasInvoked, isFalse);
    });

    test('cancelAbandonedTrialNotification invokes native cancel method', () async {
      bool cancelInvoked = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'cancelAbandonedTrialNotification') {
            cancelInvoked = true;
            return true;
          }
          return null;
        },
      );

      await FirebaseService.cancelAbandonedTrialNotification();
      expect(cancelInvoked, isTrue);
    });

    test('AppState activateSubscription triggers cancelAbandonedTrialNotification', () async {
      bool cancelInvoked = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'cancelAbandonedTrialNotification') {
            cancelInvoked = true;
            return true;
          }
          return null;
        },
      );

      final appState = AppState();
      while (appState.isLoading) {
        await Future.delayed(const Duration(milliseconds: 20));
      }

      await appState.activateSubscription(plan: 'annual');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(appState.isSubscribed, isTrue);
      expect(cancelInvoked, isTrue);
    });
  });
}
