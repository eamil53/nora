import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/journal_entry.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/journal/journal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({'nora_language_preference': 'tr'});
  });

  testWidgets('JournalScreen renders empty state, expands form and handles entries', (tester) async {
    final appState = AppState();

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: JournalScreen(appState: appState),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // Verify header and empty state
    expect(find.text('Duygu & İrade Günlüğü'), findsOneWidget);
    expect(find.text('İçgörü & Farkındalık'), findsOneWidget);
    expect(find.text('Henüz Günlük Kaydınız Yok'), findsOneWidget);

    // Tap "Giriş Ekle" button in header to expand form
    final addBtn = find.text('Giriş Ekle');
    expect(addBtn, findsOneWidget);
    await tester.tap(addBtn);
    await tester.pump(const Duration(milliseconds: 350));

    // Form should now be expanded
    expect(find.text('Bugünkü İrade Check-in\'i'), findsOneWidget);
    expect(find.text('Günlüğü Kaydet'), findsOneWidget);

    // Add a mock entry to test entry card rendering
    await appState.addJournalEntry(
      JournalEntry(
        id: 'test-1',
        date: DateTime.now(),
        cravingLevel: 2,
        mood: 'Sakin',
        triggersEncountered: ['Stres'],
        note: 'Bugün harika bir yürüyüş yaptım ve zihnimi toparladım.',
      ),
    );

    await tester.pump(const Duration(milliseconds: 350));

    // Verify existing entry displays properly
    expect(find.textContaining('Ruh Hali: Sakin'), findsOneWidget);
    expect(find.textContaining('İstek: 2/5'), findsOneWidget);
    expect(find.text('⚡ Stres'), findsOneWidget);
    expect(find.text('Bugün harika bir yürüyüş yaptım ve zihnimi toparladım.'), findsOneWidget);
    expect(find.text('1 Kayıt'), findsOneWidget);
  });

  testWidgets('JournalScreen renders without overflow on narrow device', (tester) async {
    final appState = AppState();

    // Small device (e.g. iPhone SE / 320 width)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: JournalScreen(appState: appState),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Duygu & İrade Günlüğü'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('AppState presentAddJournalEntrySheet processes native sheet results and passes languageCode', () async {
    final appState = AppState();
    while (appState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 20));
    }

    Map<String, dynamic>? receivedArgs;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.nora.blocker/screentime'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'presentAddJournalEntrySheet') {
          receivedArgs = (methodCall.arguments as Map?)?.cast<String, dynamic>();
          return {
            'mood': 'Harika',
            'cravingLevel': 3,
            'triggers': ['Sosyal Medya', 'Stres'],
            'note': 'Native sheet test notu.',
          };
        }
        return null;
      },
    );

    final entry = await appState.presentAddJournalEntrySheet();
    expect(entry, isNotNull);
    expect(entry!.mood, 'Harika');
    expect(entry.cravingLevel, 3);
    expect(entry.triggersEncountered, contains('Sosyal Medya'));
    expect(entry.triggersEncountered, contains('Stres'));
    expect(entry.note, 'Native sheet test notu.');
    expect(appState.journalEntries.length, 1);
    expect(receivedArgs, isNotNull);
    expect(receivedArgs!['languageCode'], appState.languageCode);
  });

  test('AppState presentAddCustomDomainSheet passes languageCode and adds domain', () async {
    final appState = AppState();
    while (appState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 20));
    }

    Map<String, dynamic>? receivedArgs;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.nora.blocker/screentime'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'presentAddDomainSheet') {
          receivedArgs = (methodCall.arguments as Map?)?.cast<String, dynamic>();
          return {
            'domain': 'gambling-block-test.com',
            'category': 'Illegal Betting & Casino',
          };
        }
        return null;
      },
    );

    final res = await appState.presentAddCustomDomainSheet();
    expect(res, isNotNull);
    expect(res!['domain'], 'gambling-block-test.com');
    expect(appState.customBlockedDomains, contains('gambling-block-test.com'));
    expect(receivedArgs, isNotNull);
    expect(receivedArgs!['languageCode'], appState.languageCode);
  });
}
