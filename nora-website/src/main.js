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
    sosGuideBadge: "BİLİMSEL 4-4-4 METODU",
    sosGuideHead: "Nörobilimsel Dürtü Sörfü Protokolü",
    sosStep1Title: "Derin Nefes Al (4 sn)",
    sosStep1Desc: "Vagus sinirini aktive eder, vücudu acil durum ve panik modundan çıkarır.",
    sosStep2Title: "Nefesini Tut (4 sn)",
    sosStep2Desc: "Beyindeki amigdala alarmını dondurur, ani dürtü ve kupon basma baskısını keser.",
    sosStep3Title: "Yavaşça Bırak (4 sn)",
    sosStep3Desc: "Kalp atış hızını düşürür ve dopamin açlığı yaşayan sinir hücrelerini yatıştırır.",
    sosGuideNote: "💡 Kumar dürtüsü bir okyanus dalgası gibidir; 10-15 dakikada söner. Savaşma, dalgayı yönet.",

    // Contrast Section
    contrastTag: "ZİHİNSEL DÖNÜŞÜM",
    contrastTitle: "Kumarın Cehennemi vs. Nora ile Özgürlük",
    contrastSub: "Aynı insan, aynı hayat, iki bambaşka gelecek. Hangi tarafta uyanmak istediğine bugün karar ver.",
    c1Badge: "Kumarın Bataklığı (Tükeniş)",
    c1Title: "Sahte Bir Heyecan, Gerçek Bir Enkaz",
    c1Desc: "Kumar seni zengin etmez; senden zamanını, saygınlığını, paranı ve sevdiklerinin sana olan güvenini çalar.",
    c1I1: "Gece 03:42'de buz gibi soğuk terlerle basılan son kuponlar ve kaçan uykular.",
    c1I2: "\"Zararı çıkarıp hemen bırakacağım\" yalanıyla derinleşen borç girdabı.",
    c1I3: "Eşine, ailene ve dostlarına söylenen tükenmiş yalanlar, silinen banka SMS'leri.",
    c1I4: "Maaş yattıktan sonraki 15 dakikada gelen çaresizlik ve panik ataklar.",
    c1I5: "Sürekli gizlenme, telefonunu birilerinden saklama ve eriyen özsaygın.",
    c1Foot: "⚠️ Bu döngü kendi kendine durmaz. Bugün kırmazsan yarın daha pahalıya mal olacak.",

    c2Badge: "Nora ile Hayat (Özgürlük)",
    c2Title: "Huzurlu Zihin, Kurtarılan Gelecek",
    c2Desc: "Kalkan devreye girdiğinde zayıf anlarında bile güvendesin. Kumar siteleri engellenir, hayatın sana geri döner.",
    c2I1: "Yastığa başını koyduğunda gelen derin, kesintisiz ve vicdanı rahat bir uyku.",
    c2I2: "Cebinde kalan yüz binlerce lira; çocuklarına ve sevdiklerine gururla aldığın hediyeler.",
    c2I3: "Telefonunun ekranını kimseden saklamak zorunda kalmamanın eşsiz ferahlığı.",
    c2I4: "Her geçen gün yükselen özsaygın ve gözlerindeki o eski canlı ışıltının geri dönüşü.",
    c2I5: "7/24 arkanda duran, 50.000+ kumar sitesini sistem düzeyinde kilitleyen tavizsiz kalkan.",
    c2Foot: "🛡️ Yalnız değilsin. Binlerce insan bu kalkanla temiz kaldı. Sıra sende.",

    // Pledge Section
    pledgeTag: "ZİNCİRLERİ KIR",
    pledgeTitle: "Bugün, Hayatının En Cesur Kararını Ver",
    pledgeSub: "Kendi iradeni Nora kalkanıyla birleştir. Bugün hayatının son bahsi olsun.",
    pledgeQuote: "\"Bugün; beni tüketen, sevdiklerimden çalan ve geleceğimi karartan kumar döngüsünü arkamda bırakacağıma, Nora kalkanı ve kendi irademle yeni bir hayata adım atacağıma YEMİN EDİYORUM.\"",
    pledgeBtnText: "Yemini Mühürle: Bugün Son Bahis Olsun",
    pledgeSealTitle: "Özgürlüğe İlk Adım Mührün Alındı",
    pledgeSealSub: "1. Gün Temiz Kalma Yeminin Mühürlendi • Sen Bu Bataklıktan Daha Güçlüsün.",
    pledgeCounterText: "Bugün 184 kişi son bahsini yapmamaya yemin etti.",

    // Timeline Section
    timelineTag: "GELECEK SİMÜLATÖRÜ",
    timelineTitle: "Zaman Tüneli: Geleceğin İki Yolu",
    timelineSub: "Aşağıdaki zaman çubuğunu kaydırarak kumarla devam etmek ile Nora kalkanıyla yaşamak arasındaki devasa kader farkını gör.",

    // Math Simulator Section
    mathTag: "MATEMATİKSEL KANIT",
    mathTitle: "Kumar Makinesini Canlı Simüle Et",
    mathSub: "Kumar şans oyunu değil, senin parayı kaybetmen için tasarlanmış soğuk bir algoritmadır. ₺10.000 bakiye ile 100 oyun simüle et ve gerçeği gör.",
    mathLeadBadge: "MATEMATİK KANUNU",
    mathLeadTitle: "Kasa Algoritması Neden Asla Kaybetmez?",
    mathLeadDesc: "Bahis ve slot siteleri negatif matematiksel beklenti (RTP < %90) ile kodlanmıştır. Oynadıkça kaybetmek şanssızlık değil, yazılım kuralıdır.",
    mathLeadNote: "💡 Kazanmanın tek kesin yolu: Oyuna hiç başlamamaktır.",
    mathRunBtnText: "100 Oyunu Hızlıca Simüle Et",

    // Letter Section
    letterTag: "YALNIZ DEĞİLSİN",
    letterTitle: "Sana Açık Bir Mektup",
    letterSub: "Bu bataklıkta tek başına değilsin. Zayıf anlarında arkanda duran sarsılmaz bir kalkan var.",

    // FAQ Section
    faqTag: "ŞEFFAFLIK & DETAYLAR",
    faqTitle: "Sıkça Sorulan Sorular",
    faqSubtitle: "Nora kalkanı hakkında merak ettiğin her şey.",
    faqQ1: "Nora kumar sitelerini nasıl engelliyor?",
    faqA1: "Nora; cihaz düzeyinde güvenli ve yerel DNS/filtreleme protokolü uygular. Bu kalkan; bilinen yasadışı bahis, canlı casino, slot oyunları ve kumar odaklı kripto platformlarına ait 50.000'den fazla alan adına erişimi anında keser.",
    faqQ2: "Kriz anında kalkanı kolayca kapatabilir miyim?",
    faqA2: "Hayır. Nora özellikle anlık irade zayıflıklarında devreye giren caydırıcı koruma önlemleri içerir. Kalkanı devre dışı bırakmak için güvenlik PIN'i, soğuma süresi ve acil SOS onay adımları zorunludur.",
    faqQ3: "Kişisel ve finansal verilerim güvende mi?",
    faqA3: 'Kesinlikle. Nora gizlilik odaklı tasarlanmıştır. Tasarruf sayacınız, temizlik günleriniz ve günlük kayıtlarınız cihazınızda saklanır. Verileriniz hiçbir reklam verenle veya üçüncü tarafla paylaşılmaz. Detaylar için <a href="/privacy.html" style="color:var(--primary); font-weight:700;">Gizlilik Politikamıza</a> göz atabilirsiniz.',
    faqQ4: "Nora bir tıbbi veya psikiyatrik tedavi midir?",
    faqA4: 'Hayır. Nora, kullanıcıların irade güçlendirmesine ve dürtü yönetimini öğrenmesine destek olan davranışsal bir kalkan ve alışkanlık takip aracıdır. Klinik bir tedavi yerine geçmez. Ciddi krizlerde uzman desteği veya Yeşilay YEDAM (115) hattına başvurulmalıdır. Detaylar <a href="/eula.html" style="color:var(--primary); font-weight:700;">EULA Sözleşmemizde</a> yer almaktadır.',
    faqQ5: "Aboneliğimi nasıl iptal edebilir veya iade alabilirim?",
    faqA5: "Abonelikler Apple App Store veya Google Play hesabınız üzerinden doğrudan ve tek tıkla yönetilir. İptal işlemini dilediğiniz an mağaza ayarlarınızdan gerçekleştirebilirsiniz.",

    // Bento Hero Deck
    bentoLiveBadge: "7/24 TAVİZSİZ KALKAN AKTİF",
    bentoPin: "PIN KORUMALI",
    bentoShieldTitle: "Sistem Düzeyinde Katı Filtre",
    bentoShieldDesc: "DNS & yerel kalkan devrede • 0 Sızıntı • Anlık krizde kapatılamaz",
    bentoStreakTitle: "TEMİZ GÜN SAYACI",
    bentoStreakBadge: "🔥 GÜÇLÜ İRADE",
    bentoStreakVal: "42. GÜN",
    bentoStreakSub: "₺63.500 Kumardan Kurtarıldı",
    bentoStreakNote: "%84 • 60 Gün Şampiyonluk Kalkanına Az Kaldı",
    bentoSosTitle: "DÜRTÜ SÖRFÜ",
    bentoSosRule: "🚨 15 DK KURALI",
    bentoSosDesc: "Dürtüler 15 dakikada söner. Savaşma, dalgayı yönet.",
    bentoSosBtnText: "🧘 Nefes Simülatörünü Aç",
    bentoPrivacyDesc: "%100 Cihaz İçi Şifreleme • Verileriniz Asla Satılmaz",
    bentoPrivacyLink: "Detaylar ›",

    // Timeline labels
    tDarkM1Lbl: "Mali Kayıp",
    tDarkM2Lbl: "Ruhsal Çöküş",
    tLightM1Lbl: "Cepte Kalan Birikim",
    tLightM2Lbl: "Huzur ve Özsaygı",

    // Math Simulator labels & results
    mathInitLabel: "BAŞLANGIÇ BAKİYESİ",
    mathInitVal: "₺10.000",
    mathSpinsLabel: "OYNANAN TUR",
    mathBalanceLabel: "KALAN BAKİYE",
    mathChartLabel: "KASA ERİME GRAFİĞİ:",
    mathStatusLogReady: "Sistem hazır. Simülasyonu başlat butonuna tıkla.",
    mathResultMsgHtml: "🎯 <strong>Matematiksel Gerçek:</strong> Algoritma 100 turda ₺10.000 liranın tamamını yuttu. Kasa her zaman kazanır. Kazanmanın tek yolu oynamamaktır!",

    // Letter
    letterBodyHtml: `<p>Biliyorum. Şu an belki bu sayfaya bakarken içinde derin bir yangın var. Belki dün gece yine kaybettin, belki sabaha karşı yastığına gözyaşlarıyla başını koydun. Belki banka hesabındaki son kalan paraya bakıp <em>"Ben nasıl bu hale geldim?"</em> diyorsun.</p><p>Kendinden nefret etmeyi hemen şimdi bırak. Sen iradesiz, zayıf ya da kötü bir insan değilsin. Milyarlarca dolarlık yapay zeka ve dopamin tuzaklarıyla donatılmış devasa bir kumar endüstrisi seni biyolojik olarak tuzağa düşürdü.</p><p>Ama şunu asla unutma: <strong>Kaybettiğin hiçbir parayı kumar oynayarak geri kazanamazsın. Fakat kumarı bugün bırakırsan, kaybettiklerinin yüz katını; itibarını, aileni ve huzurunu geri kazanacaksın.</strong></p><p>Nora seni yargılamaz. Nora, zayıf anında araya giren çelikten bir kalkandır. Artık bu savaşı tek başına vermek zorunda değilsin.</p>`,
    letterSignature: "— Eski bir bağımlı ve Nora İyileşme Topluluğu",

    // Footer
    footerDesc: "Nora, kumar bağımlılığını geride bırakmak, cebindeki parayı korumak ve huzurlu bir hayata adım atmak isteyen herkes için geliştirilmiş tavizsiz koruma kalkanıdır.",
    footerColProduct: "Ürün",
    footerColLegal: "Hukuki & Şartlar",
    footerColSupport: "Yardım & Acil",
    footerRights: "© 2026 Nora App. Tüm hakları saklıdır.",
    footerMedicalNote: "Yasal Uyarı: Nora bir davranışsal ve teknolojik kalkan aracıdır; klinik tıbbi teşhis veya psikiyatri tedavi hizmeti yerine geçmez.",
    flFeatures: "Özellikler",
    flCalc: "Tasarruf Hesaplayıcı",
    flSos: "Dürtü Sörfü SOS",
    flFaq: "Sıkça Sorulan Sorular",
    flPrivacy: "Gizlilik Politikası (Privacy)",
    flEula: "Son Kullanıcı Lisansı (EULA)",
    flCompliance: "KVKK & GDPR Uyumluluğu",
    flTerms: "Kullanım Koşulları & İptal",
    flSupport: "Destek & Kriz Masası",
    flYedam: "Yeşilay YEDAM (115)",
    flGamcare: "GamCare Uluslararası",
    botPrivacy: "Gizlilik",
    botEula: "EULA",
    botSupport: "Destek",
    metaTitle: "Nora - Kumarı Bırak & Paran Sakla | Resmi Tanıtım",
    pledgedBtnActive: "✓ Yeminin Mühürlendi (Kalkanın Devrede)"
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
    sosGuideBadge: "SCIENTIFIC 4-4-4 METHOD",
    sosGuideHead: "Neuroscience Urge Surfing Protocol",
    sosStep1Title: "Inhale Deeply (4s)",
    sosStep1Desc: "Activates the vagus nerve, calming the body down from acute emergency distress.",
    sosStep2Title: "Hold Breath (4s)",
    sosStep2Desc: "Freezes amygdala fight-or-flight alarms, halting impulsive betting urges.",
    sosStep3Title: "Exhale Slowly (4s)",
    sosStep3Desc: "Lowers your resting heart rate and grounds dopamine-craving neural pathways.",
    sosGuideNote: "💡 A gambling urge is like an ocean wave; it naturally recedes in 10-15 minutes. Don't fight it—surf it.",

    // Contrast Section
    contrastTag: "MENTAL TRANSFORMATION",
    contrastTitle: "The Trap of Gambling vs. Freedom with Nora",
    contrastSub: "Same person, same life, two completely different futures. Decide which reality you want to wake up in today.",
    c1Badge: "The Gambling Quagmire (Ruin)",
    c1Title: "A False Dopamine Rush, A Real Disaster",
    c1Desc: "Gambling will never make you rich; it steals your time, dignity, money, and the trust of those you love.",
    c1I1: "Placing desperate bets at 3:42 AM in cold sweat, accompanied by restless, sleepless nights.",
    c1I2: "Falling deeper into debt with the self-delusion: \"I'll win back what I lost and quit.\"",
    c1I3: "Exhausting lies told to spouse, family, and friends; deleting bank notifications in secret.",
    c1I4: "Watching your hard-earned paycheck evaporate within 15 minutes, sparking pure panic.",
    c1I5: "Living in constant hiding, clutching your phone in fear, and watching self-worth erode.",
    c1Foot: "⚠️ This loop will never stop on its own. Breaking it today will cost far less than tomorrow.",

    c2Badge: "Life with Nora (Freedom)",
    c2Title: "Peace of Mind, Reclaimed Tomorrow",
    c2Desc: "When the shield is active, you are protected even in your weakest cravings. Sites are blocked, and life returns to you.",
    c2I1: "Laying your head on the pillow with deep, uninterrupted rest and a calm conscience.",
    c2I2: "Hundreds of thousands remaining in your account; proudly gifting the people you cherish.",
    c2I3: "The pure, unburdened freedom of never having to conceal your screen from anyone.",
    c2I4: "Self-respect climbing higher each day, rekindling the bright spark in your eyes.",
    c2I5: "An uncompromising 24/7 guardian blocking 50,000+ gambling domains at the OS level.",
    c2Foot: "🛡️ You are not alone. Thousands have stayed clean with this shield. Now it's your turn.",

    // Pledge Section
    pledgeTag: "BREAK THE CHAINS",
    pledgeTitle: "Make the Bravest Decision of Your Life Today",
    pledgeSub: "Combine your willpower with the Nora shield. Let today be your very last bet.",
    pledgeQuote: "\"Today, I SWEAR to leave behind the gambling cycle that consumed my peace, stole from my family, and darkened my future, taking the first step to freedom with Nora and my own willpower.\"",
    pledgeBtnText: "Seal the Pledge: Let Today Be the Last Bet",
    pledgeSealTitle: "Day 1 Freedom Seal Unlocked",
    pledgeSealSub: "Your clean streak pledge has been recorded • You are stronger than this addiction.",
    pledgeCounterText: "184 people took the pledge to never bet again today.",

    // Timeline Section
    timelineTag: "FUTURE DIVERGENCE SIMULATOR",
    timelineTitle: "Timeline: The Two Paths of Your Future",
    timelineSub: "Drag the timeline slider below to witness the diverging fates between staying trapped in gambling versus thriving with Nora.",

    // Math Simulator Section
    mathTag: "MATHEMATICAL PROOF",
    mathTitle: "Live Casino House Edge Simulator",
    mathSub: "Gambling is not luck; it is a cold mathematical algorithm engineered to take your money. Simulate 100 bets with ₺10,000 and see the truth.",
    mathLeadBadge: "LAW OF MATHEMATICS",
    mathLeadTitle: "Why Does the House Edge Never Lose?",
    mathLeadDesc: "Sportsbooks and slots are engineered with negative expected value (RTP < 90%). Losing over time isn't bad luck—it's hardcoded mathematical certainty.",
    mathLeadNote: "💡 The only foolproof way to win: Never begin the game.",
    mathRunBtnText: "Simulate 100 Fast Bets Now",

    // Letter Section
    letterTag: "YOU ARE NOT ALONE",
    letterTitle: "An Open Letter to You",
    letterSub: "You are not alone in this dark struggle. An unbreakable shield stands behind you in moments of weakness.",

    // FAQ Section
    faqTag: "TRANSPARENCY",
    faqTitle: "Frequently Asked Questions",
    faqSubtitle: "Everything you need to know about Nora's protective shield.",
    faqQ1: "How does Nora block gambling websites?",
    faqA1: "Nora implements secure, system-level DNS and device management filters. It prevents outbound connections to over 50,000 known online casinos, sportsbook operators, slot engines, and crypto betting dApps.",
    faqQ2: "Can I easily disable the shield during a weak moment?",
    faqA2: "No. Nora is engineered with strict friction mechanics specifically designed to protect you from impulse relapses. Disabling the blocker requires cooling-off periods and safety PIN confirmation.",
    faqQ3: "Is my personal and financial information private?",
    faqA3: 'Completely. Nora does not collect, broker, or sell any of your journal entries, savings milestones, or browsing patterns. Your data stays securely stored on your personal device. For full details, review our <a href="/privacy.html" style="color:var(--primary); font-weight:700;">Privacy Policy</a>.',
    faqQ4: "Is Nora a substitute for medical or psychiatric treatment?",
    faqA4: 'No. Nora is an evidence-informed behavioral habit companion and digital blocking tool. It does not provide medical diagnosis or addiction healthcare. Users experiencing severe crises should reach out to licensed professionals or gambling hotlines. See our <a href="/eula.html" style="color:var(--primary); font-weight:700;">EULA Agreement</a> for complete terms.',
    faqQ5: "How do I cancel or request a refund for my subscription?",
    faqA5: "Subscriptions are managed directly through your Apple App Store or Google Play account. You can cancel at any time in your device settings prior to your renewal date.",

    // Bento Hero Deck
    bentoLiveBadge: "24/7 STRICT SHIELD ACTIVE",
    bentoPin: "PIN PROTECTED",
    bentoShieldTitle: "System-Level Hard Barrier",
    bentoShieldDesc: "DNS & on-device kernel active • Zero Leaks • Impulse-proof",
    bentoStreakTitle: "CLEAN STREAK COUNTER",
    bentoStreakBadge: "🔥 STRONG WILL",
    bentoStreakVal: "DAY 42",
    bentoStreakSub: "$4,200 Rescued From Bets",
    bentoStreakNote: "84% • Approaching 60-Day Champion Shield",
    bentoSosTitle: "URGE SURFING",
    bentoSosRule: "🚨 15-MIN RULE",
    bentoSosDesc: "Urges peak and die within 15 mins. Don't fight, surf the wave.",
    bentoSosBtnText: "🧘 Open Breathing Simulator",
    bentoPrivacyDesc: "100% On-Device Encryption • Data Never Sold",
    bentoPrivacyLink: "Details ›",

    // Timeline labels
    tDarkM1Lbl: "Financial Loss",
    tDarkM2Lbl: "Mental Toll",
    tLightM1Lbl: "Protected Savings",
    tLightM2Lbl: "Peace & Dignity",

    // Math Simulator labels & results
    mathInitLabel: "INITIAL BALANCE",
    mathInitVal: "$1,000",
    mathSpinsLabel: "SPINS PLAYED",
    mathBalanceLabel: "REMAINING BALANCE",
    mathChartLabel: "HOUSE EDGE DEPLETION TRACKER:",
    mathStatusLogReady: "Engine ready. Click button to run 100 fast bets.",
    mathResultMsgHtml: "🎯 <strong>Mathematical Truth:</strong> The algorithm wiped out the entire balance in 100 spins. The house always wins. The only way to win is not to play!",

    // Letter
    letterBodyHtml: `<p>I hear you. Looking at this screen right now, there might be a deep ache inside your chest. Maybe you took another heavy loss last night; maybe you cried into your pillow as dawn broke. Maybe you looked at an empty bank account asking yourself: <em>"How did I let it get this bad?"</em></p><p>Stop beating yourself up right now. You are not weak, broken, or a failure. You were systematically targeted and neurologically trapped by a predatory multi-billion-dollar gambling industry engineered specifically to hijack human biology.</p><p>Remember this absolute truth: <strong>You will never win back lost money by continuing to gamble. But if you stop today, you will win back something infinitely more valuable: your dignity, your loved ones' trust, and pure peace of mind.</strong></p><p>Nora will never judge you. Nora is an uncompromising titanium barrier standing between you and an impulse during your most vulnerable moments. You don't have to fight this alone anymore.</p>`,
    letterSignature: "— A Recovered Survivor & Nora Fellowship",

    // Footer
    footerDesc: "Nora is the unyielding digital shield built for anyone looking to break the gambling cycle, safeguard their wealth, and reclaim self-mastery.",
    footerColProduct: "Product",
    footerColLegal: "Legal & Terms",
    footerColSupport: "Help & Crisis",
    footerRights: "© 2026 Nora App. All rights reserved.",
    footerMedicalNote: "Disclaimer: Nora is a behavioral habit tool and content filter; it is not a substitute for clinical psychological or psychiatric therapy.",
    flFeatures: "Features",
    flCalc: "Savings Vault",
    flSos: "Urge Surfing SOS",
    flFaq: "FAQ",
    flPrivacy: "Privacy Policy",
    flEula: "End User License (EULA)",
    flCompliance: "GDPR & KVKK Compliance",
    flTerms: "Terms of Use & Cancellation",
    flSupport: "Support & Crisis Desk",
    flYedam: "YEDAM Hotline (115)",
    flGamcare: "GamCare International",
    botPrivacy: "Privacy",
    botEula: "EULA",
    botSupport: "Support",
    metaTitle: "Nora - Quit Gambling & Reclaim Your Wealth | Official",
    pledgedBtnActive: "✓ Pledge Sealed (Shield Active)"
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

