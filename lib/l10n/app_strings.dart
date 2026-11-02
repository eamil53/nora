import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// Nora Uygulaması Yerelleştirme Sınıfı (TR & EN)
class AppStrings {
  final String languageCode;

  const AppStrings(this.languageCode);

  bool get isTr => languageCode == 'tr';

  static AppStrings get(String? langCode) {
    if (langCode == null) return const AppStrings('tr');
    final clean = langCode.toLowerCase().trim();
    if (clean.startsWith('tr')) return const AppStrings('tr');
    return const AppStrings('en');
  }

  static AppStrings of(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context);
    return get(locale?.languageCode);
  }

  // --- GENERAL & APP LEVEL ---
  String get appTitle => isTr ? 'Nora - Kumarı Bırak & Paran Sakla' : 'Nora - Quit Gambling & Save Money';
  String get appTagline => isTr ? 'Özgürlüğe ve Huzura Açılan Kalkan' : 'Your Shield to Freedom & Peace';
  String get cancel => isTr ? 'İptal' : 'Cancel';
  String get save => isTr ? 'Kaydet' : 'Save';
  String get done => isTr ? 'Tamam' : 'Done';
  String get close => isTr ? 'Kapat' : 'Close';
  String get delete => isTr ? 'Sil' : 'Delete';
  String get active => isTr ? 'AKTİF' : 'ACTIVE';
  String get inactive => isTr ? 'PASİF' : 'INACTIVE';
  String get error => isTr ? 'Hata' : 'Error';
  String get success => isTr ? 'Başarılı' : 'Success';

  // --- SPLASH SCREEN ---
  String get splashSubtitle => isTr ? 'Paranı ve Geleceğini Geri Kazan' : 'Reclaim Your Money & Future';
  String get splashSecuredStatus => isTr ? 'Katı Kalkan Hazırlanıyor...' : 'Strict Shield Initializing...';

  // --- ONBOARDING FLOW ---
  String get onboardingWelcomeTitle => isTr ? 'Kumarı Arkanda Bırakmaya\nHazır Mısın?' : 'Ready to Leave Gambling\nBehind For Good?';
  String get onboardingWelcomeSubtitle => isTr
      ? 'Nora, zayıf anlarında devreye giren ve finansal geleceğini koruyan 1 numaralı kalkanındır.'
      : 'Nora is your #1 strict shield that intervenes during vulnerable urges and protects your financial future.';
  String get onboardingStartButton => isTr ? 'Yolculuğa Başla' : 'Start Your Journey';
  String get onboardingNext => isTr ? 'Devam Et' : 'Continue';
  String get onboardingBack => isTr ? 'Geri' : 'Back';
  String get onboardingStep1Title => isTr ? 'Hangi Kumar Türüyle Mücadele Ediyorsun?' : 'Which Type of Gambling Are You Fighting?';
  String get onboardingStep1Subtitle => isTr ? 'Birden fazla seçebilirsin.' : 'You can select multiple.';
  String get onboardingStep2Title => isTr ? 'Aylık Kumara Yaklaşık Ne Kadar Harcıyordun?' : 'How Much Were You Spending Per Month?';
  String get onboardingStep2Subtitle => isTr ? 'Tasarruf sayacın buna göre hesaplanacaktır.' : 'Your savings vault will be calculated based on this.';
  String get onboardingStep3Title => isTr ? 'Günde Kaç Saatini Alıyordu?' : 'How Many Hours Per Day Did It Consume?';
  String get onboardingStep4Title => isTr ? 'Seni En Çok Ne Tetikliyor?' : 'What Triggers Your Gambling Urges Most?';
  String get onboardingStep5Title => isTr ? 'En Büyük Bırakma Motivasyonun Nedir?' : 'What Is Your Biggest Motivation to Quit?';
  String get onboardingFinishButton => isTr ? 'Korumamı Başlat' : 'Activate My Protection';

  // Addictions
  String get addictionIllegalBetting => isTr ? 'Yasa Dışı Bahis & İddaa' : 'Sports Betting & Bookmakers';
  String get addictionCasino => isTr ? 'Online Casino & Slot Oyunları' : 'Online Casino & Slots';
  String get addictionCryptoFutures => isTr ? 'Kaldıraçlı Kripto & Forex' : 'Leveraged Crypto & Forex';
  String get addictionHorseRacing => isTr ? 'At Yarışı & Şans Oyunları' : 'Lottery & Horse Racing';
  String get addictionPoker => isTr ? 'Poker & Canlı Masa Oyunları' : 'Poker & Live Table Games';

  // Triggers
  String get surveyTriggerStress => isTr ? 'Finansal Stres & Borçlar' : 'Financial Stress & Debt';
  String get triggerAds => isTr ? 'Sosyal Medya & Reklamlar' : 'Social Media & Ads';
  String get triggerBoredom => isTr ? 'Gece Yalnızlık & Can Sıkıntısı' : 'Late Night Loneliness & Boredom';
  String get triggerAlcohol => isTr ? 'Alkol veya Sosyal Ortamlar' : 'Alcohol or Social Gatherings';
  String get triggerChasingLosses => isTr ? 'Kaybı Geri Kazanma Hırsı' : 'Chasing Losses';

  // Motivations
  String get motivationFamily => isTr ? 'Aile Huzuru & Sevdiklerim' : 'Family Peace & Loved Ones';
  String get motivationDebtFree => isTr ? 'Borçsuz ve Özgür Bir Hayat' : 'Debt-Free & Independent Life';
  String get motivationMentalPeace => isTr ? 'Ruhsal Sakinlik ve Temiz Vicdan' : 'Mental Peace & Clear Conscience';
  String get motivationFutureInvest => isTr ? 'Geleceğe Güvenle Yatırım Yapmak' : 'Building a Secure Future';

  // --- PAYWALL SCREEN ---
  String get paywallVipBadge => isTr ? 'NORA VIP KORUMA' : 'NORA VIP PROTECTION';
  String get paywallHeadline1 => isTr ? 'Paranı ve Geleceğini\n' : 'Protect Your Money\n';
  String get paywallHeadline2 => isTr ? 'Güvenceye Al' : '& Your Future';
  String get paywallSubtitle => isTr
      ? 'Zayıf anlarında devreye giren ve kumar bağımlılığını sonlandıran 1 numaralı kalkan.'
      : 'The #1 shield that steps in during weak moments and ends gambling addiction.';
  String get paywallAmortizePrefix => isTr ? 'Aylık' : 'Based on your monthly';
  String get paywallAmortizeSuffix => isTr
      ? 'harcamanıza göre: Nora kendini sadece'
      : 'spend: Nora pays for itself in just';
  String get paywallAmortizeDays => isTr ? 'günde amorti eder' : 'days';

  // Paywall 4 Pillars
  String get pillar1Title => isTr ? 'Katı Kalkan' : 'Strict Shield';
  String get pillar1Desc => isTr ? '3.850+ bahis sitesi cihaz düzeyinde kilitli.' : '3,850+ gambling sites locked at device level.';
  String get pillar1Tag => isTr ? 'KİLİT' : 'LOCK';

  String get pillar2Title => isTr ? 'Canlı Tasarruf' : 'Live Savings';
  String get pillar2Desc => isTr ? 'Kumardan kurtarılan nakit ve zaman sayacı.' : 'Real-time saved money & recovered time tracker.';
  String get pillar2Tag => isTr ? 'CANLI' : 'LIVE';

  String get pillar3Title => isTr ? 'SOS Dürtü Modu' : 'SOS Urge Mode';
  String get pillar3Desc => isTr ? 'Acil kriz anlarında relaps önleme protokolü.' : 'Emergency intervention protocol during acute urges.';
  String get pillar3Tag => isTr ? 'ACİL' : 'URGENT';

  String get pillar4Title => isTr ? 'İrade Günlüğü' : 'Willpower Journal';
  String get pillar4Desc => isTr ? 'Tetikleyicileri keşfet, relapsları önle.' : 'Discover emotional triggers, prevent relapses.';
  String get pillar4Tag => isTr ? 'GÜNLÜK' : 'JOURNAL';

  // Paywall Timeline
  String paywallTimelineHeader(int days) => isTr ? '$days GÜNLÜK ÜCRETSİZ DENEME AKIŞI' : '$days-DAY FREE TRIAL TIMELINE';
  String get paywallTimelineTodayTitle => isTr ? 'Bugün' : 'Today';
  String get paywallTimelineTodayHighlight => isTr ? '0 ₺ Tahsil Edilir' : '0 ₺ Charged Today';
  String get paywallTimelineTodayDesc => isTr ? 'Nora Katı Kalkanı anında başlar. 3.850+ site kilitlenir.' : 'Nora Strict Shield activates immediately. 3,850+ sites blocked.';
  String paywallTimelineReminderTitle(int day) => isTr ? '$day. Gün' : 'Day $day';
  String get paywallTimelineReminderHighlight => isTr ? 'Hatırlatma Bildirimi' : 'Reminder Notification';
  String get paywallTimelineReminderDesc => isTr ? 'Denemenizin bitmesine 2 gün kala hatırlatma alırsınız.' : 'You get a reminder 2 days before trial ends.';
  String paywallTimelineAutoTitle(int day) => isTr ? '$day. Gün' : 'Day $day';
  String paywallTimelineAutoHighlight(String cost) => isTr ? 'Otomatik Abonelik ($cost)' : 'Auto-Subscription ($cost)';
  String get paywallTimelineAutoDesc => isTr ? 'Abonelik başlar. İstediğiniz an tek tıkla iptal edebilirsiniz.' : 'Subscription begins. Cancel anytime with one tap.';

  // Plans
  String get planAnnualTitle => isTr ? 'YILLIK KORUMA' : 'ANNUAL PROTECTION';
  String get planAnnualBadge => isTr ? 'EN POPÜLER • %42 KAZANÇ' : 'MOST POPULAR • 42% SAVINGS';
  String get planAnnualTrialBadge => isTr ? '7 gün ücretsiz' : '7 days free trial';
  String get planAnnualPeriod => isTr ? ' /yıl' : ' /yr';
  String planAnnualSubtext(String monthlyEq, int days) => isTr
      ? 'Sadece $monthlyEq /aylık • $days günde amorti'
      : 'Only $monthlyEq /month • Pays for itself in $days days';

  String get planMonthlyTitle => isTr ? 'AYLIK KORUMA' : 'MONTHLY PROTECTION';
  String get planMonthlyTrialBadge => isTr ? '3 gün ücretsiz' : '3 days free trial';
  String get planMonthlyPeriod => isTr ? ' /aylık' : ' /mo';
  String planMonthlySubtext(int days) => isTr
      ? 'Esnek aylık yenileme • $days günde amorti'
      : 'Flexible monthly renewal • Pays for itself in $days days';

  String get zeroToday => isTr ? '0 ₺' : '\$0';
  String get todayLabel => isTr ? 'Bugün' : 'Today';
  String thenLabel(String price, String period) => isTr ? 'sonra $price$period' : 'then $price$period';

  // CTA & Disclosures
  String paywallCtaText(int days) => isTr ? '$days Gün Ücretsiz Denemeyi Başlat' : 'Start $days-Day Free Trial';
  String paywallCtaSubtext(int days, String price, String period) => isTr
      ? '$days gün ücretsiz, sonra $price$period • Dilediğin an iptal et'
      : '$days days free, then $price$period • Cancel anytime';
  String get paywallZeroRisk => isTr ? 'İstediğin Zaman İptal Et • Sıfır Risk' : 'Cancel Anytime • 100% Risk-Free';
  String get paywallLegalDisclosure {
    final isAndroid = !kIsWeb && Platform.isAndroid;
    final storeName = isAndroid ? 'Google Play' : 'App Store';
    return isTr
        ? 'Deneme süresi bitiminden en az 24 saat önce iptal edilmediği takdirde aboneliğiniz seçilen plan üzerinden otomatik yenilenir. İstediğiniz an $storeName abonelik ayarlarınızdan iptal edebilirsiniz.'
        : 'Subscription automatically renews at chosen plan rate unless cancelled at least 24 hours before trial ends. Manage or cancel anytime in $storeName account settings.';
  }
  String get restorePurchases => isTr ? 'Satın Almayı Geri Yükle' : 'Restore Purchases';
  String get termsOfUse => isTr ? 'Kullanım Koşulları' : 'Terms of Use';
  String get privacyPolicy => isTr ? 'Gizlilik Politikası' : 'Privacy Policy';

  /// Official legal document URLs for App Store compliance
  static const String privacyPolicyUrl = 'https://nora-sand-mu.vercel.app/privacy.html';
  static const String termsOfUseUrl = 'https://nora-sand-mu.vercel.app/eula.html';

  // Abandoned Trial Notification (Sent 5 mins after app closed without starting trial)
  String get abandonedTrialNotificationTitle => isTr
      ? '🛡️ Nora Kalkanın Henüz Aktif Değil!'
      : '🛡️ Your Nora Shield is Not Active Yet!';
  String get abandonedTrialNotificationBody => isTr
      ? 'Kumar dürtüleri en savunmasız anında gelir. 0 ₺ ile 7 günlük ücretsiz denemeni hemen başlat, paranı ve sevdiklerini hemen güvenceye al.'
      : 'Gambling urges strike when least expected. Start your 7-day risk-free trial for 0 ₺ (\$0) and protect your hard-earned money now.';

  // Success Sheet
  String get trialSuccessTitle => isTr ? 'Ücretsiz Denemeniz Başlatıldı!' : 'Your Free Trial Has Started!';
  String trialSuccessBody(int days, String price, String period) => isTr
      ? 'Nora Katı Koruma Kalkanı aktif edildi! $days gün boyunca 0 ₺ ile tüm özellikleri sınırsız deneyimleyebilirsiniz. $days gün sonunda ($price/$period) otomatik abonelik başlar. Dilediğiniz zaman hesap ayarlarınızdan iptal edebilirsiniz.'
      : 'Nora Strict Protection Shield is now active! Enjoy full unlimited access for $days days at 0 ₺. Auto-subscription begins after $days days ($price/$period). Cancel anytime in account settings.';
  String get startAppButton => isTr ? 'Uygulamaya Başla' : 'Start Using App';

  // --- DASHBOARD / HOME ---
  String get welcomeUpper => isTr ? 'HOŞ GELDİNİZ' : 'WELCOME';
  String daysCleanVictory(int days) => isTr ? '$days Günlük Zafer 🔥' : '$days Days Victory 🔥';
  String get shieldActive => isTr ? 'Kalkan Aktif' : 'Shield Active';
  String get shieldInactive => isTr ? 'Kalkan Pasif' : 'Shield Inactive';
  String get secureVault => isTr ? 'GÜVENLİ KASA' : 'SECURE VAULT';
  String get tabCash => isTr ? 'Nakit' : 'Cash';
  String get tabTime => isTr ? 'Zaman' : 'Time';
  String get tabUrge => isTr ? 'Dürtü' : 'Urge';
  String get savedCash => isTr ? 'Kurtarılan Nakit' : 'Saved Cash';
  String get recoveredTime => isTr ? 'Kurtarılan Zaman' : 'Recovered Time';
  String get preventedBets => isTr ? 'Engellenen Bahis' : 'Prevented Bets';
  String get daysCleanUpper => isTr ? 'GÜN TEMİZ' : 'DAYS CLEAN';
  String get dailySpeed => isTr ? 'GÜNLÜK HIZ' : 'DAILY RATE';
  String get dailySpeedSub => isTr ? 'Her gün cebinde' : 'Saved daily';
  String get yearlyTarget => isTr ? '1 YIL HEDEFİ' : '1-YEAR TARGET';
  String get yearlyTargetSub => isTr ? 'Kurtarılan gelecek' : 'Secured future';
  String get willpowerLevel => isTr ? 'ENGELLEME' : 'PROTECTION';
  String get willpowerLevelSub => isTr ? 'Dürtü Savuşturuldu' : 'Urges Defeated';

  String get crisisCalloutTitle => isTr ? 'KRİZ ANINDA MISINIZ?' : 'IN AN URGENT CRISIS?';
  String get crisisCalloutSub => isTr ? '10 Dk Nefes ve İstek Erteleme Protokolü' : '10-Min Breathing & Urge Delay Protocol';
  String get dailyCheckInTitle => isTr ? 'Bugün Kumar Oynamadım' : 'I Didn\'t Gamble Today';
  String get dailyCheckInSub => isTr ? 'Her gün bir zaferdir. İradeni kaydet.' : 'Every day is a victory. Log your willpower.';
  String get dailyCheckInButton => isTr ? 'Kaydet' : 'Save';
  String get celebrationTitle => isTr ? 'Harikasın! Bir Gün Daha Özgürsün 🏆' : 'Awesome! Another Day Free 🏆';
  String get celebrationBody => isTr
      ? 'Bugünü de temiz tamamlayarak beynindeki dopamin dengesini güçlendirdin ve paranı korudun. Nora seninle gurur duyuyor!'
      : 'By staying clean today, you strengthened your dopamine balance and saved your money. Nora is proud of you!';
  String get celebrationButton => isTr ? 'İrademe Güveniyorum Devam!' : 'I Trust My Willpower, Continue!';

  String get brainRecovery => isTr ? 'BEYİN TOPARLANMASI' : 'BRAIN RECOVERY';
  String get dopamineHealing => isTr ? 'Dopamin Reseptör İyileşmesi' : 'Dopamine Receptor Healing';
  String get dailyMindset => isTr ? 'GÜNÜN MİNDSETİ' : 'DAILY MINDSET';
  String get nextQuote => isTr ? 'Sonraki' : 'Next';
  String get milestonesTitle => isTr ? 'Kurtuluş Rozetleri' : 'Milestone Badges';
  String unlockedBadgesCount(int unlocked) => isTr ? '$unlocked/7 Kazanıldı' : '$unlocked/7 Unlocked';

  // --- BLOCKER SCREEN ---
  String get shieldHub => isTr ? 'Kalkan Merkezi' : 'Shield Hub';
  String get appleWebKitProtection => isTr ? 'Apple WebKit & DNS Koruması' : 'Apple WebKit & DNS Protection';
  String get protectionActiveStrict => isTr ? 'KORUMA KATI MODDA AKTİF' : 'STRICT SHIELD ACTIVE';
  String filtersCount(int count) => isTr ? '$count+ Filtre' : '$count+ Filters';
  String get protectionSubtext => isTr
      ? 'Safari, Chrome ve tüm tarayıcılarda 7/24 engelli'
      : 'Blocked 24/7 in Safari, Chrome & all browsers';
  String get statusWebKit => isTr ? 'Kilitli' : 'Locked';
  String get statusDns => isTr ? 'Filtreli' : 'Filtered';
  String get statusVpn => isTr ? 'İzleniyor' : 'Monitored';
  String get shieldModules => isTr ? 'KALKAN MODÜLLERİ' : 'SHIELD MODULES';
  String get moduleStrictTitle => isTr ? 'Katı Kalkan Modu' : 'Strict Shield Mode';
  String get moduleStrictDesc => isTr ? 'Tavizsiz kilit, bypass engeli' : 'Strict lock, bypass prevention';
  String get moduleAntiBypassTitle => isTr ? 'Anti-Bypass Koruması' : 'Anti-Bypass Protection';
  String get moduleAntiBypassDesc => isTr ? 'Uygulama silmeyi engeller' : 'Prevents app uninstallation';
  String get moduleIncognitoTitle => isTr ? 'Gizli Sekme Engeli' : 'Private Browsing Block';
  String get moduleIncognitoDesc => isTr ? 'Anonim girişi kısıtlar' : 'Restricts incognito access';
  String get moduleSmartTitle => isTr ? 'Akıllı Analiz' : 'Smart Analysis';
  String get moduleSmartDesc => isTr ? 'Yeni kumar alanlarını tespit eder' : 'Detects emerging gambling sites';
  String get customBlocklist => isTr ? 'ÖZEL ENGELLEME LİSTESİ' : 'CUSTOM BLOCKLIST';
  String get customBlocklistSub => isTr
      ? 'Kendi belirlediğin siteleri Apple WebKit düzeyinde kilitle'
      : 'Block custom domains at Apple WebKit level';
  String get addDomainButton => isTr ? '+ Site Ekle' : '+ Add Site';
  String get addDomainHint => isTr ? 'Örn: kumar-sitesi.com' : 'e.g. gambling-site.com';
  String siteAddedSuccess(String domain) => isTr
      ? '"$domain" kalkan listesine başarıyla eklendi!'
      : '"$domain" successfully added to shield list!';
  String get customDomainsEmpty => isTr
      ? 'Henüz özel bir site eklemediniz.'
      : 'No custom sites added yet.';
  String get blockedCategories => isTr ? 'ENGELLEME KATEGORİLERİ' : 'BLOCKED CATEGORIES';
  String get allLocked => isTr ? 'Hepsi Kilitli' : 'All Locked';
  String get blockerPermissionTitle => isTr ? 'iOS Ekran Süresi İzni Gerekli' : 'Screen Time Permission Required';
  String get blockerPermissionDesc => isTr
      ? 'Sistem düzeyinde WebKit ve DNS filtrelemesi için lütfen izin verin.'
      : 'Please grant permission for system-level WebKit & DNS filtering.';
  String get blockerPermissionBtn => isTr ? 'İzin Ver' : 'Grant Permission';
  String get blockerHowItWorksTitle => isTr ? 'Nora Kalkanı Nasıl Çalışır?' : 'How Nora Shield Works';
  String get blockerHowItWorksBody => isTr
      ? 'Nora, Apple Content Blocker ve yerel filtreleme kurallarını kullanarak kumar sitelerini sistem düzeyinde engeller. Tüm engellemeler doğrudan cihazınızda gerçekleşir, internet trafiğiniz hiçbir harici sunucuya iletilmez.'
      : 'Nora blocks gambling websites at the system level using Apple Content Blocker and local filtering rules. All blocking occurs directly on your device, and your traffic is never routed to external servers.';
  String get understood => isTr ? 'Anladım' : 'Got it';

  // --- SOS / URGE SURFING SCREEN ---
  String get sosHeaderTitle => isTr ? 'Kriz & SOS Modu' : 'Crisis & SOS Mode';
  String get sosHeaderSub => isTr ? 'Dürtü Kontrolü & Zihin Desteği' : 'Urge Control & Mind Support';
  String get sosCallQuick => isTr ? '115 Ara' : 'Helpline';
  String get sosEmergencyTitle => isTr ? 'Oynama İsteği mi Geldi?' : 'Craving to Gamble?';
  String get sosEmergencySubtitle => isTr
      ? 'Sakin ol. Kumar dürtüsü bir dalga gibidir; zirve yapar ve 10-15 dakikada söner. Şimdi nefesine odaklan.'
      : 'Stay calm. Gambling cravings are like a wave; they peak and subside within 10-15 minutes. Focus on your breath.';
  String get toolBreathing => isTr ? '4-7-8 Nefes' : '4-7-8 Breath';
  String get toolUrgeSurfing => isTr ? 'Dalga Sörfü (15 Dk)' : 'Urge Surfing (15m)';
  String get toolGrounding => isTr ? 'Gerçeklik Çapası' : 'Reality Anchor';
  String get breathInhale => isTr ? 'Nefes Al' : 'Inhale';
  String get breathInhaleDesc => isTr
      ? 'Diyaframını doldurarak 4 saniye burnundan derin nefes al'
      : 'Inhale deeply through your nose for 4 seconds';
  String get breathHold => isTr ? 'Nefesini Tut' : 'Hold Breath';
  String get breathHoldDesc => isTr
      ? 'Nefesini 7 saniye boyunca zihnini sakinleştirerek tut'
      : 'Hold your breath for 7 seconds to calm your mind';
  String get breathExhale => isTr ? 'Yavaşça Ver' : 'Exhale';
  String get breathExhaleDesc => isTr
      ? 'Ağzından tüm gerginliği bırakarak 8 saniyede ver'
      : 'Exhale completely through your mouth for 8 seconds';
  String get breathReady => isTr ? 'Hazır Ol' : 'Get Ready';
  String get breathReadyDesc => isTr
      ? 'Zihnini yatıştırmak için egzersizi başlat'
      : 'Start exercise to soothe your nervous system';
  String get breathStart => isTr ? 'Nefes Egzersizini Başlat' : 'Start Breathing Exercise';
  String get breathStop => isTr ? 'Egzersizi Durdur' : 'Stop Exercise';
  String get breathPillInhale => isTr ? '1. Al (4s)' : '1. Inhale (4s)';
  String get breathPillHold => isTr ? '2. Tut (7s)' : '2. Hold (7s)';
  String get breathPillExhale => isTr ? '3. Ver (8s)' : '3. Exhale (8s)';
  String get breathScience => isTr
      ? '4-7-8 tekniği kalp atış hızını dengeler ve amigdala (dürtü) aktivitesini düşürür.'
      : 'The 4-7-8 technique stabilizes heart rate and reduces amygdala urge activation.';

  String get urgeSurfingTitle => isTr ? '15 Dakikalık İstek Erteleme Sayacı' : '15-Minute Urge Delay Timer';
  String get urgeSurfingSub => isTr
      ? 'Kumar dürtüsü biyolojik olarak 15 dakikadan uzun süre zirvede kalamaz.'
      : 'Gambling urges biologically cannot stay at peak for more than 15 minutes.';
  String get startTimer => isTr ? 'Sayacı Başlat' : 'Start Timer';
  String get pauseTimer => isTr ? 'Duraklat' : 'Pause';
  String get resetTimer => isTr ? 'Sıfırla' : 'Reset';
  String urgePercentCompleted(int pct) => isTr ? '%$pct Tamamlandı' : '$pct% Completed';
  String get urgeStage1Title => isTr ? '1. Aşama: Yükseliş' : 'Stage 1: The Rise';
  String get urgeStage1Desc => isTr
      ? 'Dürtü şu an zirveye doğru tırmanıyor. Bir şey yapma, sadece bekle.'
      : 'The craving is climbing toward its peak. Do nothing, just wait.';
  String get urgeStage2Title => isTr ? '2. Aşama: Zirve Dalga' : 'Stage 2: Peak Wave';
  String get urgeStage2Desc => isTr
      ? 'En yoğun kritik an. Bu eşiği geçersen istek hızla kırılacak.'
      : 'The most intense critical moment. Pass this threshold and craving breaks quickly.';
  String get urgeStage3Title => isTr ? '3. Aşama: Sönümlenme' : 'Stage 3: Subsiding';
  String get urgeStage3Desc => isTr
      ? 'Harikasın! Dalga çekiliyor, kontrol tamamen senin elinde.'
      : 'Great job! The wave is subsiding, you are in full control.';

  String get realityAnchorTitle => isTr ? 'Finansal Gerçeklik Çapası' : 'Financial Reality Anchor';
  String get realityAnchorSub => isTr
      ? 'Kumarın oluşturduğu sahte hayallere karşı somut gerçeklerine tutun.'
      : 'Hold on to concrete reality against the illusions created by gambling.';
  String get anchorSavedMoney => isTr ? 'KORUNAN PARA' : 'SAVED MONEY';
  String get anchorDaysClean => isTr ? 'TEMİZ GEÇEN' : 'CLEAN STREAK';
  String cleanDaysCount(int d) => isTr ? '$d Gün' : '$d Days';
  String get anchorStartingPromise => isTr ? 'BAŞLARKEN VERDİĞİN SÖZ:' : 'THE PROMISE YOU MADE AT START:';
  String get groundingChecklistTitle => isTr ? 'Hızlı Zihin Topraklama (5-4-3-2-1):' : 'Quick Mind Grounding (5-4-3-2-1):';
  String get grounding5 => isTr ? 'Gözünle görebildiğin 5 farklı nesneyi fark et' : 'Notice 5 things you can see around you';
  String get grounding4 => isTr ? 'Fiziksel olarak dokunabildiğin 4 yüzeyi hisset' : 'Feel 4 physical surfaces around you';
  String get grounding3 => isTr ? 'Etrafındaki 3 farklı sese kulak ver' : 'Listen carefully to 3 distinct sounds';
  String get grounding2 => isTr ? 'Ortamdaki 2 kokuyu fark etmeye çalış' : 'Try to notice 2 scents in your environment';
  String get grounding1 => isTr ? 'Derin bir nefes al: "Şu an güvendeyim ve kontrol bende"' : 'Take a deep breath: "I am safe and in control"';

  String get urgeVictoryTitle => isTr ? 'KRİZİ AŞTINIZ!' : 'CRISIS OVERCOME!';
  String get urgeVictoryBody => isTr
      ? 'Tebrikler! 15 dakikalık en kritik dürtü dalgasını tek bir bahis yapmadan başarıyla atlattınız.'
      : 'Congratulations! You successfully rode out the 15-minute critical urge wave without placing a bet.';
  String get urgeVictoryShield => isTr
      ? 'İradeniz hem zihninizi hem de paranızı korudu.'
      : 'Your willpower protected both your mind and your money.';
  String get urgeVictoryButton => isTr ? 'Harika, Devam Et' : 'Great, Keep Going';

  String get hotlineBannerTitle => isTr ? 'YEDAM Danışma Hattı' : 'Addiction Support Hotline';
  String get hotline247 => isTr ? '7/24 Ücretsiz' : '24/7 Free';
  String get hotlineBannerDesc => isTr
      ? 'Kendini yalnız hissettiğinde Yeşilay uzman klinik psikologları tek bir arama uzaklığında.'
      : 'When feeling overwhelmed, professional addiction counseling psychologists are just a phone call away.';
  String get hotlineBannerBtn => isTr ? '115 YEDAM Hattını Ara (Ücretsiz)' : 'Call Support Helpline (Free)';

  String get callModalTitle => isTr ? 'YEDAM Ücretsiz Destek Hattı' : 'Free Addiction Support Line';
  String get callModalDesc => isTr
      ? 'Yeşilay Danışmanlık Merkezi (115), kumar bağımlılığı yaşayan bireyler ve yakınlarına 7/24 tamamen ücretsiz, anonim ve profesyonel klinik psikolog desteği sunar.'
      : 'The Addiction Counseling Center provides 24/7 completely free, anonymous, and professional clinical psychologist support.';
  String get callModalFeat1 => isTr ? 'Tamamen Gizli ve Anonim' : '100% Confidential & Anonymous';
  String get callModalFeat2 => isTr ? '7 Gün 24 Saat Kesintisiz' : 'Available 24 Hours, 7 Days a Week';
  String get callModalFeat3 => isTr ? 'Devlet Güvencesinde ve Ücretsiz' : 'Official Support & Free of Charge';
  String get callModalBtn => isTr ? '115\'i Şimdi Ara (Ücretsiz)' : 'Call Helpline Now (Free)';
  String get callError => isTr
      ? 'Arama başlatılamadı. Lütfen 115 numaralı YEDAM hattını telefonunuzdan doğrudan arayın.'
      : 'Could not initiate call. Please dial the helpline directly from your phone.';

  // --- JOURNAL SCREEN ---
  String get journalScreenTitle => isTr ? 'Duygu & İrade Günlüğü' : 'Mood & Willpower Journal';
  String get journalScreenSub => isTr
      ? 'Zihinsel Farkındalık ve Kriz Takibi'
      : 'Mindfulness & Urge Tracking';
  String get journalClose => isTr ? 'Kapat' : 'Close';
  String get journalAddEntry => isTr ? 'Giriş Ekle' : 'Add Entry';
  String get journalInsightTitle => isTr ? 'İçgörü & Farkındalık' : 'Insights & Awareness';
  String get journalResistGreat => isTr ? 'Mükemmel Direnç' : 'Great Resilience';
  String get journalResistBalanced => isTr ? 'Dengeli & Güvende' : 'Balanced & Safe';
  String get journalResistCareful => isTr ? 'Dikkatli Olunmalı' : 'Caution Needed';
  String get journalInsightEmpty => isTr
      ? 'Duygularını ve kriz anlarını günlük olarak not etmek, beynin dürtü kontrol merkezini güçlendirir.'
      : 'Logging your feelings and urge moments daily strengthens your brain\'s impulse control.';
  String journalInsightCount(int c) => isTr
      ? 'Toplam $c günlük kaydınız ile duygu dalgalanmalarınızı ve tetikleyicilerinizi bilinçli kontrol ediyorsunuz.'
      : 'With $c journal entries, you mindfully navigate mood swings and triggers.';
  String get journalTotalCheckin => isTr ? 'TOPLAM CHECK-IN' : 'TOTAL CHECK-INS';
  String journalCheckinCount(int c) => isTr ? '$c Giriş' : '$c Entries';
  String get journalAvgCravingTitle => isTr ? 'ORT. İSTEK ŞİDDETİ' : 'AVG CRAVING LEVEL';

  String get journalFormCollapsedTitle => isTr ? 'Bugünkü İrade Check-in\'ini Yap' : 'Log Today\'s Check-In';
  String get journalFormCollapsedSub => isTr
      ? 'Ruh halini, istek seviyeni ve notunu kaydet'
      : 'Record your mood, urge level, and personal reflection';
  String get journalFormExpandedTitle => isTr ? 'Bugünkü İrade Check-in\'i' : 'Today\'s Willpower Check-In';
  String get journalMoodStep => isTr ? '1. ŞU ANKİ RUH HALİN:' : '1. CURRENT MOOD:';
  String get journalCravingStep => isTr ? '2. KUMAR / BAHİS İSTEĞİ ŞİDDETİ:' : '2. GAMBLING CRAVING INTENSITY:';
  String get journalTriggersStep => isTr ? '3. TETİKLEYİCİLER (VARSA):' : '3. TRIGGERS (IF ANY):';
  String get journalNotesStep => isTr ? '4. DÜŞÜNCELER & MİNNET NOTLARI:' : '4. THOUGHTS & GRATITUDE NOTES:';
  String get journalNoteHint => isTr
      ? 'Bugün beni ne tetikledi? Neler başardım? İrademi ne korudu?...'
      : 'What triggered me today? What did I achieve? What protected my willpower?...';
  String get journalSaveBtn => isTr ? 'Günlüğü Kaydet' : 'Save Journal Entry';
  String get journalSavedSuccess => isTr
      ? 'Günlük kaydınız başarıyla kaydedildi! 💪'
      : 'Journal entry saved successfully! 💪';
  String get journalPastEntries => isTr ? 'Geçmiş Günlük Kayıtları' : 'Past Journal Entries';
  String journalLogsCount(int c) => isTr ? '$c Kayıt' : '$c Logs';

  String get journalEmptyTitle => isTr ? 'Henüz Günlük Kaydınız Yok' : 'No Journal Entries Yet';
  String get journalEmptyDesc => isTr
      ? 'Günde sadece 1 dakikanızı ayırıp duygularınızı ve kumar istek seviyenizi not etmek, kriz anlarında iradenizi %60 güçlendirir.'
      : 'Taking just 1 minute a day to note your feelings and craving levels strengthens willpower by 60% during crisis.';
  String get journalEmptyBtn => isTr ? 'İlk Günlük Girişini Yap' : 'Log First Journal Entry';

  String get cravingLevel1 => isTr ? 'Sıfır İstek' : 'No Craving';
  String get cravingLevel2 => isTr ? 'Hafif Dürtü' : 'Mild Urge';
  String get cravingLevel3 => isTr ? 'Orta Şiddet' : 'Moderate';
  String get cravingLevel4 => isTr ? 'Güçlü İstek' : 'Strong Urge';
  String get cravingLevel5 => isTr ? 'Şiddetli Kriz' : 'Severe Urge';
  String journalCravingBadge(int lvl, String label) => isTr ? 'İstek: $lvl/5 ($label)' : 'Craving: $lvl/5 ($label)';
  String journalMoodBadge(String mood) => isTr ? 'Ruh Hali: $mood' : 'Mood: $mood';

  String get moodGreat => isTr ? 'Harika' : 'Great';
  String get moodCalm => isTr ? 'Sakin' : 'Calm';
  String get moodStressed => isTr ? 'Stresli' : 'Stressed';
  String get moodAnxious => isTr ? 'Endişeli' : 'Anxious';
  String get moodStruggling => isTr ? 'Zorlanıyor' : 'Struggling';

  String get triggerStress => isTr ? 'Stres' : 'Stress';
  String get triggerDebt => isTr ? 'Finansal Borç' : 'Financial Debt';
  String get triggerSocialMedia => isTr ? 'Sosyal Medya Reklamı' : 'Social Media Ad';
  String get triggerLoneliness => isTr ? 'Gece Yalnızlık' : 'Late Night Solitude';
  String get triggerAlcoholMood => isTr ? 'Alkollü Ortam' : 'Alcohol Environment';

  // --- PROFILE & SETTINGS ---
  String get profileHeaderTitle => isTr ? 'Profil & Ayarlar' : 'Profile & Settings';
  String get profileWarrior => isTr ? 'İrade Savaşçısı' : 'Willpower Warrior';
  String get profileActiveStreak => isTr ? 'Aktif Mücadele' : 'Active Recovery';
  String get profileDefaultMotivation => isTr
      ? '“Özgür ve kumarsız bir gelecek için.”'
      : '“For a free and gambling-free future.”';
  String get profileDaysCleanPill => isTr ? 'Temiz Geçen' : 'Clean Streak';
  String get profileProtectedPill => isTr ? 'Korumada' : 'Protected';

  String get profileVipTitle => isTr ? 'Nora VIP Üyelik' : 'Nora VIP Membership';
  String get profilePlanAnnual => isTr ? 'Yıllık Koruma Paketi' : 'Annual Protection Package';
  String get profilePlanMonthly => isTr ? 'Aylık Koruma Paketi' : 'Monthly Protection Package';
  String profileTrialBadge(int d) => isTr
      ? (d > 0 ? '$d GÜN DENEME' : 'DENEME')
      : (d > 0 ? '$d-DAY TRIAL' : 'TRIAL');
  String get profileActiveBadge => isTr ? 'AKTİF' : 'ACTIVE';
  String get profileManageBtn => isTr ? 'Yönet' : 'Manage';
  String profileTrialStatus(int d, String plan) => isTr
      ? (d > 0 ? '$d gün ücretsiz deneme kaldı • Ardından $plan' : 'Ücretsiz deneme aktif • Ardından $plan')
      : (d > 0 ? '$d days free trial remaining • Then $plan' : 'Free trial active • Then $plan');
  String profileActiveStatus(String plan) => isTr
      ? '$plan • Kesintisiz Kalkan'
      : '$plan • Uninterrupted Shield';

  String get vipDetailsSheetTitle => isTr ? 'Nora VIP Üyelik Detayları' : 'Nora VIP Membership Details';
  String get vipDetailsSheetSubtitle => isTr
      ? 'VIP korumanız aktif. Nora kalkanı tüm kumar ve bahis platformlarını 7/24 engelliyor.'
      : 'Your VIP protection is active. Nora shield is blocking all gambling platforms 24/7.';
  String get vipDetailsStatusActive => isTr ? 'VIP Koruma Aktif' : 'VIP Protection Active';
  String get vipDetailsStatusTrial => isTr ? '7 Gün Ücretsiz Deneme' : '7-Day Free Trial';
  String get vipDetailsManageStore => isTr ? 'Aboneliği Mağazada Yönet' : 'Manage Subscription in Store';
  String get vipDetailsRestorePurchases => isTr ? 'Satın Alımları Geri Yükle' : 'Restore Purchases';
  String get vipDetailsRestoredSuccess => isTr ? 'Satın alımlarınız başarıyla güncellendi.' : 'Your purchases were successfully updated.';
  String get vipDetailsFeature1 => isTr ? '7/24 Kesintisiz Bulut Kumar Filtresi' : '24/7 Uninterrupted Cloud Gambling Filter';
  String get vipDetailsFeature2 => isTr ? 'Dinamik Ayna & Kaçak Site Taraması' : 'Dynamic Mirror & Illegal Site Scraper';
  String get vipDetailsFeature3 => isTr ? 'Sınırsız Mobil Uygulama Kalkanı' : 'Unlimited App Shielding';
  String get vipDetailsFeature4 => isTr ? 'Anti-Bypass VPN & Proxy Kilit Protokolü' : 'Anti-Bypass VPN & Proxy Lock Protocol';
  String get vipDetailsFeature5 => isTr ? 'Şifreli Kriz Günlüğü & İrade Takibi' : 'Encrypted Journal & Urge Surfing';
  String get vipDetailsFeature6 => isTr ? 'Kumarsız Zaman & Tasarruf Analizi' : 'Gambling-Free Time & Savings Analytics';
  String get vipDetailsSecStatusTitle => isTr ? 'SİSTEM & GÜVENLİK DURUMU' : 'SYSTEM & SECURITY STATUS';

  String get profileSecProtection => isTr ? 'KORUMA & GÜVENLİK DÜZEYİ' : 'PROTECTION & SECURITY LEVEL';
  String get profileSecJourney => isTr ? 'YOLCULUK & SAYAÇ YÖNETİMİ' : 'JOURNEY & STREAK MANAGEMENT';
  String get profileSecPrivileges => isTr ? 'NORA AYRICALIKLARI' : 'NORA PRIVILEGES';
  String get profileSecDanger => isTr ? 'TEHLİKELİ BÖLGE' : 'DANGER ZONE';

  String get profileTileScreenTime => isTr ? 'iOS Ekran Süresi İzni' : 'iOS Screen Time Permission';
  String get profileScreenTimeApproved => isTr
      ? 'Sistem engelleme filtresi devrede ve onaylı'
      : 'System blocking filter active and authorized';
  String get profileScreenTimePending => isTr
      ? 'Safari & Chrome engellemesi için izin verin'
      : 'Grant permission for Safari & Chrome blocking';
  String get profileStatusEnabled => isTr ? 'Etkin' : 'Enabled';
  String get profileStatusGrant => isTr ? 'İzin Ver' : 'Grant';

  String get profileTileVpn => isTr ? 'VPN & Bypass Kalkanı' : 'VPN & Anti-Bypass Shield';
  String get profileVpnActive => isTr ? 'VPN tespiti: Kalkan devrede' : 'VPN detection: Shield active';
  String get profileVpnIdle => isTr ? 'Sistem proxy ve VPN sızıntı koruması' : 'System proxy & VPN leak protection';
  String get profileStatusActive => isTr ? 'Aktif' : 'Active';

  String get profileTileResetStreak => isTr ? 'Temizlik Tarihini Yenile' : 'Reset Clean Streak';
  String get profileTileResetStreakSub => isTr
      ? 'Bir kayma yaşandıysa pes etme, sayacı sıfırla'
      : 'If a slip occurred, don\'t give up, restart streak';
  String get profileResetStreakDialogTitle => isTr ? 'Temiz Sayfayı Aç' : 'Start a Clean Slate';
  String get profileResetStreakDialogBody => isTr
      ? 'Bir kayma yaşamak pes ettiğin anlamına gelmez. İyileşme doğrusal bir yol değildir.\n\nSayacı bugünden başlatıp hedefine odaklanmak istiyor musun?'
      : 'Experiencing a slip does not mean you have failed. Recovery is not linear.\n\nDo you want to reset your counter from today and refocus?';
  String get profileDialogCancel => isTr ? 'Vazgeç' : 'Cancel';
  String get profileResetStreakConfirm => isTr ? 'Yeniden Başla' : 'Restart Now';
  String get profileResetStreakSnack => isTr
      ? 'Sayacınız bugünden itibaren başlatıldı. Güçlü kalın! 💪'
      : 'Your streak counter has been restarted from today. Stay strong! 💪';

  String get profileTileTheme => isTr ? 'Uygulama Teması' : 'App Theme';
  String get profileThemeSheetTitle => isTr ? 'Uygulama Teması' : 'App Theme';
  String get profileThemeSheetSub => isTr
      ? 'Karanlık veya aydınlık görünüm tercihini seçin'
      : 'Choose your preferred appearance';
  String get profileThemeAutoTitle => isTr ? 'Otomatik (Sistem)' : 'Auto (System)';
  String get profileThemeAutoSub => isTr
      ? 'Telefonunuzun sistem ayarlarını takip eder'
      : 'Follows device system settings';
  String get profileThemeLightTitle => isTr ? 'Açık Mod (Beyaz)' : 'Light Mode (White)';
  String get profileThemeLightSub => isTr
      ? 'Ferah beyaz sayfalar ve yüksek kontrast'
      : 'Bright pages and high contrast';
  String get profileThemeDarkTitle => isTr ? 'Koyu Mod (Siyah)' : 'Dark Mode (OLED)';
  String get profileThemeDarkSub => isTr
      ? 'Derin OLED siyah zemin ve gece koruması'
      : 'Deep OLED black background and night comfort';
  String get profileThemePillAuto => isTr ? 'Otomatik' : 'Auto';
  String get profileThemePillLight => isTr ? 'Açık' : 'Light';
  String get profileThemePillDark => isTr ? 'Koyu' : 'Dark';

  String get profileTilePaywall => isTr ? 'Abonelik & Paketleri İncele' : 'Review Subscription & Plans';
  String get profileTilePaywallSub => isTr
      ? 'Ayrıcalıklı koruma ve premium seçenekleri'
      : 'Premium protection features & options';
  String get profileTilePrivacy => isTr ? 'Gizlilik ve Yerel Koruma' : 'Privacy & Local Protection';
  String get profileTilePrivacySub => isTr
      ? 'Tüm filtrelemeler sunucusuz cihazınızda çalışır'
      : 'All filtering runs directly on your device';
  String get profilePillLocal => isTr ? '100% Yerel' : '100% Local';

  String get profileTileResetApp => isTr ? 'Tüm Uygulama Verilerini Sıfırla' : 'Reset All App Data';
  String get profileTileResetAppSub => isTr
      ? 'Anketi ve tüm yerel kayıtları baştan kurar'
      : 'Resets onboarding survey and all local records';
  String get profileResetAppDialogTitle => isTr ? 'Tüm Verileri Sıfırla?' : 'Reset All Data?';
  String get profileResetAppDialogBody => isTr
      ? 'Bu işlem anket yanıtlarınızı, engelleme listelerini, Ekran Süresi izinlerini ve tüm yerel kayıtlarınızı sıfırlar. Geri alınamaz.\n\nYapılmış satın almalar Apple hesabınızda tutulur — aboneliğinizi App Store hesabınızdan yönetebilirsiniz.'
      : 'This resets survey answers, blocklists, Screen Time permissions, and all local records. Cannot be undone.\n\nPurchases remain linked to your Apple ID — manage subscriptions via App Store.';
  String get profileResetAppConfirm => isTr ? 'Kalıcı Olarak Sil' : 'Permanently Delete';

  String get profileFooterTech => isTr ? 'Nora Koruma Teknolojisi v1.0.0' : 'Nora Protection Technology v1.0.0';
  String get profileFooterPrivacy => isTr ? '100% Cihaz İçi Gizlilik • Sıfır Veri Takibi' : '100% On-Device Privacy • Zero Data Tracking';

  // --- LANGUAGE SETTINGS ---
  String get languageTitle => isTr ? 'Uygulama Dili' : 'App Language';
  String get languageSystem => isTr ? 'Sistem Dili (Otomatik)' : 'System Language (Auto)';
  String get languageTr => 'Türkçe';
  String get languageEn => 'English';
}

extension AppStringsExtension on BuildContext {
  AppStrings get l10n => AppStrings.of(this);
}
