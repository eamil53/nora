// ==========================================================================
// NORA OFFICIAL WEB - MAIN APPLICATION LOGIC & LOCALIZATION
// ==========================================================================

const translations = {
  tr: {
    // Nav
    navFeatures: "Özellikler",
    navCalculator: "Tasarruf Hesaplayıcı",
    navSOS: "Dürtü Sörfü",
    navFAQ: "SSS",
    navSupport: "Destek",
    navPrivacy: "Gizlilik",
    navEULA: "EULA",
    navDownload: "Kalkanı Başlat",

    // Hero
    heroBadge: "🛡️ %100 Gizli & Tavizsiz Kalkan",
    heroTitle: "Kumarı Arkanda Bırak, Geleceğini ve Paranı Geri Kazan.",
    heroSubtitle: "Nora; zayıf anlarında devreye giren, 50.000+ yasadışı bahis ve casino sitesini sistem düzeyinde engelleyen, acil SOS protokolüyle dürtülerini yatıştıran 1 numaralı kalkanındır.",
    heroBadgeStore: "iOS & Android için Hazır",
    statCleanStreak: "%94",
    statCleanStreakDesc: "İlk 30 Gün Temiz Kalma",
    statBlockedSites: "50.000+",
    statBlockedSitesDesc: "Engellenen Bahis & Casino",
    statSavedMoney: "10M+ ₺",
    statSavedMoneyDesc: "Kullanıcıların Kurtardığı Para",
    deckThreatTag: "BLOKE EDİLDİ",

    // Features Section
    featuresTag: "SAVUNMA SİSTEMİ",
    featuresTitle: "Nora Seni Kumar Döngüsünden Nasıl Korur?",
    featuresSubtitle: "Sadece iradeye güvenmek yetmez. Nora, nörobilim ve katı engelleme teknolojisiyle zayıf anlarında sarsılmaz bir koruma duvarı örer.",
    
    feat1Title: "Katı Kalkan (DNS & Sistem Engeli)",
    feat1Desc: "50.000'den fazla yasadışı bahis, slot, rulet, sanal kumar ve kripto kaldıraç alan adını anında bloke eder. Parola koruması sayesinde anlık krizlerde kapatılamaz.",
    feat1Pill1: "Bypass Edilemez",
    feat1Pill2: "PIN Kilidi",
    feat1Pill3: "Sıfır İhlal",

    feat2Title: "15 Dakika SOS & Dürtü Sörfü",
    feat2Desc: "Kumar oynama arzusu bir okyanus dalgası gibidir; 10-15 dakika içinde zirve yapar ve söner. Özel yönlendirmeli nefes ve panik protokolüyle dalgayı krizsiz atlatırsın.",
    feat2Pill1: "Nörobilim Tabanlı",
    feat2Pill2: "Rehberli Nefes",
    feat2Pill3: "Panik Butonu",

    feat3Title: "Tasarruf Kasası & Finansal Özgürlük",
    feat3Desc: "Kumara harcamadığın her kuruş gerçek zamanlı olarak kasanızda birikir. Geri kazandığın parayla neleri satın alabileceğini ve geleceğini somut olarak görürsün.",
    feat3Pill1: "Anlık Sayaç",
    feat3Pill2: "Amorti Analizi",
    feat3Pill3: "Hedef Takibi",

    feat4Title: "Tetikleyici Analizi & Günlük",
    feat4Desc: "Seni kumara iten asıl neden neydi? Stres, borç paniği, yalnızlık veya can sıkıntısı? Duygularını kaydet, davranışsal kalıplarını çöz ve nüksleri önceden engelle.",
    feat4Pill1: "Bilişsel Terapi (CBT)",
    feat4Pill2: "Duygu Haritası",
    feat4Pill3: "Nüks Önleme",

    feat5Title: "%100 Gizlilik & Sıfır Veri İhlali",
    feat5Desc: "Mücadelen tamamen sana özeldir. Verilerin cihazında yerel olarak saklanır; kimliğin, finansal bilgilerin asla üçüncü şahıslara veya reklam ağlarına satılmaz.",
    feat5Pill1: "Yerel Şifreleme",
    feat5Pill2: "Anonim Profil",
    feat5Pill3: "KVKK/GDPR Uyumlu",

    feat6Title: "Sertifika & Başarı Rozetleri",
    feat6Desc: "1. Gün, 1. Hafta, 1. Ay, 1. Yıl... Temiz kaldığın her dönüm noktası için özel olarak tasarlanmış başarı rozetleri ve özgüvenini tazeleyen tebrik kalkanları kazan.",
    feat6Pill1: "Dönüm Noktaları",
    feat6Pill2: "Motivasyon Arşivi",
    feat6Pill3: "Topluluk Gücü",

    // Calculator Section
    calcTag: "FİNANSAL GERÇEKLER",
    calcTitle: "Kumara Gitmeyen Paranın Gücünü Hesapla",
    calcSubtitle: "Aylık ortalama kumar harcamanı kaydırarak Nora ile hayatında nelerin değişeceğini anında keşfet.",
    calcMonthlyLabel: "Aylık Ortalama Kumar Kaybı:",
    calcResLead: "1 YILDA CEBİNDE KALACAK MİKTAR",
    calcResSub: "Kumar sitelerine kaptırmadığın net birikimin.",
    calcMetricMonth: "1 Aylık Kurtarma:",
    calcMetric5Year: "5 Yıllık Kurtarma:",
    calcComparisonText: "💡 Bu parayla: ",

    // Breathing Trainer Section
    breathTag: "İNTERAKTİF DENEYİM",
    breathTitle: "Dürtü Sörfü (Urge Surfing) Simülatörü",
    breathSubtitle: "Kumar isteği geldiğinde beynin dopamin krizi yaşar. Bu nefes döngüsünü takip ederek 60 saniyede kalp ritmini ve dürtü yoğunluğunu düşür.",
    breathStartBtn: "Nefes Seansını Başlat",
    breathStopBtn: "Durdur",
    breathInhale: "Derin Nefes Al...",
    breathHold: "Nefesini Tut...",
    breathExhale: "Yavaşça Bırak...",
    breathReady: "Hazır olduğunda başla",

    // FAQ Section
    faqTag: "ŞEFFAFLIK & DETAYLAR",
    faqTitle: "Sıkça Sorulan Sorular",
    faqSubtitle: "Nora kalkanı hakkında merak ettiğin her şey.",
    faqQ1: "Nora kumar sitelerini nasıl engelliyor?",
    faqA1: "Nora; cihaz düzeyinde güvenli ve yerel DNS/filtreleme protokolü uygular. Bu kalkan; bilinen yasadışı bahis, canlı casino, slot oyunları ve kumar odaklı kripto platformlarına ait 50.000'den fazla alan adına erişimi anında keser.",
    faqQ2: "Kriz anında kalkanı kolayca kapatabilir miyim?",
    faqA2: "Hayır. Nora özellikle anlık irade zayıflıklarında devreye giren caydırıcı koruma önlemleri içerir. Kalkanı devre dışı bırakmak için güvenlik PIN'i, soğuma süresi ve acil SOS onay adımları zorunludur.",
    faqQ3: "Kişisel ve finansal verilerim güvende mi?",
    faqA3: "Kesinlikle. Nora gizlilik odaklı tasarlanmıştır. Tasarruf sayacınız, temizlik günleriniz ve günlük kayıtlarınız cihazınızda saklanır. Verileriniz hiçbir reklam verenle veya üçüncü tarafla paylaşılmaz.",
    faqQ4: "Nora bir tıbbi veya psikiyatrik tedavi midir?",
    faqA4: "Hayır. Nora, kullanıcıların irade güçlendirmesine ve dürtü yönetimini öğrenmesine destek olan davranışsal bir kalkan ve alışkanlık takip aracıdır. Klinik bir tedavi yerine geçmez. Ciddi krizlerde uzman desteği veya Yeşilay YEDAM (115) hattına başvurulmalıdır.",
    faqQ5: "Aboneliğimi nasıl iptal edebilir veya iade alabilirim?",
    faqA5: "Abonelikler Apple App Store veya Google Play hesabınız üzerinden doğrudan ve tek tıkla yönetilir. İptal işlemini dilediğiniz an mağaza ayarlarınızdan gerçekleştirebilirsiniz.",

    // Footer
    footerDesc: "Nora, kumar bağımlılığını geride bırakmak, cebindeki parayı korumak ve huzurlu bir hayata adım atmak isteyen herkes için geliştirilmiş tavizsiz koruma kalkanıdır.",
    footerColProduct: "Ürün",
    footerColLegal: "Hukuki & Şartlar",
    footerColSupport: "Yardım & Acil",
    footerRights: "© 2026 Nora App. Tüm hakları saklıdır.",
    footerMedicalNote: "Yasal Uyarı: Nora bir davranışsal ve teknolojik kalkan aracıdır; klinik tıbbi teşhis veya psikiyatri tedavi hizmeti yerine geçmez."
  },

  en: {
    // Nav
    navFeatures: "Features",
    navCalculator: "Savings Vault",
    navSOS: "Urge Surfing",
    navFAQ: "FAQ",
    navSupport: "Support",
    navPrivacy: "Privacy Policy",
    navEULA: "EULA",
    navDownload: "Get Shield",

    // Hero
    heroBadge: "🛡️ 100% Private & Uncompromising Shield",
    heroTitle: "Leave Gambling Behind. Reclaim Your Money & Peace.",
    heroSubtitle: "Nora is your #1 strict shield that intervenes during weak urges, blocks 50,000+ betting and casino domains at the system level, and guides you through evidence-based SOS protocols.",
    heroBadgeStore: "Available for iOS & Android",
    statCleanStreak: "94%",
    statCleanStreakDesc: "First 30 Days Clean Rate",
    statBlockedSites: "50,000+",
    statBlockedSitesDesc: "Blocked Gambling Domains",
    statSavedMoney: "$350K+",
    statSavedMoneyDesc: "Total Funds Protected",
    deckThreatTag: "BLOCKED",

    // Features Section
    featuresTag: "DEFENSE ARCHITECTURE",
    featuresTitle: "How Nora Protects You From Relapse",
    featuresSubtitle: "Relying on willpower alone fails under intense craving. Nora combines behavioral neuroscience with unyielding digital barriers.",

    feat1Title: "Strict Blocker (System-Level Shield)",
    feat1Desc: "Instantly blocks 50,000+ illegal bookmakers, slots, roulette, online casinos, and leveraged gambling platforms. Secured with PIN protection against impulsive deactivations.",
    feat1Pill1: "Unbypassable",
    feat1Pill2: "PIN Lock",
    feat1Pill3: "Zero Leak",

    feat2Title: "15-Minute SOS & Urge Surfing",
    feat2Desc: "A craving is like an ocean wave: it peaks within 10-15 minutes and subsides. Nora's guided breathing and grounding techniques let you ride the wave safely.",
    feat2Pill1: "Neuroscience-Based",
    feat2Pill2: "Paced Breathing",
    feat2Pill3: "Panic Protocol",

    feat3Title: "Savings Vault & Clean Streak",
    feat3Desc: "Every single dollar not lost to gambling accumulates in your personal vault in real time. Experience tangible milestones of the life and assets you are building.",
    feat3Pill1: "Live Counter",
    feat3Pill2: "ROI Multiplier",
    feat3Pill3: "Milestones",

    feat4Title: "Trigger Journal & Mind Tracker",
    feat4Desc: "Understand what triggered the urge: stress, debts, loneliness, or boredom. Map your emotional patterns and neutralize relapse risk before it manifests.",
    feat4Pill1: "CBT Methods",
    feat4Pill2: "Emotional Map",
    feat4Pill3: "Relapse Prevention",

    feat5Title: "100% Privacy & Zero Data Selling",
    feat5Desc: "Your journey is confidential. All streak metrics and journals remain encrypted on your device. We never sell data to advertising networks or brokers.",
    feat5Pill1: "Local Encryption",
    feat5Pill2: "Anonymous User",
    feat5Pill3: "GDPR Compliant",

    feat6Title: "Milestone Badges & Shields",
    feat6Desc: "Day 1, 1 Week, 1 Month, 1 Year... Earn beautifully crafted digital medals and celebration shields that solidify your new, self-governing identity.",
    feat6Pill1: "Clean Milestones",
    feat6Pill2: "Dopamine Reset",
    feat6Pill3: "Peer Strength",

    // Calculator Section
    calcTag: "FINANCIAL REALITY",
    calcTitle: "Calculate the Money You Keep in Your Pocket",
    calcSubtitle: "Slide your average monthly gambling budget to reveal the wealth you safeguard with Nora.",
    calcMonthlyLabel: "Average Monthly Gambling Loss:",
    calcResLead: "SAVED IN 1 YEAR",
    calcResSub: "Pure wealth returned directly to your pocket.",
    calcMetricMonth: "1 Month Saved:",
    calcMetric5Year: "5 Years Saved:",
    calcComparisonText: "💡 With this money: ",

    // Breathing Trainer Section
    breathTag: "INTERACTIVE EXPERIENCE",
    breathTitle: "Urge Surfing Breathing Simulator",
    breathSubtitle: "When gambling cravings strike, dopamine centers trigger panic. Follow this 4-4-4 rhythm for 60 seconds to soothe your nervous system.",
    breathStartBtn: "Start Breathing Session",
    breathStopBtn: "Stop",
    breathInhale: "Inhale Deeply...",
    breathHold: "Hold Breath...",
    breathExhale: "Exhale Slowly...",
    breathReady: "Press start when ready",

    // FAQ Section
    faqTag: "TRANSPARENCY",
    faqTitle: "Frequently Asked Questions",
    faqSubtitle: "Everything you need to know about Nora's protective shield.",
    faqQ1: "How does Nora block gambling websites?",
    faqA1: "Nora implements secure, system-level DNS and device management filters. It prevents outbound connections to over 50,000 known online casinos, sportsbook operators, slot engines, and crypto betting dApps.",
    faqQ2: "Can I easily disable the shield during a weak moment?",
    faqA2: "No. Nora is engineered with strict friction mechanics specifically designed to protect you from impulse relapses. Disabling the blocker requires cooling-off periods and safety PIN confirmation.",
    faqQ3: "Is my personal and financial information private?",
    faqA3: "Completely. Nora does not collect, broker, or sell any of your journal entries, savings milestones, or browsing patterns. Your data stays securely stored on your personal device.",
    faqQ4: "Is Nora a substitute for medical or psychiatric treatment?",
    faqA4: "No. Nora is an evidence-informed behavioral habit companion and digital blocking tool. It does not provide medical diagnosis or addiction healthcare. Users experiencing severe crises should reach out to licensed professionals or gambling hotlines.",
    faqQ5: "How do I cancel or request a refund for my subscription?",
    faqA5: "Subscriptions are managed directly through your Apple App Store or Google Play account. You can cancel at any time in your device settings prior to your renewal date.",

    // Footer
    footerDesc: "Nora is the unyielding digital shield built for anyone looking to break the gambling cycle, safeguard their wealth, and reclaim self-mastery.",
    footerColProduct: "Product",
    footerColLegal: "Legal & Terms",
    footerColSupport: "Help & Crisis",
    footerRights: "© 2026 Nora App. All rights reserved.",
    footerMedicalNote: "Disclaimer: Nora is a behavioral habit tool and content filter; it is not a substitute for clinical psychological or psychiatric therapy."
  }
};