function setHTML(id, val) {
  const el = document.getElementById(id);
  if (el) el.innerHTML = val;
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

  // Document Title
  if (t.metaTitle) document.title = t.metaTitle;

  // Header Nav
  setTxt('nav-features-link', t.navFeatures);
  setTxt('nav-calc-link', t.navCalculator);
  setTxt('nav-sos-link', t.navSOS);
  setTxt('nav-faq-link', t.navFAQ);
  setTxt('nav-support-link', t.navSupport);
  setTxt('nav-privacy-link', t.navPrivacy);
  setTxt('nav-eula-link', t.navEULA);
  setTxt('nav-download-btn-text', t.navDownload);
  setTxt('lang-btn-text', lang === 'tr' ? 'EN' : 'TR');

  // Hero Section
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

  // Bento Command Deck
  setTxt('bento-live-badge-text', t.bentoLiveBadge);
  setTxt('bento-pin-text', t.bentoPin);
  setTxt('deck-shield-title', t.bentoShieldTitle);
  setTxt('deck-shield-desc', t.bentoShieldDesc);
  setTxt('bento-streak-title', t.bentoStreakTitle);
  setTxt('bento-streak-badge', t.bentoStreakBadge);
  setTxt('bento-streak-val', t.bentoStreakVal);
  setTxt('bento-streak-sub', t.bentoStreakSub);
  setTxt('bento-streak-note', t.bentoStreakNote);
  setTxt('bento-sos-title', t.bentoSosTitle);
  setTxt('bento-sos-rule', t.bentoSosRule);
  setTxt('bento-sos-desc', t.bentoSosDesc);
  setTxt('bento-sos-btn-text', t.bentoSosBtnText);
  setTxt('bento-privacy-desc', t.bentoPrivacyDesc);
  setTxt('bento-privacy-link', t.bentoPrivacyLink);

  // Features Section
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

  // Calculator Section
  setTxt('calc-tag', t.calcTag);
  setTxt('calc-title', t.calcTitle);
  setTxt('calc-sub', t.calcSubtitle);
  setTxt('calc-input-label', t.calcMonthlyLabel);
  setTxt('calc-res-lead', t.calcResLead);
  setTxt('calc-res-sub', t.calcResSub);
  setTxt('calc-metric-month-lbl', t.calcMetricMonth);
  setTxt('calc-metric-5yr-lbl', t.calcMetric5Year);

  // Contrast Section
  setTxt('contrast-tag', t.contrastTag);
  setTxt('contrast-title', t.contrastTitle);
  setTxt('contrast-sub', t.contrastSub);
  setTxt('c1-badge', t.c1Badge);
  setTxt('c1-title', t.c1Title);
  setTxt('c1-desc', t.c1Desc);
  setTxt('c1-i1', t.c1I1);
  setTxt('c1-i2', t.c1I2);
  setTxt('c1-i3', t.c1I3);
  setTxt('c1-i4', t.c1I4);
  setTxt('c1-i5', t.c1I5);
  setTxt('c1-foot', t.c1Foot);

  setTxt('c2-badge', t.c2Badge);
  setTxt('c2-title', t.c2Title);
  setTxt('c2-desc', t.c2Desc);
  setTxt('c2-i1', t.c2I1);
  setTxt('c2-i2', t.c2I2);
  setTxt('c2-i3', t.c2I3);
  setTxt('c2-i4', t.c2I4);
  setTxt('c2-i5', t.c2I5);
  setTxt('c2-foot', t.c2Foot);

  // Pledge Section
  setTxt('pledge-tag', t.pledgeTag);
  setTxt('pledge-title', t.pledgeTitle);
  setTxt('pledge-sub', t.pledgeSub);
  setTxt('pledge-quote', t.pledgeQuote);
  setTxt('pledge-btn-text', t.pledgeBtnText);
  setTxt('pledge-seal-title', t.pledgeSealTitle);
  setTxt('pledge-seal-sub', t.pledgeSealSub);
  setTxt('pledge-counter-text', t.pledgeCounterText);
  if (localStorage.getItem('nora-pledged') === 'true') {
    setTxt('pledge-btn-text', t.pledgedBtnActive);
  }

  // Timeline Section
  setTxt('timeline-tag', t.timelineTag);
  setTxt('timeline-title', t.timelineTitle);
  setTxt('timeline-sub', t.timelineSub);
  setTxt('t-dark-m1-lbl', t.tDarkM1Lbl);
  setTxt('t-dark-m2-lbl', t.tDarkM2Lbl);
  setTxt('t-light-m1-lbl', t.tLightM1Lbl);
  setTxt('t-light-m2-lbl', t.tLightM2Lbl);

  const stepLabels = lang === 'tr' 
    ? ['1. Ay', '6. Ay', '1. Yıl', '3. Yıl', '5. Yıl']
    : ['Month 1', 'Month 6', 'Year 1', 'Year 3', 'Year 5'];
  document.querySelectorAll('.timeline-steps-labels span').forEach((el, idx) => {
    if (stepLabels[idx]) el.textContent = stepLabels[idx];
  });
  const tSlider = document.getElementById('timeline-slider');
  if (typeof updateTimelineView === 'function') {
    updateTimelineView(tSlider ? tSlider.value : 2);
  }

  // Math Simulator Section
  setTxt('math-tag', t.mathTag);
  setTxt('math-title', t.mathTitle);
  setTxt('math-sub', t.mathSub);
  setTxt('math-lead-badge', t.mathLeadBadge);
  setTxt('math-lead-title', t.mathLeadTitle);
  setTxt('math-lead-desc', t.mathLeadDesc);
  setTxt('math-lead-note', t.mathLeadNote);
  setTxt('math-run-btn-text', t.mathRunBtnText);
  setTxt('math-init-label', t.mathInitLabel);
  setTxt('math-init-val', t.mathInitVal);
  setTxt('math-spins-label', t.mathSpinsLabel);
  setTxt('math-balance-label', t.mathBalanceLabel);
  setTxt('math-chart-label', t.mathChartLabel);
  setTxt('math-status-log', t.mathStatusLogReady);
  setHTML('math-result-msg', t.mathResultMsgHtml);

  // Letter Section
  setTxt('letter-tag', t.letterTag);
  setTxt('letter-title', t.letterTitle);
  setTxt('letter-sub', t.letterSub);
  setHTML('letter-body', t.letterBodyHtml);
  setTxt('letter-signature', t.letterSignature);

  // Urge Surfing Section
  setTxt('breath-tag', t.breathTag);
  setTxt('breath-title', t.breathTitle);
  setTxt('breath-sub', t.breathSubtitle);
  setTxt('sos-guide-badge', t.sosGuideBadge);
  setTxt('sos-guide-head', t.sosGuideHead);
  setTxt('sos-step1-title', t.sosStep1Title);
  setTxt('sos-step1-desc', t.sosStep1Desc);
  setTxt('sos-step2-title', t.sosStep2Title);
  setTxt('sos-step2-desc', t.sosStep2Desc);
  setTxt('sos-step3-title', t.sosStep3Title);
  setTxt('sos-step3-desc', t.sosStep3Desc);
  setTxt('sos-guide-note', t.sosGuideNote);
  if (breathingState === 'idle') {
    setTxt('breath-action-text', t.breathReady);
    setTxt('breath-start-btn', t.breathStartBtn);
  }

  // FAQ Section
  setTxt('faq-tag', t.faqTag);
  setTxt('faq-title', t.faqTitle);
  setTxt('faq-sub', t.faqSubtitle);
  setTxt('faq-q1', t.faqQ1);
  setTxt('faq-a1', t.faqA1);
  setTxt('faq-q2', t.faqQ2);
  setTxt('faq-a2', t.faqA2);
  setTxt('faq-q3', t.faqQ3);
  setHTML('faq-a3', t.faqA3);
  setTxt('faq-q4', t.faqQ4);
  setHTML('faq-a4', t.faqA4);
  setTxt('faq-q5', t.faqQ5);
  setTxt('faq-a5', t.faqA5);

  // Footer Section
  setTxt('footer-desc', t.footerDesc);
  setTxt('footer-col-product', t.footerColProduct);
  setTxt('footer-col-legal', t.footerColLegal);
  setTxt('footer-col-support', t.footerColSupport);
  setTxt('footer-rights', t.footerRights);
  setTxt('footer-medical-note', t.footerMedicalNote);
  setTxt('fl-features', t.flFeatures);
  setTxt('fl-calc', t.flCalc);
  setTxt('fl-sos', t.flSos);
  setTxt('fl-faq', t.flFaq);
  setTxt('fl-privacy', t.flPrivacy);
  setTxt('fl-eula', t.flEula);
  setTxt('fl-compliance', t.flCompliance);
  setTxt('fl-terms', t.flTerms);
  setTxt('fl-support', t.flSupport);
  setTxt('fl-yedam', t.flYedam);
  setTxt('fl-gamcare', t.flGamcare);
  setTxt('footer-bot-privacy', t.botPrivacy);
  setTxt('footer-bot-eula', t.botEula);
  setTxt('footer-bot-support', t.botSupport);

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

  // Initialize mission-driven recovery animations & experiences
  initHealingCanvas();
  initScrollReveal();
  initPledge();
  initLiveHopeToasts();
  initTimelineSlider();
  initMathSimulator();
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

// ==========================================================================
// 1. AMBIENT HEALING PARTICLES CANVAS
// ==========================================================================
function initHealingCanvas() {
  const canvas = document.getElementById('healing-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  if (!ctx) return;

  let width = (canvas.width = window.innerWidth);
  let height = (canvas.height = window.innerHeight);

  window.addEventListener('resize', () => {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
  });

  const particleCount = Math.min(45, Math.floor(width / 30));
  const particles = [];

  for (let i = 0; i < particleCount; i++) {
    particles.push({
      x: Math.random() * width,
      y: Math.random() * height,
      radius: Math.random() * 2.2 + 0.8,
      speedY: Math.random() * 0.45 + 0.15,
      drift: (Math.random() - 0.5) * 0.3,
      alpha: Math.random() * 0.5 + 0.2,
      pulseSpeed: Math.random() * 0.02 + 0.01,
      isGold: Math.random() > 0.6
    });
  }

  let mouseX = width / 2;
  let mouseY = height / 2;
  window.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
  });

  function render() {
    if (document.hidden) {
      requestAnimationFrame(render);
      return;
    }

    ctx.clearRect(0, 0, width, height);

    particles.forEach((p) => {
      p.y -= p.speedY;
      p.x += p.drift;
      p.alpha += Math.sin(Date.now() * p.pulseSpeed * 0.05) * 0.005;

      // Wrap around screen
      if (p.y < -10) {
        p.y = height + 10;
        p.x = Math.random() * width;
      }
      if (p.x < -10) p.x = width + 10;
      if (p.x > width + 10) p.x = -10;

      // Subtle mouse influence
      const dx = mouseX - p.x;
      const dy = mouseY - p.y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < 100) {
        p.x -= (dx / dist) * 0.6;
        p.y -= (dy / dist) * 0.6;
      }

      const safeAlpha = Math.max(0.1, Math.min(0.75, p.alpha));
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      ctx.fillStyle = p.isGold
        ? `rgba(251, 191, 36, ${safeAlpha})`
        : `rgba(0, 230, 118, ${safeAlpha})`;
      ctx.shadowBlur = 12;
      ctx.shadowColor = p.isGold ? 'rgba(245, 158, 11, 0.4)' : 'rgba(0, 230, 118, 0.4)';
      ctx.fill();
    });

    requestAnimationFrame(render);
  }

  render();
}

