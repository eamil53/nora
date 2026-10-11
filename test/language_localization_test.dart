import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/l10n/app_strings.dart';
import 'package:nora/models/user_profile.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/paywall/paywall_screen.dart';
import 'package:nora/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Language Localization & AppStrings Tests', () {
    test('AppStrings resolves Turkish and English correctly', () {
      final tr = AppStrings.get('tr');
      expect(tr.isTr, isTrue);
      expect(tr.planAnnualTitle, 'YILLIK KORUMA');
      expect(tr.paywallCtaText(7), '7 Gün Ücretsiz Denemeyi Başlat');

      final en = AppStrings.get('en');
      expect(en.isTr, isFalse);
      expect(en.planAnnualTitle, 'ANNUAL PROTECTION');
      expect(en.paywallCtaText(7), 'Start 7-Day Free Trial');
    });

    test('AppState handles manual language switching and persistence', () async {
      final appState = AppState();

      // In default test runner, platformDispatcher locale is en
      expect(appState.languageCode, 'en');
      expect(appState.strings.isTr, isFalse);

      // Switch to Turkish manually
      await appState.setLanguage('tr');
      expect(appState.languagePreference, 'tr');
      expect(appState.languageCode, 'tr');
      expect(appState.locale, const Locale('tr'));
      expect(appState.strings.isTr, isTrue);

      // Switch to English manually
      await appState.setLanguage('en');
      expect(appState.languagePreference, 'en');
      expect(appState.languageCode, 'en');
      expect(appState.locale, const Locale('en'));
      expect(appState.strings.isTr, isFalse);

      // Switch back to system
      await appState.setLanguage('system');
      expect(appState.languagePreference, 'system');
      expect(appState.languageCode, 'en');
    });

    testWidgets('PaywallScreen renders English copy when languageCode is en', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: PaywallScreen(
            languageCode: 'en',
            currencySymbol: '\$',
            monthlySpend: 500,
            onSubscribeSuccess: (_) {},
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));

      // Header & VIP Pill in EN
      expect(find.text('NORA VIP PROTECTION'), findsOneWidget);
      expect(find.textContaining('Secure Your Money'), findsOneWidget);
      expect(find.textContaining('& Your Future'), findsOneWidget);

      // 4 Pillars in EN
      expect(find.text('Strict Shield'), findsOneWidget);
      expect(find.text('Live Savings'), findsOneWidget);
      expect(find.text('SOS Urge Mode'), findsOneWidget);
      expect(find.text('Willpower Journal'), findsOneWidget);

      // Plans in EN
      expect(find.text('ANNUAL PROTECTION'), findsOneWidget);
      expect(find.text('7 DAYS FREE'), findsOneWidget);
      expect(find.text('Start 7-Day Free Trial'), findsOneWidget);

      // Verify 'Today' and 'then' localization (English)
      expect(find.text('Today'), findsWidgets);
      expect(find.textContaining('then '), findsWidgets);
      expect(find.text('Bugün'), findsNothing);
      expect(find.textContaining('sonra '), findsNothing);
    });

    testWidgets('ProfileScreen renders Language setting tile and allows switching language', (tester) async {
      final appState = AppState();
      await appState.saveUserProfile(
        UserProfile(
          monthlySpend: 5000,
          hoursPerDay: 2,
          selectedAddictions: ['Spor'],
          selectedTriggers: ['Stres'],
          mainMotivation: 'Huzur',
          quitDate: DateTime.now().subtract(const Duration(days: 10)),
        ),
      );

      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileScreen(
            appState: appState,
            onOpenPaywall: () {},
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));

      // Scroll to Language tile
      final langTile = find.text(appState.strings.languageTitle);
      await tester.ensureVisible(langTile);
      await tester.pump(const Duration(milliseconds: 300));
      expect(langTile, findsOneWidget);

      // Tap Language tile to open selection sheet
      await tester.tap(langTile);
      await tester.pumpAndSettle();

      // Verify bottom sheet options
      expect(find.text('Follows device system language'), findsOneWidget);
      final trOption = find.text('Türkçe');
      expect(trOption, findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Select Türkçe
      await tester.tap(trOption);
      await tester.pumpAndSettle();

      expect(appState.languagePreference, 'tr');
      expect(appState.languageCode, 'tr');
    });
  });
}