let currentLang = 'tr';
let currentCurrency = 'TRY';
let monthlySpend = 15000;
let breathingInterval = null;
let breathingState = 'idle';

function setTxt(id, val) {
  const el = document.getElementById(id);
  if (el) el.textContent = val;
}

function formatCurrency(val, currency = currentCurrency) {
  if (currency === 'TRY') {
    return '₺' + Math.round(val).toLocaleString('tr-TR');
  } else {
    return '$' + Math.round(val).toLocaleString('en-US');
  }
}

function applyLanguage(lang) {
  currentLang = lang;
  document.documentElement.setAttribute('lang', lang);
  localStorage.setItem('nora-lang', lang);
  const t = translations[lang];

  setTxt('nav-features-link', t.navFeatures);
  setTxt('nav-calc-link', t.navCalculator);
  setTxt('nav-sos-link', t.navSOS);
  setTxt('nav-faq-link', t.navFAQ);
  setTxt('nav-support-link', t.navSupport);
  setTxt('nav-privacy-link', t.navPrivacy);
  setTxt('nav-eula-link', t.navEULA);
  setTxt('nav-download-btn-text', t.navDownload);
  setTxt('lang-btn-text', lang === 'tr' ? 'EN' : 'TR');

  setTxt('hero-badge-text', t.heroBadge);
  setTxt('hero-title-text', t.heroTitle);
  setTxt('hero-subtitle-text', t.heroSubtitle);
  setTxt('btn-appstore-label', t.heroBadgeStore);
  setTxt('btn-playstore-label', t.heroBadgeStore);
  setTxt('stat-streak-val', t.statCleanStreak);
  setTxt('stat-streak-desc', t.statCleanStreakDesc);
  setTxt('stat-blocked-val', t.statBlockedSites);
  setTxt('stat-blocked-desc', t.statBlockedSitesDesc);
  setTxt('stat-saved-val', t.statSavedMoney);
  setTxt('stat-saved-desc', t.statSavedMoneyDesc);
  setTxt('deck-threat-tag', t.deckThreatTag);

  setTxt('feat-tag', t.featuresTag);
  setTxt('feat-title', t.featuresTitle);
  setTxt('feat-sub', t.featuresSubtitle);

  setTxt('f1-title', t.feat1Title);
  setTxt('f1-desc', t.feat1Desc);
  setTxt('f1-p1', t.feat1Pill1);
  setTxt('f1-p2', t.feat1Pill2);
  setTxt('f1-p3', t.feat1Pill3);

  setTxt('f2-title', t.feat2Title);
  setTxt('f2-desc', t.feat2Desc);
  setTxt('f2-p1', t.feat2Pill1);
  setTxt('f2-p2', t.feat2Pill2);
  setTxt('f2-p3', t.feat2Pill3);

  setTxt('f3-title', t.feat3Title);
  setTxt('f3-desc', t.feat3Desc);
  setTxt('f3-p1', t.feat3Pill1);
  setTxt('f3-p2', t.feat3Pill2);
  setTxt('f3-p3', t.feat3Pill3);

  setTxt('f4-title', t.feat4Title);
  setTxt('f4-desc', t.feat4Desc);
  setTxt('f4-p1', t.feat4Pill1);
  setTxt('f4-p2', t.feat4Pill2);
  setTxt('f4-p3', t.feat4Pill3);

  setTxt('f5-title', t.feat5Title);
  setTxt('f5-desc', t.feat5Desc);
  setTxt('f5-p1', t.feat5Pill1);
  setTxt('f5-p2', t.feat5Pill2);
  setTxt('f5-p3', t.feat5Pill3);

  setTxt('f6-title', t.feat6Title);
  setTxt('f6-desc', t.feat6Desc);
  setTxt('f6-p1', t.feat6Pill1);
  setTxt('f6-p2', t.feat6Pill2);
  setTxt('f6-p3', t.feat6Pill3);

  setTxt('calc-tag', t.calcTag);
  setTxt('calc-title', t.calcTitle);
  setTxt('calc-sub', t.calcSubtitle);
  setTxt('calc-input-label', t.calcMonthlyLabel);
  setTxt('calc-res-lead', t.calcResLead);
  setTxt('calc-res-sub', t.calcResSub);
  setTxt('calc-metric-month-lbl', t.calcMetricMonth);
  setTxt('calc-metric-5yr-lbl', t.calcMetric5Year);

  setTxt('breath-tag', t.breathTag);
  setTxt('breath-title', t.breathTitle);
  setTxt('breath-sub', t.breathSubtitle);
  if (breathingState === 'idle') {
    setTxt('breath-action-text', t.breathReady);
    setTxt('breath-start-btn', t.breathStartBtn);
  }

  setTxt('faq-tag', t.faqTag);
  setTxt('faq-title', t.faqTitle);
  setTxt('faq-sub', t.faqSubtitle);
  setTxt('faq-q1', t.faqQ1);
  setTxt('faq-a1', t.faqA1);
  setTxt('faq-q2', t.faqQ2);
  setTxt('faq-a2', t.faqA2);
  setTxt('faq-q3', t.faqQ3);
  setTxt('faq-a3', t.faqA3);
  setTxt('faq-q4', t.faqQ4);
  setTxt('faq-a4', t.faqA4);
  setTxt('faq-q5', t.faqQ5);
  setTxt('faq-a5', t.faqA5);

  setTxt('footer-desc', t.footerDesc);
  setTxt('footer-col-product', t.footerColProduct);
  setTxt('footer-col-legal', t.footerColLegal);
  setTxt('footer-col-support', t.footerColSupport);
  setTxt('footer-rights', t.footerRights);
  setTxt('footer-medical-note', t.footerMedicalNote);

  updateCalculator();
}