// ==========================================================================
// 2. SCROLL REVEAL OBSERVER & DYNAMIC NUMBER COUNT-UP
// ==========================================================================
function initScrollReveal() {
  const elements = document.querySelectorAll('.reveal-on-scroll');
  if (!elements.length) return;

  const observer = new IntersectionObserver(
    (entries, obs) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-revealed');
          obs.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
  );

  elements.forEach((el) => observer.observe(el));

  // Count up Hero numbers when visible
  const heroStats = document.querySelector('.hero-social-proof');
  if (heroStats) {
    const statsObserver = new IntersectionObserver((entries, obs) => {
      if (entries[0].isIntersecting) {
        animateCounter('stat-streak-val', 0, 94, '%', 1400);
        animateCounter('stat-blocked-val', 0, 50000, '+', 1800, true);
        obs.unobserve(heroStats);
      }
    }, { threshold: 0.3 });
    statsObserver.observe(heroStats);
  }
}

function animateCounter(id, start, end, suffix, duration, formatNumber = false) {
  const el = document.getElementById(id);
  if (!el) return;
  const startTime = performance.now();

  function update(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    // Smooth ease-out cubic
    const easeProgress = 1 - Math.pow(1 - progress, 3);
    const current = Math.floor(start + (end - start) * easeProgress);

    const formatted = formatNumber ? current.toLocaleString('tr-TR') : current;
    el.textContent = suffix === '%' ? `%${formatted}` : `${formatted}${suffix}`;

    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }

  requestAnimationFrame(update);
}

