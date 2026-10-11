import 'package:flutter_test/flutter_test.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase User & Topic Management Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getNonPremiumTopicForLanguage formats valid FCM topic names', () {
      expect(FirebaseService.getNonPremiumTopicForLanguage('tr'), 'non_premium_tr');
      expect(FirebaseService.getNonPremiumTopicForLanguage('TR'), 'non_premium_tr');
      expect(FirebaseService.getNonPremiumTopicForLanguage('en'), 'non_premium_en');
      expect(FirebaseService.getNonPremiumTopicForLanguage('de'), 'non_premium_de');
      expect(FirebaseService.getNonPremiumTopicForLanguage('fr'), 'non_premium_fr');
      expect(FirebaseService.getNonPremiumTopicForLanguage('es'), 'non_premium_es');
      expect(FirebaseService.getNonPremiumTopicForLanguage(''), 'non_premium_en');
      expect(FirebaseService.getNonPremiumTopicForLanguage('123'), 'non_premium_en');
    });

    test('getPremiumTopicForLanguage formats valid premium FCM topic names', () {
      expect(FirebaseService.getPremiumTopicForLanguage('tr'), 'premium_tr');
      expect(FirebaseService.getPremiumTopicForLanguage('TR'), 'premium_tr');
      expect(FirebaseService.getPremiumTopicForLanguage('en'), 'premium_en');
      expect(FirebaseService.getPremiumTopicForLanguage('de'), 'premium_de');
      expect(FirebaseService.getPremiumTopicForLanguage('fr'), 'premium_fr');
      expect(FirebaseService.getPremiumTopicForLanguage(''), 'premium_en');
    });

    test('getDeviceLanguage returns sanitized non-empty string', () {
      final lang = FirebaseService.getDeviceLanguage();
      expect(lang, isNotEmpty);
      expect(lang, matches(RegExp(r'^[a-z]+$')));
    });

    test('getOrCreateUserId creates and persists user ID in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      final userId1 = await FirebaseService.getOrCreateUserId();
      expect(userId1, startsWith('user_'));

      // Subsequent call returns the same persistent ID
      final userId2 = await FirebaseService.getOrCreateUserId();
      expect(userId2, equals(userId1));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nora_firebase_user_id'), equals(userId1));
    });

    test('syncUserAndTopics switches seamlessly between non-premium and premium topics', () async {
      SharedPreferences.setMockInitialValues({});

      // Non-premium user: subscribed to non_premium_<lang>
      await FirebaseService.syncUserAndTopics(isPremium: false);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nora_fcm_non_premium_topic'), startsWith('non_premium_'));
      expect(prefs.getString('nora_fcm_premium_topic'), isNull);

      // User pays and becomes premium: subscribed to premium_<lang>, non_premium cleared
      await FirebaseService.syncUserAndTopics(isPremium: true);
      expect(prefs.getString('nora_fcm_non_premium_topic'), isNull);
      expect(prefs.getString('nora_fcm_premium_topic'), startsWith('premium_'));

      // If user resets/cancels: subscribed back to non_premium, premium cleared
      await FirebaseService.syncUserAndTopics(isPremium: false);
      expect(prefs.getString('nora_fcm_non_premium_topic'), startsWith('non_premium_'));
      expect(prefs.getString('nora_fcm_premium_topic'), isNull);
    });

    test('AppState activates subscription and resets app state with sync trigger', () async {
      SharedPreferences.setMockInitialValues({
        'nora_is_onboarded': true,
        'nora_is_subscribed': false,
      });

      final appState = AppState();
      // Allow async _loadState to run
      await Future.delayed(const Duration(milliseconds: 50));

      expect(appState.isSubscribed, isFalse);

      // Activate subscription
      await appState.activateSubscription(plan: 'annual');
      expect(appState.isSubscribed, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('nora_is_subscribed'), isTrue);

      // Reset full app
      await appState.resetFullApp();
      expect(appState.isSubscribed, isFalse);

      appState.dispose();
    });
  });
}