function updateCalculator() {
  const slider = document.getElementById('calc-slider');
  if (!slider) return;
  monthlySpend = parseFloat(slider.value);

  setTxt('calc-slider-val', formatCurrency(monthlySpend));

  const oneMonthSaved = monthlySpend;
  const oneYearSaved = monthlySpend * 12;
  const fiveYearsSaved = monthlySpend * 60;

  setTxt('calc-res-big', formatCurrency(oneYearSaved));
  setTxt('calc-metric-month-val', formatCurrency(oneMonthSaved));
  setTxt('calc-metric-5yr-val', formatCurrency(fiveYearsSaved));

  const comparisonEl = document.getElementById('calc-comparison-text');
  if (!comparisonEl) return;
  const t = translations[currentLang];
  let reward = "";

  if (currentCurrency === 'TRY') {
    if (oneYearSaved < 80000) {
      reward = currentLang === 'tr' ? "Son model akıllı telefon + 1 yıllık tatil birikimi" : "Latest smartphone + year of travel funds";
    } else if (oneYearSaved < 250000) {
      reward = currentLang === 'tr' ? "Ege sahillerinde lüks tatil + güçlü acil durum fonu" : "Luxury vacations + debt-free emergency vault";
    } else {
      reward = currentLang === 'tr' ? "Sıfır araç peşinatı veya geleceğe yatırım fonu" : "Vehicle down payment or solid investment portfolio";
    }
  } else {
    if (oneYearSaved < 6000) {
      reward = currentLang === 'tr' ? "Yeni MacBook Pro + acil durum birikimi" : "New MacBook Pro + emergency cash buffer";
    } else if (oneYearSaved < 20000) {
      reward = currentLang === 'tr' ? "Yurt dışı tatili + borçsuz finansal özgürlük" : "International trip + debt-free liberty";
    } else {
      reward = currentLang === 'tr' ? "Yatırım portföyü veya gayrimenkul peşinatı" : "Investment portfolio or home down-payment";
    }
  }
  comparisonEl.textContent = t.calcComparisonText + reward;
}