// ==========================================================================
// 3. SACRED RECOVERY PLEDGE WITH CELEBRATORY BURST
// ==========================================================================
function initPledge() {
  const pledgeBtn = document.getElementById('pledge-seal-btn');
  const sealDisplay = document.getElementById('pledge-seal-display');
  if (!pledgeBtn || !sealDisplay) return;

  // Check if previously pledged
  const isPledged = localStorage.getItem('nora-pledged') === 'true';
  if (isPledged) {
    sealDisplay.classList.add('active');
    pledgeBtn.style.opacity = '0.9';
    const btnText = document.getElementById('pledge-btn-text');
    if (btnText) btnText.textContent = currentLang === 'tr' ? '✓ Yeminin Mühürlendi (Kalkanın Devrede)' : '✓ Pledge Sealed (Shield Active)';
  }

  pledgeBtn.addEventListener('click', (e) => {
    // 1. Button ripple
    const ripple = document.createElement('span');
    ripple.className = 'pledge-btn-ripple';
    const rect = pledgeBtn.getBoundingClientRect();
    ripple.style.left = `${e.clientX - rect.left}px`;
    ripple.style.top = `${e.clientY - rect.top}px`;
    pledgeBtn.appendChild(ripple);
    setTimeout(() => ripple.remove(), 600);

    // 2. Trigger Confetti / Particle Burst
    triggerConfettiBurst(e.clientX, e.clientY);

    // 3. Show badge and save state
    sealDisplay.classList.add('active');
    const btnText = document.getElementById('pledge-btn-text');
    if (btnText) {
      btnText.textContent = currentLang === 'tr' ? '✓ Yeminin Mühürlendi (Kalkanın Devrede)' : '✓ Pledge Sealed (Shield Active)';
    }

    localStorage.setItem('nora-pledged', 'true');
    localStorage.setItem('nora-pledged-timestamp', new Date().toISOString());

    // Update pledge counter
    const counterText = document.getElementById('pledge-counter-text');
    if (counterText) {
      counterText.textContent = currentLang === 'tr' 
        ? 'Bugün 185 kişi son bahsini yapmamaya yemin etti.' 
        : '185 people took the pledge to never bet again today.';
    }
  });
}

