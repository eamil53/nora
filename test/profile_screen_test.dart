import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/user_profile.dart';
import 'package:nora/providers/app_state.dart';
import 'package:nora/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({'nora_language_preference': 'tr'});
  });

  testWidgets('ProfileScreen renders hero card, VIP subscription, and setting sections', (tester) async {
    final appState = AppState();

    await appState.saveUserProfile(
      UserProfile(
        monthlySpend: 5000,
        hoursPerDay: 2,
        selectedAddictions: ['Spor Bahisleri'],
        selectedTriggers: ['Stres'],
        mainMotivation: 'Ailem ve geleceğim için',
        quitDate: DateTime.now().subtract(const Duration(days: 14)),
        currencySymbol: '₺',
      ),
    );

    bool paywallOpened = false;

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          appState: appState,
          onOpenPaywall: () {
            paywallOpened = true;
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // 1. Verify Header & Hero Profile
    expect(find.text('Profil & Ayarlar'), findsOneWidget);
    expect(find.text('İrade Savaşçısı'), findsOneWidget);
    expect(find.text('Aktif Mücadele'), findsOneWidget);
    expect(find.text('“Ailem ve geleceğim için”'), findsOneWidget);

    // 2. Verify Stats
    expect(find.text('14 Gün'), findsOneWidget);
    expect(find.text('Temiz Geçen'), findsOneWidget);

    // 3. Verify VIP Membership Card & Paywall callback
    expect(find.text('Nora VIP Üyelik'), findsOneWidget);
    final manageBtn = find.text('Yönet');
    expect(manageBtn, findsOneWidget);
    await tester.tap(manageBtn);
    expect(paywallOpened, isTrue);

    // 4. Verify Sections
    expect(find.text('KORUMA & GÜVENLİK DÜZEYİ'), findsOneWidget);
    expect(find.text('iOS Ekran Süresi İzni'), findsOneWidget);
    expect(find.text('VPN & Bypass Kalkanı'), findsOneWidget);

    expect(find.text('YOLCULUK & SAYAÇ YÖNETİMİ'), findsOneWidget);
    expect(find.text('Temizlik Tarihini Yenile'), findsOneWidget);

    // 5. Test opening Reset Quit Date native iOS dialog
    await tester.tap(find.text('Temizlik Tarihini Yenile'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Temiz Sayfayı Aç'), findsOneWidget);
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Yeniden Başla'), findsOneWidget);

    // Dismiss dialog
    await tester.tap(find.text('Vazgeç'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Temiz Sayfayı Aç'), findsNothing);

    // 5.5 Verify Legal links (Privacy Policy & Terms of Use EULA)
    expect(find.text('Gizlilik Politikası'), findsOneWidget);
    expect(find.text('Kullanım Koşulları'), findsOneWidget);

    // 6. Test opening Reset Full App native iOS dialog
    await tester.ensureVisible(find.text('Tüm Uygulama Verilerini Sıfırla'));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Tüm Uygulama Verilerini Sıfırla'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Tüm Verileri Sıfırla?'), findsOneWidget);
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Kalıcı Olarak Sil'), findsOneWidget);

    // Dismiss dialog
    await tester.tap(find.text('Vazgeç'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Tüm Verileri Sıfırla?'), findsNothing);
  });

  testWidgets('ProfileScreen renders without overflow on narrow device (320px)', (tester) async {
    final appState = AppState();

    tester.view.physicalSize = const Size(320, 568);
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

    expect(find.text('Profil & Ayarlar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProfileScreen opens VIP Membership Details screen when subscribed', (tester) async {
    final appState = AppState();
    await appState.activateSubscription(plan: 'annual', isTrial: true);

    bool paywallOpened = false;

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          appState: appState,
          onOpenPaywall: () {
            paywallOpened = true;
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Nora VIP Üyelik'), findsOneWidget);
    final manageBtn = find.text('Yönet');
    expect(manageBtn, findsOneWidget);

    await tester.tap(manageBtn);
    await tester.pumpAndSettle();

    // Paywall callback should NOT be opened for subscribed users
    expect(paywallOpened, isFalse);

    // VIP Membership Details screen should be displayed
    expect(find.text('Nora VIP Üyelik Detayları'), findsAtLeastNWidgets(1));
    expect(find.text('Aboneliği Mağazada Yönet'), findsOneWidget);
    expect(find.text('Satın Alımları Geri Yükle'), findsOneWidget);
  });
}