function toggleBreathing() {
  const btn = document.getElementById('breath-start-btn');
  const container = document.getElementById('breath-container');
  const core = document.getElementById('breath-core');
  const actionText = document.getElementById('breath-action-text');
  const timerText = document.getElementById('breath-timer-text');
  const t = translations[currentLang];
  if (!btn || !container || !core) return;

  if (breathingInterval) {
    clearInterval(breathingInterval);
    breathingInterval = null;
    breathingState = 'idle';
    container.classList.remove('breathing-active');
    core.className = 'breath-circle-core';
    btn.textContent = t.breathStartBtn;
    actionText.textContent = t.breathReady;
    timerText.textContent = "";
    return;
  }

  container.classList.add('breathing-active');
  btn.textContent = t.breathStopBtn;

  let step = 0;
  let count = 4;

  const runStep = () => {
    if (step === 0) {
      breathingState = 'inhale';
      core.className = 'breath-circle-core inhale';
      actionText.textContent = t.breathInhale;
    } else if (step === 1) {
      breathingState = 'hold';
      core.className = 'breath-circle-core hold';
      actionText.textContent = t.breathHold;
    } else {
      breathingState = 'exhale';
      core.className = 'breath-circle-core exhale';
      actionText.textContent = t.breathExhale;
    }
    timerText.textContent = `${count}s`;

    count--;
    if (count < 0) {
      step = (step + 1) % 3;
      count = 4;
    }
  };

  runStep();
  breathingInterval = setInterval(runStep, 1000);
}

