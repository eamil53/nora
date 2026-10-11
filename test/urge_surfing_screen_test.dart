import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/sos/urge_surfing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('UrgeSurfingScreen renders and switches tools smoothly', (tester) async {
    final appState = AppState();
    await appState.setLanguage('tr');

    // Standard mobile screen
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: UrgeSurfingScreen(appState: appState),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // Verify header and initial tool (4-7-8 Breathing)
    expect(find.text('Kriz & SOS Modu'), findsOneWidget);
    expect(find.text('Oynama İsteği mi Geldi?'), findsOneWidget);
    expect(find.text('4-7-8 Nefes'), findsOneWidget);
    expect(find.text('Nefes Egzersizini Başlat'), findsOneWidget);
    expect(find.text('YEDAM Danışma Hattı'), findsOneWidget);

    // Switch to Tool 1: Dalga Sörfü (15 Dk)
    final waveTab = find.text('Dalga Sörfü (15 Dk)');
    expect(waveTab, findsOneWidget);
    await tester.tap(waveTab);
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('15 Dakikalık İstek Erteleme Sayacı'), findsOneWidget);
    expect(find.text('Sayacı Başlat'), findsOneWidget);
    expect(find.text('Sıfırla'), findsOneWidget);

    // Switch to Tool 2: Gerçeklik Çapası
    final anchorTab = find.text('Gerçeklik Çapası');
    expect(anchorTab, findsOneWidget);
    await tester.tap(anchorTab);
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Finansal Gerçeklik Çapası'), findsOneWidget);
    expect(find.text('KORUNAN PARA'), findsOneWidget);
    expect(find.text('TEMİZ GEÇEN'), findsOneWidget);
    expect(find.textContaining('Hızlı Zihin Topraklama'), findsOneWidget);
  });

  testWidgets('UrgeSurfingScreen renders without overflow on narrow device', (tester) async {
    final appState = AppState();
    await appState.setLanguage('tr');

    // Small device (e.g. iPhone SE / 320 width)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: UrgeSurfingScreen(appState: appState),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Kriz & SOS Modu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