function triggerConfettiBurst(originX, originY) {
  const burstCount = 65;
  const colors = ['#00e676', '#10b981', '#f59e0b', '#fbbf24', '#ffffff', '#6366f1'];

  for (let i = 0; i < burstCount; i++) {
    const el = document.createElement('div');
    el.style.position = 'fixed';
    el.style.left = `${originX || window.innerWidth / 2}px`;
    el.style.top = `${originY || window.innerHeight / 2}px`;
    el.style.width = `${Math.random() * 8 + 4}px`;
    el.style.height = `${Math.random() * 8 + 4}px`;
    el.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
    el.style.borderRadius = Math.random() > 0.5 ? '50%' : '2px';
    el.style.pointerEvents = 'none';
    el.style.zIndex = '9999';
    el.style.transform = 'translate(-50%, -50%)';

    const angle = Math.random() * Math.PI * 2;
    const velocity = Math.random() * 180 + 80;
    const vx = Math.cos(angle) * velocity;
    const vy = Math.sin(angle) * velocity - 40;

    document.body.appendChild(el);

    const startTime = performance.now();
    function animate(now) {
      const elapsed = (now - startTime) / 1000;
      if (elapsed > 1.2) {
        el.remove();
        return;
      }
      const x = (originX || window.innerWidth / 2) + vx * elapsed;
      const y = (originY || window.innerHeight / 2) + vy * elapsed + 300 * elapsed * elapsed;
      const opacity = 1 - elapsed / 1.2;
      el.style.left = `${x}px`;
      el.style.top = `${y}px`;
      el.style.opacity = `${opacity}`;
      requestAnimationFrame(animate);
    }
    requestAnimationFrame(animate);
  }
}

