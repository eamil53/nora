import 'package:flutter_test/flutter_test.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Notification Click & Conversion Attribution Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('recordNotificationClick persists campaign click data to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      const campaignId = 'weekend_shield_fri';
      await FirebaseService.recordNotificationClick(
        campaignId: campaignId,
        data: {'screen': 'paywall', 'offer': 'discount50'},
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nora_last_clicked_campaign_id'), equals(campaignId));
      expect(prefs.getString('nora_last_clicked_campaign_screen'), equals('paywall'));
      expect(prefs.getInt('nora_last_clicked_campaign_time'), isNotNull);
    });

    test('recordConversionAttribution attributes purchase to recently clicked campaign', () async {
      SharedPreferences.setMockInitialValues({});

      const campaignId = 'night_casino_sat';
      await FirebaseService.recordNotificationClick(
        campaignId: campaignId,
        data: {'screen': 'paywall'},
      );

      // Now user subscribes
      await FirebaseService.recordConversionAttribution(plan: 'annual');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nora_last_clicked_campaign_id'), equals(campaignId));
    });

    test('AppState activateSubscription triggers conversion attribution', () async {
      SharedPreferences.setMockInitialValues({});

      // Record prior notification click
      await FirebaseService.recordNotificationClick(
        campaignId: 'sunday_reflection',
        data: {'screen': 'paywall'},
      );

      final appState = AppState();
      await Future.delayed(const Duration(milliseconds: 50));

      await appState.activateSubscription(plan: 'annual');

      expect(appState.isSubscribed, isTrue);
      expect(appState.activePlan, equals('annual'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('nora_is_subscribed'), isTrue);
      expect(prefs.getString('nora_last_clicked_campaign_id'), equals('sunday_reflection'));

      appState.dispose();
    });

    test('onNotificationAction callback triggers when notification is clicked', () async {
      Map<String, dynamic>? triggeredData;
      FirebaseService.onNotificationAction = (data) {
        triggeredData = data;
      };

      const campaignId = 'payday_protection_1st';
      final payload = {'campaign_id': campaignId, 'screen': 'paywall', 'discount': '30%'};

      await FirebaseService.recordNotificationClick(
        campaignId: campaignId,
        data: payload,
      );

      FirebaseService.onNotificationAction?.call(payload);

      expect(triggeredData, isNotNull);
      expect(triggeredData?['campaign_id'], equals(campaignId));
      expect(triggeredData?['screen'], equals('paywall'));
    });
  });
}
