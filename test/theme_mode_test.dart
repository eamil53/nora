import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/journal_entry.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/blocker/blocker_screen.dart';
import 'package:nora/screens/journal/journal_screen.dart';
import 'package:nora/screens/profile/profile_screen.dart';
import 'package:nora/theme/app_colors.dart';
import 'package:nora/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Semantic Theme & AppColors Tests', () {
    test('AppColors.light provides crisp white canvas, card, and dark typography', () {
      const light = AppColors.light;
      expect(light.isDark, false);
      expect(light.surfaceCanvas, const Color(0xFFF4F6F9));
      expect(light.surfaceCard, const Color(0xFFFFFFFF));
      expect(light.textPrimary, const Color(0xFF0F172A));
      expect(light.accentPrimary, const Color(0xFF00E676));
    });

    test('AppColors.dark provides midnight black canvas, card, and light typography', () {
      const dark = AppColors.dark;
      expect(dark.isDark, true);
      expect(dark.surfaceCanvas, const Color(0xFF070A12));
      expect(dark.surfaceCard, const Color(0xFF101726));
      expect(dark.textPrimary, const Color(0xFFF9FAFB));
      expect(dark.accentPrimary, const Color(0xFF00E676));
    });

    test('AppTheme generates valid light and dark ThemeData', () {
      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;

      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.scaffoldBackgroundColor, AppColors.light.surfaceCanvas);

      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.scaffoldBackgroundColor, AppColors.dark.surfaceCanvas);
    });

    test('AppState persists and updates ThemeMode correctly', () async {
      final appState = AppState();
      expect(appState.themeMode, ThemeMode.system);

      await appState.setThemeMode(ThemeMode.light);
      expect(appState.themeMode, ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nora_theme_mode'), 'light');

      await appState.setThemeMode(ThemeMode.dark);
      expect(appState.themeMode, ThemeMode.dark);
      expect(prefs.getString('nora_theme_mode'), 'dark');

      await appState.setThemeMode(ThemeMode.system);
      expect(appState.themeMode, ThemeMode.system);
      expect(prefs.getString('nora_theme_mode'), 'system');
    });

    testWidgets('ProfileScreen shows Tema item and allows selecting theme mode', (tester) async {
      SharedPreferences.setMockInitialValues({'nora_language_preference': 'tr'});
      final appState = AppState();
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode,
          home: ProfileScreen(
            appState: appState,
            onOpenPaywall: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to "Uygulama Teması" setting row
      final themeRow = find.text('Uygulama Teması');
      await tester.scrollUntilVisible(themeRow, 200);
      expect(themeRow, findsOneWidget);

      // Tap to open modal
      await tester.tap(themeRow);
      await tester.pumpAndSettle();

      // Verify modal sheet options
      expect(find.text('Karanlık veya aydınlık görünüm tercihini seçin'), findsOneWidget);
      expect(find.text('Açık Mod (Beyaz)'), findsOneWidget);
      expect(find.text('Koyu Mod (Siyah)'), findsOneWidget);
      expect(find.text('Otomatik (Sistem)'), findsWidgets);

      // Select "Açık Mod (Beyaz)"
      await tester.tap(find.text('Açık Mod (Beyaz)'));
      await tester.pumpAndSettle();

      expect(appState.themeMode, ThemeMode.light);
    });

    testWidgets('JournalScreen renders with high contrast in Light Mode', (tester) async {
      SharedPreferences.setMockInitialValues({'nora_theme_mode': 'light', 'nora_language_preference': 'tr'});
      final appState = AppState();
      appState.addJournalEntry(JournalEntry(
        id: '1',
        date: DateTime.now(),
        cravingLevel: 1,
        mood: 'Sakin',
        triggersEncountered: ['Stres'],
        note: 'Bugün harika bir gündü, yürüyüş yaptım.',
      ));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: JournalScreen(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Duygu & İrade Günlüğü'), findsOneWidget);
      expect(find.text('İçgörü & Farkındalık'), findsOneWidget);
      expect(find.text('Bugün harika bir gündü, yürüyüş yaptım.'), findsOneWidget);
      expect(find.text('Ruh Hali: Sakin'), findsOneWidget);
      expect(find.text('⚡ Stres'), findsOneWidget);
    });

    testWidgets('BlockerScreen custom blocklist subtitle renders in Light Mode', (tester) async {
      SharedPreferences.setMockInitialValues({'nora_theme_mode': 'light', 'nora_language_preference': 'tr'});
      final appState = AppState();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: BlockerScreen(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(appState.strings.customBlocklist), findsOneWidget);
      expect(
        find.text(appState.strings.customBlocklistSub),
        findsOneWidget,
      );
      expect(find.text(appState.strings.addDomainButton), findsOneWidget);
    });
  });
}