// ==========================================================================
// 4. FLOATING LIVE HOPE SURVIVOR TOASTS
// ==========================================================================
const SURVIVOR_STORIES = {
  tr: [
    { city: 'İSTANBUL', time: '42 GÜN TEMİZ', quote: '"İlk kez maaşımın tek bir kuruşuna dokunmadan aileme verdim. Ağladık."', icon: '🕊️' },
    { city: 'ANKARA', time: '90 GÜN TEMİZ', quote: '"Geceleri gelen o boğucu panik hissi bitti. Hayatımı ve paramı geri kazandım."', icon: '🌟' },
    { city: 'İZMİR', time: '15 GÜN TEMİZ', quote: '"Dün gece kriz anında SOS nefesini açtım. ₺25.000 kumar yerine cebimde kaldı."', icon: '🛡️' },
    { city: 'BURSA', time: '1 YIL TEMİZ', quote: '"Borçlarım bitti, yüzüm gülüyor. Bu bataklıktan çıkış gerçekten var."', icon: '🌱' },
    { city: 'ANTALYA', time: '60 GÜN TEMİZ', quote: '"Telefonumu masaya korkusuzca koyabiliyorum artık. Bu huzur paha biçilemez."', icon: '✨' }
  ],
  en: [
    { city: 'NEW YORK', time: '42 DAYS CLEAN', quote: '"First time I gave my whole paycheck to my family without betting a dime. We cried tears of relief."', icon: '🕊️' },
    { city: 'LONDON', time: '90 DAYS CLEAN', quote: '"The suffocating 3 AM panic is completely gone. I finally have my dignity back."', icon: '🌟' },
    { city: 'BERLIN', time: '15 DAYS CLEAN', quote: '"The SOS surge protocol helped me ride out a massive urge last night. Saved $1,500."', icon: '🛡️' },
    { city: 'TORONTO', time: '1 YEAR CLEAN', quote: '"Debts paid off, family trust restored. You CAN break free from this trap."', icon: '🌱' }
  ]
};

