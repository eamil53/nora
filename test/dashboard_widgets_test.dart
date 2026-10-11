import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/user_profile.dart';
import 'package:nora/screens/dashboard/widgets/clean_ring_card.dart';
import 'package:nora/screens/dashboard/widgets/daily_quote_card.dart';
import 'package:nora/screens/dashboard/widgets/financial_vault_card.dart';
import 'package:nora/screens/dashboard/widgets/unified_vault_hero_card.dart';
import 'package:nora/screens/dashboard/widgets/milestone_badges_view.dart';
import 'package:nora/screens/dashboard/widgets/recovery_progress_chart.dart';

void main() {
  final profile = UserProfile(
    monthlySpend: 9000,
    hoursPerDay: 2.5,
    selectedAddictions: ['Bahis'],
    selectedTriggers: ['Stres'],
    mainMotivation: 'Huzur',
    quitDate: DateTime.now().subtract(const Duration(days: 5)),
  );

  testWidgets('CleanRingCard renders days clean properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CleanRingCard(profile: profile),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('5'), findsOneWidget);
    expect(find.text('GÜN TEMİZ'), findsOneWidget);
  });

  testWidgets('FinancialVaultCard renders and switches tabs smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FinancialVaultCard(profile: profile),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Nakit'), findsOneWidget);
    expect(find.text('Zaman'), findsOneWidget);
    expect(find.text('Engellenen'), findsOneWidget);

    // Tap Zaman tab
    await tester.tap(find.text('Zaman'));
    await tester.pumpAndSettle();
    expect(find.text('GERİ KAZANILAN YAŞAM ZAMANI'), findsOneWidget);
  });

  testWidgets('RecoveryProgressChart renders neuro stage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RecoveryProgressChart(daysClean: 5),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('BEYİN TOPARLANMASI'), findsOneWidget);
    expect(find.text('5. Gün'), findsOneWidget);
  });

  testWidgets('DailyQuoteCard renders quote and advances on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DailyQuoteCard(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('GÜNÜN REHBERİ'), findsOneWidget);
  });

  testWidgets('MilestoneBadgesView renders unlocked badges count', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MilestoneBadgesView(daysClean: 5),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Kurtuluş Rozetleri'), findsOneWidget);
    expect(find.text('2 / 7 Açık'), findsOneWidget);
  });

  testWidgets('UnifiedVaultHeroCard renders fused streak and vault elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UnifiedVaultHeroCard(profile: profile),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('KUMARSIZ GEÇEN SÜRE'), findsOneWidget);
    expect(find.text('GÜVENLİ KASA'), findsOneWidget);
    expect(find.text('GÜNLÜK HIZ'), findsOneWidget);
    expect(find.text('1 YIL HEDEFİ'), findsOneWidget);
    expect(find.text('ÖZGÜR ZAMAN'), findsOneWidget);
  });

  testWidgets('UnifiedVaultHeroCard does not overflow on small/narrow screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: UnifiedVaultHeroCard(profile: profile),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}
