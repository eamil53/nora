import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/screens/paywall/paywall_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PaywallScreen renders headline, pillars, plan selection and handles payment', (tester) async {
    String? subscribedPlan;
    bool backPressed = false;

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PaywallScreen(
          onSubscribeSuccess: (plan) {
            subscribedPlan = plan;
          },
          onBack: () {
            backPressed = true;
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // Test back button
    final closeBtn = find.byIcon(CupertinoIcons.xmark);
    expect(closeBtn, findsOneWidget);
    await tester.tap(closeBtn);
    expect(backPressed, isTrue);

    // 1. Check Header & Headline
    expect(find.text('NORA VIP KORUMA'), findsOneWidget);
    expect(find.textContaining('Paranı ve Geleceğini'), findsOneWidget);
    expect(find.textContaining('Güvenceye Al'), findsOneWidget);

    // 2. Check Dynamic ROI & Amorti Loop Capsule (Starts with 1. Hafta amorti)
    expect(find.text('⏱️ 1. Hafta'), findsOneWidget);
    expect(find.text('Nora Amorti'), findsOneWidget);
    expect(find.text('Cepte Kalan'), findsWidgets);

    // Tap capsule to advance to 1. Ay (biriktirdiği para)
    await tester.tap(find.text('⏱️ 1. Hafta'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('📅 1. Ay'), findsOneWidget);
    expect(find.text('Alışkanlık Kırıldı'), findsOneWidget);

    // Tap through remaining milestones (3. Ay -> 1. Yıl -> Topluluk Güveni)
    await tester.tap(find.text('📅 1. Ay'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('🚀 3. Ay'), findsOneWidget);

    await tester.tap(find.text('🚀 3. Ay'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('👑 1. Yıl'), findsOneWidget);

    await tester.tap(find.text('👑 1. Yıl'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('⭐ 4.9/5'), findsOneWidget);
    expect(find.text('🛡️ 10.000+'), findsOneWidget);

    // 3. Check 4 Core Pillars
    expect(find.text('Katı Kalkan'), findsOneWidget);
    expect(find.text('Canlı Tasarruf'), findsOneWidget);
    expect(find.text('SOS Dürtü Modu'), findsOneWidget);
    expect(find.text('İrade Günlüğü'), findsOneWidget);

    // 4. Check Plans & Trial Badges
    expect(find.text('YILLIK KORUMA'), findsOneWidget);
    expect(find.text('7 gün ücretsiz'), findsOneWidget);
    expect(find.text('EN POPÜLER • %42 KAZANÇ'), findsOneWidget);
    expect(find.text('AYLIK KORUMA'), findsOneWidget);
    expect(find.text('3 gün ücretsiz'), findsOneWidget);
    expect(find.text('7 Gün Ücretsiz Denemeyi Başlat'), findsOneWidget);
    expect(find.text('Kullanım Koşulları'), findsOneWidget);
    expect(find.text('Gizlilik Politikası'), findsOneWidget);
    expect(find.text('Satın Almayı Geri Yükle'), findsOneWidget);

    // Switch to Monthly plan
    await tester.ensureVisible(find.text('AYLIK KORUMA'));
    await tester.tap(find.text('AYLIK KORUMA'));
    await tester.pump(const Duration(milliseconds: 200));

    // Check dynamic update to 3-day trial CTA
    final ctaButton = find.text('3 Gün Ücretsiz Denemeyi Başlat');
    expect(ctaButton, findsOneWidget);

    // 5. Test Payment / Free Trial Simulation
    await tester.ensureVisible(ctaButton);
    await tester.tap(ctaButton);

    // Advance clock past simulation delay (1200ms)
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump(const Duration(milliseconds: 300));

    // Modal sheet should now be shown
    expect(find.text('Ücretsiz Denemeniz Başlatıldı!'), findsOneWidget);
    expect(find.text('Uygulamaya Başla'), findsOneWidget);

    // Tap "Uygulamaya Başla"
    await tester.tap(find.text('Uygulamaya Başla'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(subscribedPlan, 'monthly');
  });

  testWidgets('PaywallScreen renders without overflow on narrow device (320px)', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PaywallScreen(
          onSubscribeSuccess: (_) {},
          onBack: () {},
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('NORA VIP KORUMA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('PaywallScreen dynamically calculates savings and days to amortize based on custom monthlySpend', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // monthlySpend = 12.000 TL
    // Daily spend = 400 TL
    // Annual plan monthly equivalent = 291.66 TL -> 291.66 / 400 = 1 gün
    // Week 1 saved = 12.000 / 4 = 3.000 TL
    await tester.pumpWidget(
      MaterialApp(
        home: PaywallScreen(
          monthlySpend: 12000.0,
          onSubscribeSuccess: (_) {},
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // Dynamic badge and milestone check
    expect(find.text('⚡ 1 Günde'), findsOneWidget);
    expect(find.text('💰 +₺3.000'), findsOneWidget);
    expect(find.textContaining('Aylık ₺12.000 harcamanıza göre'), findsOneWidget);

    // Tap to 1. Ay milestone
    await tester.tap(find.text('⏱️ 1. Hafta'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('📅 1. Ay'), findsOneWidget);
    expect(find.text('💰 +₺12.000'), findsOneWidget);

    // Switch to Monthly plan (500 TL cost -> 500 / 400 = 2 days)
    await tester.ensureVisible(find.text('AYLIK KORUMA'));
    await tester.tap(find.text('AYLIK KORUMA'));
    await tester.pump(const Duration(milliseconds: 200));

    // Milestone 1 (when returned) or dynamic badge updates
    expect(find.textContaining('Nora kendini sadece 2 günde amorti eder'), findsOneWidget);
  });
}
