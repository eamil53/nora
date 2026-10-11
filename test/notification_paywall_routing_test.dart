import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/main.dart';
import 'package:nora/screens/dashboard/main_dashboard.dart';
import 'package:nora/screens/paywall/paywall_screen.dart';
import 'package:nora/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Notification Paywall Routing & Duplicate Prevention Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'checkAuthorizationStatus') {
            return 'approved';
          }
          if (methodCall.method == 'getShieldedAppInfo') {
            return {'appsCount': 0, 'catsCount': 0, 'webDomainsCount': 0};
          }
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.nora.blocker/screentime'),
        null,
      );
    });

    testWidgets(
        'Non-subscribed onboarded user clicking paywall notification does NOT spawn a second paywall screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({
        'nora_is_onboarded': true,
        'nora_is_subscribed': false,
        'nora_user_profile':
            '{"monthlySpend":3000.0,"hoursPerDay":2.0,"selectedAddictions":["Casino"],"selectedTriggers":["Stres"],"mainMotivation":"Özgürlük","quitDate":"2026-01-01T00:00:00.000","currencySymbol":"₺"}',
      });

      await tester.pumpWidget(const NoraApp());
      // Let splash and initialization complete
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }

      // App should display the base PaywallScreen with key 'paywall'
      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('paywall')), findsOneWidget);
      expect(find.byKey(const ValueKey('paywall_force')), findsNothing);
      expect(find.byIcon(CupertinoIcons.xmark), findsNothing);

      // Notification background cron job triggers and user clicks notification
      FirebaseService.onNotificationAction?.call({
        'screen': 'paywall',
        'campaign_id': 'weekend_retention_campaign',
      });

      // Advance frames and animation
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));

      // Crucial assertion: There must still be EXACTLY ONE PaywallScreen ('paywall')
      // No duplicate 'paywall_force' or stacked second page!
      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('paywall')), findsOneWidget);
      expect(find.byKey(const ValueKey('paywall_force')), findsNothing);
      expect(find.byIcon(CupertinoIcons.xmark), findsNothing);
    });

    testWidgets(
        'Subscribed user on dashboard can open and dismiss paywall_force smoothly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({
        'nora_is_onboarded': true,
        'nora_is_subscribed': true,
        'nora_user_profile':
            '{"monthlySpend":3000.0,"hoursPerDay":2.0,"selectedAddictions":["Casino"],"selectedTriggers":["Stres"],"mainMotivation":"Özgürlük","quitDate":"2026-01-01T00:00:00.000","currencySymbol":"₺"}',
      });

      await tester.pumpWidget(const NoraApp());
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }

      // Subscribed user enters MainDashboard
      expect(find.byType(MainDashboard), findsOneWidget);
      expect(find.byType(PaywallScreen), findsNothing);

      // Trigger paywall action (e.g. from notification or profile)
      FirebaseService.onNotificationAction?.call({'screen': 'paywall'});
      for (int i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      // Paywall force screen is shown with key 'paywall_force'
      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('paywall_force')), findsOneWidget);

      // User dismisses paywall using back button
      final closeBtn = find.byIcon(CupertinoIcons.xmark);
      expect(closeBtn, findsOneWidget);
      await tester.tap(closeBtn);
      for (int i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      // Back to dashboard
      expect(find.byType(MainDashboard), findsOneWidget);
      expect(find.byType(PaywallScreen), findsNothing);
    });
  });
}