function toggleTheme() {
  const current = document.documentElement.getAttribute('data-theme') || 'light';
  const next = current === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('nora-theme', next);
  const icon = document.getElementById('theme-icon');
  if (icon) icon.textContent = next === 'dark' ? '🌙' : '☀️';
}

document.addEventListener('DOMContentLoaded', () => {
  const savedTheme = localStorage.getItem('nora-theme') || 'light';
  document.documentElement.setAttribute('data-theme', savedTheme);
  const icon = document.getElementById('theme-icon');
  if (icon) icon.textContent = savedTheme === 'dark' ? '🌙' : '☀️';

  const savedLang = localStorage.getItem('nora-lang') || 'tr';
  applyLanguage(savedLang);

  const themeBtn = document.getElementById('theme-toggle-btn');
  if (themeBtn) themeBtn.addEventListener('click', toggleTheme);

  const langBtn = document.getElementById('lang-switch-btn');
  if (langBtn) {
    langBtn.addEventListener('click', () => {
      applyLanguage(currentLang === 'tr' ? 'en' : 'tr');
    });
  }

  const mobileToggle = document.getElementById('mobile-toggle-btn');
  const navMenu = document.getElementById('nav-menu');
  if (mobileToggle && navMenu) {
    mobileToggle.addEventListener('click', () => {
      navMenu.classList.toggle('open');
    });
    document.querySelectorAll('.nav-menu a').forEach(link => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
      });
    });
  }

  const slider = document.getElementById('calc-slider');
  if (slider) {
    slider.addEventListener('input', updateCalculator);

    document.querySelectorAll('.preset-chip').forEach(chip => {
      chip.addEventListener('click', (e) => {
        document.querySelectorAll('.preset-chip').forEach(c => c.classList.remove('active'));
        e.target.classList.add('active');
        slider.value = e.target.getAttribute('data-val');
        updateCalculator();
      });
    });

    document.querySelectorAll('.curr-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        document.querySelectorAll('.curr-btn').forEach(b => b.classList.remove('active'));
        e.target.classList.add('active');
        currentCurrency = e.target.getAttribute('data-curr');
        if (currentCurrency === 'TRY') {
          slider.min = "2000";
          slider.max = "100000";
          slider.step = "1000";
          slider.value = "15000";
        } else {
          slider.min = "100";
          slider.max = "5000";
          slider.step = "50";
          slider.value = "800";
        }
        updateCalculator();
      });
    });
  }

  const breathBtn = document.getElementById('breath-start-btn');
  if (breathBtn) breathBtn.addEventListener('click', toggleBreathing);

  document.querySelectorAll('.faq-item').forEach(item => {
    const btn = item.querySelector('.faq-question-btn');
    if (btn) {
      btn.addEventListener('click', () => {
        const isOpen = item.classList.contains('open');
        document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
        if (!isOpen) item.classList.add('open');
      });
    }
  });

  // Initialize live blocked sites from Firestore
  initThreatTicker();
});