let toastIndex = 0;
let toastTimer = null;

function initLiveHopeToasts() {
  const toastEl = document.getElementById('live-hope-toast');
  const closeBtn = document.getElementById('toast-close-btn');
  if (!toastEl) return;

  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      toastEl.classList.remove('is-visible');
      if (toastTimer) clearInterval(toastTimer);
    });
  }

  function showNextStory() {
    const list = SURVIVOR_STORIES[currentLang] || SURVIVOR_STORIES.tr;
    const story = list[toastIndex % list.length];
    toastIndex++;

    const avatarEl = document.getElementById('toast-avatar');
    const authorEl = document.getElementById('toast-author');
    const quoteEl = document.getElementById('toast-quote');

    if (avatarEl) avatarEl.textContent = story.icon;
    if (authorEl) authorEl.textContent = `${story.city} • ${story.time}`;
    if (quoteEl) quoteEl.textContent = story.quote;

    toastEl.classList.add('is-visible');

    // Fade out after 5.5 seconds
    setTimeout(() => {
      toastEl.classList.remove('is-visible');
    }, 5500);
  }

  // Initial delay 3.5s after load, then repeat every 11 seconds
  setTimeout(() => {
    showNextStory();
    toastTimer = setInterval(showNextStory, 11000);
  }, 3500);
}

// ==========================================================================
// 5. 5-YEAR LIFE DIVERGENCE TIMELINE SLIDER
// ==========================================================================
const TIMELINE_DATA = {
  tr: [
    {
      step: '1. Ay',
      darkHead: 'Kumarla 1. Ay',
      darkText: 'Maaş yine 3 günde tükendi. Geceleri gelen soğuk terler ve kredi kartı asgari tutarını denkleştirme stresi başladı.',
      darkLoss: '-₺20.000', darkLossW: 20,
      darkStress: '%45 Anksiyete', darkStressW: 45,
      lightHead: 'Nora ile 1. Ay',
      lightText: 'İlk ay tamamen temiz! Cüzdandaki maaş kuruşu kuruşuna yerinde. Yastığa başını koyduğunda ilk kez derin bir nefes aldın.',
      lightGain: '+₺20.000', lightGainW: 20,
      lightPeace: '%60 Sakin Zihin', lightPeaceW: 60
    },
    {
      step: '6. Ay',
      darkHead: 'Kumarla 6. Ay',
      darkText: 'Tüm ek hesaplar ve kredi limitleri tükendi. Aileye ilk büyük yalanlar söylendi, eşinle güven krizleri başladı.',
      darkLoss: '-₺120.000', darkLossW: 45,
      darkStress: '%70 Yoğun Panik', darkStressW: 70,
      lightHead: 'Nora ile 6. Ay',
      lightText: 'Yarım yıl geride kaldı. Biriken ₺120.000 ile borçlar hafifledi, ailenin gözündeki o eski güven ve saygı yeniden canlandı.',
      lightGain: '+₺120.000', lightGainW: 45,
      lightPeace: '%80 Güçlü İrade', lightPeaceW: 80
    },
    {
      step: '1. Yıl',
      darkHead: 'Kumarla 1. Yıl',
      darkText: 'İcra tebligatları kapıda. Eşinden ve çocuklarından uzaklaşma, yalnızlaşma ve derin bir depresyon sarmalı.',
      darkLoss: '-₺240.000', darkLossW: 65,
      darkStress: '%85 Çöküş Riski', darkStressW: 85,
      lightHead: 'Nora ile 1. Yıl',
      lightText: 'Tam 1 yıl temizlik şampiyonluğu! ₺240.000 nakit birikim, çocuklarınla çıkılan huzurlu bir tatil ve geri kazanılan özsaygı.',
      lightGain: '+₺240.000', lightGainW: 65,
      lightPeace: '%95 Dingin Zihin', lightPeaceW: 95
    },
    {
      step: '3. Yıl',
      darkHead: 'Kumarla 3. Yıl',
      darkText: 'Ev veya araba birikimleri satıldı. Kaybedilen yıllar, dostlar ve parçalanmış bir aile düzeni.',
      darkLoss: '-₺800.000', darkLossW: 85,
      darkStress: '%95 Tükenmişlik', darkStressW: 95,
      lightHead: 'Nora ile 3. Yıl',
      lightText: 'Hayatın altın çağı. Birikimlerinle ev peşinatı veya kendi işini kurma gücü. Saygın, başı dik ve bağımsız bir hayat.',
      lightGain: '+₺800.000', lightGainW: 85,
      lightPeace: '%99 Tam Özgürlük', lightPeaceW: 99
    },
    {
      step: '5. Yıl',
      darkHead: 'Kumarla 5. Yıl',
      darkText: 'Milyonlarca lira kayıp, telafisi imkansız parçalanmış bir yuva ve ömür boyu süren pişmanlık.',
      darkLoss: '-₺1.800.000+', darkLossW: 100,
      darkStress: '%100 Kalıcı Enkaz', darkStressW: 100,
      lightHead: 'Nora ile 5. Yıl',
      lightText: 'Kumar artık sadece uzak ve kötü bir anı. Kendi geleceğini ve sevdiklerinin hayatını kurtardın.',
      lightGain: '+₺1.800.000+', lightGainW: 100,
      lightPeace: '%100 Mutlak Huzur', lightPeaceW: 100
    }
  ],
  en: [
    {
      step: 'Month 1',
      darkHead: 'Gambling Path (Month 1)',
      darkText: 'Paycheck vanishes in 3 days. Waking up in cold sweat, panicking to cover credit card minimums.',
      darkLoss: '-$1,500', darkLossW: 20,
      darkStress: '45% Anxiety', darkStressW: 45,
      lightHead: 'Nora Path (Month 1)',
      lightText: 'First full clean month! Full paycheck preserved. Taking your first calm, restful breath at night.',
      lightGain: '+$1,500', lightGainW: 20,
      lightPeace: '60% Inner Calm', lightPeaceW: 60
    },
    {
      step: 'Month 6',
      darkHead: 'Gambling Path (Month 6)',
      darkText: 'Overdrafts and loans exhausted. First severe arguments at home; trust beginning to fracture.',
      darkLoss: '-$9,000', darkLossW: 45,
      darkStress: '70% High Panic', darkStressW: 70,
      lightHead: 'Nora Path (Month 6)',
      lightText: 'Half a year free. $9,000 protected; debts systematically clearing; loved ones noticing your genuine smile.',
      lightGain: '+$9,000', lightGainW: 45,
      lightPeace: '80% Restored Pride', lightPeaceW: 80
    },
    {
      step: 'Year 1',
      darkHead: 'Gambling Path (Year 1)',
      darkText: 'Collection notices arriving. Isolation, hiding from calls, sinking into severe depressive spiral.',
      darkLoss: '-$20,000', darkLossW: 65,
      darkStress: '85% Crisis Level', darkStressW: 85,
      lightHead: 'Nora Path (Year 1)',
      lightText: 'One full year champion streak! $20,000 saved, peaceful family vacation, self-respect completely reborn.',
      lightGain: '+$20,000', lightGainW: 65,
      lightPeace: '95% Peace of Mind', lightPeaceW: 95
    },
    {
      step: 'Year 3',
      darkHead: 'Gambling Path (Year 3)',
      darkText: 'Selling vehicles or emergency assets. Irretrievable years lost, friendships severed, broken family home.',
      darkLoss: '-$65,000', darkLossW: 85,
      darkStress: '95% Burnout', darkStressW: 95,
      lightHead: 'Nora Path (Year 3)',
      lightText: 'Your golden era. Down payment for a home or starting your dream business. Independent, honorable, respected.',
      lightGain: '+$65,000', lightGainW: 85,
      lightPeace: '99% Total Freedom', lightPeaceW: 99
    },
    {
      step: 'Year 5',
      darkHead: 'Gambling Path (Year 5)',
      darkText: 'Over $150,000 lost. A ruined family, irreversible missed moments, lifetime of sorrow.',
      darkLoss: '-$150,000+', darkLossW: 100,
      darkStress: '100% Lifelong Ruin', darkStressW: 100,
      lightHead: 'Nora Path (Year 5)',
      lightText: 'Gambling is now just a distant nightmare you conquered. You saved your life and inspired everyone around you.',
      lightGain: '+$150,000+', lightGainW: 100,
      lightPeace: '100% Absolute Mastery', lightPeaceW: 100
    }
  ]
};

