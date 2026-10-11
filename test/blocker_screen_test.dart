import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/blocker/blocker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('BlockerScreen renders without overflow in Turkish and English', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = AppState();
    await appState.setLanguage('tr');

    await tester.pumpWidget(
      MaterialApp(
        home: BlockerScreen(appState: appState),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Kalkan Merkezi'), findsOneWidget);
    expect(find.text('KORUMA KATI MODDA AKTİF'), findsOneWidget);
    expect(find.text('KALKAN MODÜLLERİ'), findsOneWidget);
    expect(find.text('ÖZEL ENGELLEME LİSTESİ'), findsOneWidget);
    expect(find.text('ENGELLEME KATEGORİLERİ'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Switch to English dynamically
    await appState.setLanguage('en');
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Shield Hub'), findsOneWidget);
    expect(find.text('STRICT SHIELD ACTIVE'), findsOneWidget);
    expect(find.text('SHIELD MODULES'), findsOneWidget);
    expect(find.text('CUSTOM BLOCKLIST'), findsOneWidget);
    expect(find.text('BLOCKED CATEGORIES'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