// ==========================================================================
// DYNAMIC FIRESTORE BLOCKED SITES TICKER
// ==========================================================================
const DEFAULT_BLOCKED_DOMAINS = [
  '1xbet.com',
  'bets10.com',
  'casinomaxi.com',
  'mobilbahis.com',
  'jojobet.com',
  'tempobet.com',
  'stake.com',
  'betboo.com',
  'roobet.com',
  'matbet.com',
  'superbahis.com',
  'tipobet.com',
  'sahabet.com',
  'pinup.casino',
  'casino-metropol.com',
  'betpas.com',
  'sekabet.com'
];

let blockedDomains = [...DEFAULT_BLOCKED_DOMAINS];
let tickerIndex = 0;
let tickerTimer = null;

async function fetchBlockedSitesFromFirestore() {
  try {
    const res = await fetch(
      'https://firestore.googleapis.com/v1/projects/nora-manager/databases/(default)/documents/blocked_sites?pageSize=100'
    );
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.documents && Array.isArray(data.documents)) {
      const parsed = [];
      data.documents.forEach(doc => {
        const f = doc.fields || {};
        const domain = f.domain?.stringValue;
        if (domain && domain.trim().length > 0) {
          parsed.push(domain.trim());
        }
      });
      if (parsed.length > 0) {
        // De-duplicate domains and update live pool
        blockedDomains = Array.from(new Set(parsed));
      }
    }
  } catch (err) {
    console.warn('Could not load blocked sites from Firestore, fallback active:', err);
  }
}