function updateTimelineView(val) {
  const list = TIMELINE_DATA[currentLang] || TIMELINE_DATA.tr;
  const item = list[val] || list[2];

  setTxt('t-dark-head', item.darkHead);
  setTxt('t-dark-narrative', item.darkText);
  setTxt('t-dark-m1-val', item.darkLoss);
  const m1Bar = document.getElementById('t-dark-m1-bar');
  if (m1Bar) m1Bar.style.width = `${item.darkLossW}%`;

  setTxt('t-dark-m2-val', item.darkStress);
  const m2Bar = document.getElementById('t-dark-m2-bar');
  if (m2Bar) m2Bar.style.width = `${item.darkStressW}%`;

  setTxt('t-light-head', item.lightHead);
  setTxt('t-light-narrative', item.lightText);
  setTxt('t-light-m1-val', item.lightGain);
  const l1Bar = document.getElementById('t-light-m1-bar');
  if (l1Bar) l1Bar.style.width = `${item.lightGainW}%`;

  setTxt('t-light-m2-val', item.lightPeace);
  const l2Bar = document.getElementById('t-light-m2-bar');
  if (l2Bar) l2Bar.style.width = `${item.lightPeaceW}%`;

  document.querySelectorAll('.timeline-steps-labels span').forEach((label, idx) => {
    label.classList.toggle('active-step', idx === Number(val));
  });
}

function initTimelineSlider() {
  const slider = document.getElementById('timeline-slider');
  if (!slider) return;

  slider.addEventListener('input', (e) => {
    updateTimelineView(e.target.value);
  });
}

// ==========================================================================
// 7. MATHEMATICAL HOUSE EDGE REALITY SIMULATOR
// ==========================================================================
function initMathSimulator() {
  const runBtn = document.getElementById('math-run-btn');
  const spinsEl = document.getElementById('math-spins-val');
  const balEl = document.getElementById('math-current-balance');
  const barEl = document.getElementById('math-balance-bar');
  const logEl = document.getElementById('math-status-log');
  const resultMsg = document.getElementById('math-result-msg');

  if (!runBtn || !spinsEl || !balEl || !barEl) return;

  let isRunning = false;

  runBtn.addEventListener('click', () => {
    if (isRunning) return;
    isRunning = true;
    runBtn.disabled = true;
    runBtn.style.opacity = '0.6';
    if (resultMsg) resultMsg.classList.remove('active');

    let currentBalance = 10000;
    const initialBalance = 10000;
    let round = 0;
    const maxRounds = 100;

    const interval = setInterval(() => {
      round++;
      const betAmount = 150;

      // Realistic casino RTP simulation: House edge guarantees negative expectation
      const isWin = Math.random() < 0.42;
      if (isWin) {
        currentBalance += betAmount * 1.2;
      } else {
        currentBalance -= betAmount * 1.35;
      }

      if (currentBalance < 0) currentBalance = 0;

      spinsEl.textContent = `${round} / ${maxRounds}`;
      balEl.textContent = currentLang === 'tr' 
        ? `₺${Math.round(currentBalance).toLocaleString('tr-TR')}`
        : `$${Math.round(currentBalance / 10).toLocaleString('en-US')}`;

      const pct = Math.max(0, Math.min(100, (currentBalance / initialBalance) * 100));
      barEl.style.width = `${pct}%`;

      if (logEl) {
        if (currentLang === 'tr') {
          logEl.textContent = isWin 
            ? `[Tur ${round}] Sahte kazanç tuzağı (+₺${Math.round(betAmount * 1.2)}). Dopamin tuzağı devrede.`
            : `[Tur ${round}] Kasa kazandı (-₺${Math.round(betAmount * 1.35)}). Bakiye eriyor.`;
        } else {
          logEl.textContent = isWin 
            ? `[Round ${round}] Fake win illusion (+$${Math.round(betAmount * 0.12)}). Dopamine spike triggered.`
            : `[Round ${round}] House wins (-$${Math.round(betAmount * 0.135)}). Balance bleeding out.`;
        }
      }

      if (round >= maxRounds || currentBalance <= 0) {
        clearInterval(interval);
        isRunning = false;
        runBtn.disabled = false;
        runBtn.style.opacity = '1';
        balEl.textContent = currentLang === 'tr' ? '₺0' : '$0';
        barEl.style.width = '0%';
        if (logEl) {
          logEl.textContent = currentLang === 'tr' 
            ? 'Simülasyon tamamlandı: Bakiye sıfırlandı.' 
            : 'Simulation complete: Balance wiped out to $0.';
        }
        if (resultMsg) resultMsg.classList.add('active');
      }
    }, 35);
  });
}