function updateThreatTicker(instant = false) {
  const windowEl = document.getElementById('deck-threat-window');
  if (!windowEl || blockedDomains.length === 0) return;

  const count = 3;
  const selected = [];
  for (let i = 0; i < count; i++) {
    const idx = (tickerIndex + i) % blockedDomains.length;
    selected.push(blockedDomains[idx]);
  }
  tickerIndex = (tickerIndex + count) % blockedDomains.length;

  const latency = (0.01 + Math.random() * 0.03).toFixed(2);
  const domainText = selected.join(' • ');

  const currentItem = windowEl.querySelector('.deck-threat-item.is-active');

  if (instant || !currentItem) {
    windowEl.innerHTML = `
      <div class="deck-threat-item is-active">
        <span class="threat-names">${domainText}</span>
        <span class="deck-threat-latency">[${latency}ms]</span>
      </div>
    `;
    return;
  }

  // Clean any lingering exiting elements
  windowEl.querySelectorAll('.deck-threat-item.is-exiting').forEach(el => el.remove());

  const nextItem = document.createElement('div');
  nextItem.className = 'deck-threat-item is-entering';
  nextItem.innerHTML = `
    <span class="threat-names">${domainText}</span>
    <span class="deck-threat-latency">[${latency}ms]</span>
  `;
  windowEl.appendChild(nextItem);

  // Force reflow
  void nextItem.offsetHeight;

  currentItem.classList.remove('is-active');
  currentItem.classList.add('is-exiting');

  nextItem.classList.remove('is-entering');
  nextItem.classList.add('is-active');

  setTimeout(() => {
    if (currentItem && currentItem.parentNode === windowEl) {
      currentItem.remove();
    }
  }, 480);
}

function initThreatTicker() {
  const windowEl = document.getElementById('deck-threat-window');
  if (!windowEl) return;

  if (tickerTimer) clearInterval(tickerTimer);
  tickerTimer = setInterval(() => updateThreatTicker(false), 3200);

  // Fetch real-time records from Firestore DB and refresh
  fetchBlockedSitesFromFirestore().then(() => {
    updateThreatTicker(false);
  });
}
