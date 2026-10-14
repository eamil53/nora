// ==========================================================================
// NORA OFFICIAL WEB - SUBPAGE MULTI-LANGUAGE ENGINE & INTERACTIONS
// Full bilingual support for /privacy.html, /eula.html, /support.html, /download.html
// ==========================================================================

const legalDocuments = {
  privacy: {
    tr: `
      <span class="legal-badge-pill">KVKK & GDPR UYUMLU GİZLİLİK POLİTİKASI</span>
      <h2>Nora Uygulaması Gizlilik Politikası</h2>
      <p><strong>Yürürlük Tarihi:</strong> 13 Ekim 2026 | <strong>Son Güncelleme:</strong> v1.0.0</p>
      
      <h3 id="sec-1">1. Giriş ve Veri Sorumlusu Taahhüdü</h3>
      <p>Nora ("Uygulama", "Biz", "Geliştirici"), kumar ve bahis bağımlılığı ile mücadele eden bireylerin finansal bağımsızlıklarını ve zihinsel esenliklerini geri kazanmalarına yardımcı olmayı hedefler. Kullanıcılarımızın mahremiyeti ve güvenliği bizim için en kutsal değerdir. Bu Gizlilik Politikası, Nora'yı kullanırken hangi verilerin işlendiğini ve bunların nasıl korunduğunu açıklar.</p>
      
      <h3 id="sec-2">2. Toplanan Bilgiler ve Cihazda Yerel Saklama Prensibi</h3>
      <p>Nora, "Gizlilik Öncelikli Tasarım" (Privacy by Design) ilkesiyle inşa edilmiştir:</p>
      <ul>
        <li><strong>Temiz Gün ve Tasarruf Verileri:</strong> Kumardan uzak kaldığınız gün sayısı, başlangıç tarihiniz ve kurtarılan para birikiminiz yalnızca cihazınızın yerel belleğinde (Local Storage / SharedPreferences) şifrelenmiş olarak saklanır.</li>
        <li><strong>Duygu Günlüğü ve Tetikleyici Kayıtları:</strong> Uygulama içerisine yazdığınız notlar ve tetikleyici analizleri tamamen cihazınızda kalır, hiçbir harici sunucuya iletilmez.</li>
        <li><strong>Kişisel Kimlik Bilgileri:</strong> Uygulamayı kullanmak için ad, soyad, T.C. kimlik numarası veya ev adresi gibi kişisel kimlik verilerini paylaşmanız gerekmez.</li>
      </ul>

      <h3 id="sec-3">3. Sistem Düzeyinde İzinler ve Kalkan İşleyişi</h3>
      <p>Nora'nın sunduğu kumar engelleme özellikleri (Katı Kalkan) için cihazınızda belirli izinler (Yerel VPN / DNS filtreleme veya Ekran Süresi API'leri) talep edilebilir:</p>
      <ul>
        <li>Bu filtreleme mekanizması yalnızca <strong>bilinen yasadışı bahis, casino, slot ve kumar sitelerine giden istekleri yerel olarak engellemek</strong> için kullanılır.</li>
        <li>Genel internet tarama geçmişiniz, ziyaret ettiğiniz diğer web siteleri veya mesajlaşmalarınız kesinlikle izlenmez, dinlenmez veya kaydedilmez.</li>
      </ul>

      <h3 id="sec-4">4. Abonelikler ve Ödeme Bilgileri</h3>
      <p>Nora VIP abonelik işlemleri Apple App Store (In-App Purchase) veya Google Play Store altyapısı üzerinden yürütülür. Kredi kartı, banka bilgileri veya fatura detaylarınız Nora geliştiricileri tarafından asla görülmez veya saklanmaz. Ödeme işlemleri doğrudan Apple Inc. ve Google LLC'nin güvenlik standartları altındadır.</p>

      <h3 id="sec-5">5. Anonim Analitikler ve Hata Raporlama</h3>
      <p>Uygulamanın kararlılığını sağlamak ve çökmeleri tespit etmek amacıyla anonimleştirilmiş teknik hata logları (Crashlytics) kullanılabilir. Bu loglar hiçbir kişisel veriyi veya kullanıcı kimliğini içermez.</p>

      <h3 id="sec-6">6. KVKK ve GDPR Kapsamındaki Haklarınız</h3>
      <p>6698 sayılı KVKK ve AB Genel Veri Koruma Tüzüğü (GDPR) kapsamında dilediğiniz zaman:</p>
      <ul>
        <li>Uygulama ayarlarından tüm verilerinizi sıfırlama ve silme,</li>
        <li>Uygulamayı cihazınızdan kaldırarak yerel verileri anında yok etme hakkına sahipsiniz.</li>
      </ul>

      <h3 id="sec-7">7. İletişim ve Veri Güvenliği Sorumlusu</h3>
      <p>Gizlilik politikamız ile ilgili tüm sorularınız için resmi destek e-posta adresimizden bize ulaşabilirsiniz: <a href="mailto:destek@noraapp.com" style="color:var(--primary); font-weight:700;">destek@noraapp.com</a></p>
    `,
    en: `
      <span class="legal-badge-pill">GDPR & CCPA COMPLIANT PRIVACY POLICY</span>
      <h2>Nora App Privacy Policy</h2>
      <p><strong>Effective Date:</strong> October 13, 2026 | <strong>Version:</strong> v1.0.0</p>
      
      <h3 id="sec-1">1. Introduction & Our Privacy Commitment</h3>
      <p>Nora ("Application", "We", "Developer") is dedicated to empowering individuals breaking free from gambling compulsions to reclaim their financial liberty and psychological well-being. We hold user confidentiality at our core. This Privacy Policy details the data collected, processed, and safeguarded when using Nora.</p>

      <h3 id="sec-2">2. Information We Handle & On-Device Storage</h3>
      <p>Nora adheres strictly to the "Privacy by Design" architecture:</p>
      <ul>
        <li><strong>Clean Streak & Savings Data:</strong> Days abstaining from gambling, start dates, and savings metrics are stored strictly within your device's local encrypted storage.</li>
        <li><strong>Trigger Journals & Mood Logs:</strong> Reflection notes and trigger logs remain entirely on your device. They are never transmitted to external cloud servers.</li>
        <li><strong>Zero Mandatory Personal IDs:</strong> No names, social security numbers, or physical addresses are required to benefit from Nora.</li>
      </ul>

      <h3 id="sec-3">3. System-Level Permissions & Shield Operation</h3>
      <p>To deliver blocking capabilities (Strict Shield), Nora may configure local DNS filtering, Screen Time frameworks, or on-device filtering profiles:</p>
      <ul>
        <li>This pipeline acts solely to <strong>divert and neutralize requests addressed to verified gambling, casino, sportsbook, and slot domains</strong>.</li>
        <li>Your general web browsing records, non-gambling internet history, and communications are never monitored, captured, or uploaded.</li>
      </ul>

      <h3 id="sec-4">4. Purchases & Subscription Data</h3>
      <p>Subscriptions to Nora VIP are processed through Apple App Store (In-App Purchases) or Google Play Store. We never receive, process, or hold payment card details. All financial transactions are secured by Apple Inc. and Google LLC.</p>

      <h3 id="sec-5">5. Anonymous Diagnostics</h3>
      <p>We may receive aggregated, anonymized crash reports to troubleshoot application faults. These logs do not contain user-identifiable records.</p>

      <h3 id="sec-6">6. Your Rights (GDPR & CCPA)</h3>
      <p>You maintain full ownership of your data at all times. You can erase all streak entries and reset local caches directly inside the app settings or by deleting the app.</p>

      <h3 id="sec-7">7. Contact & Security Office</h3>
      <p>For any privacy inquiries or legal correspondence: <a href="mailto:destek@noraapp.com" style="color:var(--primary); font-weight:700;">destek@noraapp.com</a></p>
    `
  },

  eula: {
    tr: `
      <span class="legal-badge-pill">APPLE STANDARD & NORA LİSANS SÖZLEŞMESİ</span>
      <h2>Son Kullanıcı Lisans Sözleşmesi (EULA)</h2>
      <p><strong>Yürürlük Tarihi:</strong> 13 Ekim 2026 | <strong>Son Güncelleme:</strong> v1.0.0</p>

      <h3 id="sec-1">1. Lisansın Verilmesi ve Taraflar</h3>
      <p>Bu Son Kullanıcı Lisans Sözleşmesi ("Sözleşme" veya "EULA"), Nora uygulamasını indiren, yükleyen veya kullanan gerçek kişi ("Kullanıcı") ile Nora geliştirici ekibi arasında akdedilmiştir. Uygulamayı indirerek bu sözleşmedeki şartları kabul etmiş sayılırsınız.</p>

      <h3 id="sec-2">2. TIBBİ VE KLİNİK FERAGATNAME (ÖNEMLİ BİLGİLENDİRME)</h3>
      <p style="background:rgba(239, 68, 68, 0.1); border-left:4px solid var(--error); padding:16px; border-radius:8px; color:var(--text-primary); line-height:1.7;">
        <strong>DİKKAT:</strong> Nora bir bilişsel farkındalık, alışkanlık takip ve dijital içerik engelleme aracıdır. <strong>Nora bir tıbbi cihaz, klinik psikiyatri tedavi merkezi veya hekim teşhis sistemi DEĞİLDİR.</strong> 
        Uygulama profesyonel psikiyatrik ya da tıbbi desteğin yerine geçmez. Ciddi patolojik kumar bağımlılığı veya ruhsal kriz hallerinde lütfen yetkili sağlık kurumlarına ya da ücretsiz Yeşilay YEDAM (115) danışma hattına başvurunuz.
      </p>

      <h3 id="sec-3">3. Lisans Kapsamı ve Kısıtlamalar</h3>
      <p>Kullanıcıya, Uygulamayı yalnızca kişisel, ticari olmayan amaçlarla kullanması için devredilemez, münhasır olmayan bir lisans verilmiştir. Kullanıcı şunları yapamaz:</p>
      <ul>
        <li>Uygulamanın kaynak kodunu decompile etmek, tersine mühendisliğe tabi tutmak veya türev ürünler oluşturmak,</li>
        <li>Kalkan engelleme mekanizmasını yasadışı amaçlarla tahrif etmek veya suistimal etmek.</li>
      </ul>

      <h3 id="sec-4">4. Abonelik Şartları ve Otomatik Yenileme</h3>
      <p>Nora, ücretsiz deneme süreleri ve haftalık/yıllık VIP abonelik modelleri sunabilir:</p>
      <ul>
        <li><strong>Otomatik Yenileme:</strong> Abonelik ücreti, mevcut abonelik döneminin bitiminden en az 24 saat önce iptal edilmediği sürece Apple App Store / Google Play hesabınız üzerinden otomatik olarak tahsil edilir.</li>
        <li><strong>İptal ve İadeler:</strong> Aboneliğinizi cihazınızın "Ayarlar > Apple Kimliği > Abonelikler" menüsünden dilediğiniz an sonlandırabilirsiniz. Geri ödeme talepleri ilgili mağazanın (Apple / Google) resmi iade politikalarına tabidir.</li>
      </ul>

      <h3 id="sec-5">5. Sorumluluğun Sınırlandırılması ve Garanti Reddi</h3>
      <p>Nora "Olduğu Gibi" (As-Is) ve "Mevcut Olduğu Şekilde" sağlanır. Geliştirici, kalkanın yüzde yüz kesintisiz çalışacağını veya kullanıcının kumar alışkanlığını kesin olarak sonlandıracağını yasal olarak garanti edemez. Uygulamanın kullanımından doğabilecek dolaylı kayıplardan geliştirici sorumlu tutulamaz.</p>

      <h3 id="sec-6">6. Fesih ve Değişiklikler</h3>
      <p>Kullanıcının bu sözleşme maddelerine aykırı davranması durumunda lisans derhal feshedilebilir. Geliştirici, bu şartları güncel mevzuat doğrultusunda revize etme hakkını saklı tutar.</p>

      <h3 id="sec-7">7. İletişim ve Lisans Danışma</h3>
      <p>Lisans koşulları ile ilgili sorularınız için resmi e-posta adresimizden bize ulaşabilirsiniz: <a href="mailto:destek@noraapp.com" style="color:var(--primary); font-weight:700;">destek@noraapp.com</a></p>
    `,
    en: `
      <span class="legal-badge-pill">APPLE STANDARD & NORA LICENSE AGREEMENT</span>
      <h2>End User License Agreement (EULA)</h2>
      <p><strong>Effective Date:</strong> October 13, 2026 | <strong>Version:</strong> v1.0.0</p>

      <h3 id="sec-1">1. Acknowledgment & Parties</h3>
      <p>This End User License Agreement ("Agreement" or "EULA") is entered into between you ("User") and Nora ("Developer"). By downloading, installing, or accessing the Application, you agree to be bound by the terms outlined herein.</p>

      <h3 id="sec-2">2. MEDICAL & PSYCHOLOGICAL DISCLAIMER (CRITICAL)</h3>
      <p style="background:rgba(239, 68, 68, 0.1); border-left:4px solid var(--error); padding:16px; border-radius:8px; color:var(--text-primary); line-height:1.7;">
        <strong>WARNING:</strong> Nora is a digital wellness companion, behavioral habit tracker, and domain blocking tool. <strong>Nora DOES NOT provide psychiatric therapy, clinical diagnoses, medical treatments, or professional addiction healthcare.</strong>
        If you are struggling with acute emotional distress, depression, or severe gambling disorder, please contact a licensed mental health clinician or certified helpline immediately.
      </p>

      <h3 id="sec-3">3. Scope of License & Restrictions</h3>
      <p>You are granted a non-exclusive, non-transferable, revocable license to use Nora solely for your personal, non-commercial purposes. You may not:</p>
      <ul>
        <li>Reverse engineer, disassemble, decompile, or attempt to extract source algorithms from the application,</li>
        <li>Circumvent or exploit protective shields for malicious or commercial distribution.</li>
      </ul>

      <h3 id="sec-4">4. Auto-Renewable Subscriptions & Billing</h3>
      <p>Nora offers optional premium tiers (Nora VIP):</p>
      <ul>
        <li><strong>Auto-Renewal:</strong> Subscription plans automatically renew unless auto-renew is cancelled at least 24 hours prior to the close of the billing cycle via your Apple/Google Store Settings.</li>
        <li><strong>Cancellations & Refunds:</strong> You can manage or terminate active subscriptions anytime in your device account settings. All refund disputes are adjudicated under Apple Media Services or Google Play terms.</li>
      </ul>

      <h3 id="sec-5">5. Limitation of Liability & Warranty Disclaimer</h3>
      <p>The Application is provided "As Is" and "As Available" without express warranties of any kind. The Developer does not guarantee unhindered barrier permanence or specific personal recovery outcomes.</p>

      <h3 id="sec-6">6. Termination</h3>
      <p>Your license shall terminate immediately upon failure to comply with any provision of this agreement.</p>

      <h3 id="sec-7">7. Legal Contact</h3>
      <p>For legal or licensing queries: <a href="mailto:destek@noraapp.com" style="color:var(--primary); font-weight:700;">destek@noraapp.com</a></p>
    `
  }
};

const subpageTranslations = {
  tr: {
    // Nav
    navFeatures: "Özellikler",
    navCalculator: "Tasarruf Hesaplayıcı",
    navSOS: "Dürtü Sörfü",
    navSupport: "Destek",
    navPrivacy: "Gizlilik",
    navEULA: "EULA",
    navHomeBtn: "Ana Sayfaya Dön",
    langBtn: "EN",

    // Breadcrumbs base
    bcHome: "Ana Sayfa",
    bcLegal: "Hukuki",
    bcHelp: "Yardım",
    bcApp: "Uygulama",

    // Footer
    footerDesc: "Nora, kumar bağımlılığını geride bırakmak, cebindeki parayı korumak ve huzurlu bir hayata adım atmak isteyen herkes için geliştirilmiş tavizsiz koruma kalkanıdır.",
    footerColQuick: "Hızlı Bağlantılar",
    footerColLegal: "Hukuki",
    footerColSupport: "Destek & Kriz",
    footerRights: "© 2026 Nora App. Tüm hakları saklıdır.",
    footerMedicalNote: "Yasal Uyarı: Nora bir davranışsal ve teknolojik kalkan aracıdır; klinik tıbbi teşhis veya psikiyatri tedavi hizmeti yerine geçmez.",
    flFeatures: "Özellikler",
    flCalc: "Tasarruf Hesaplayıcı",
    flSOS: "Dürtü Sörfü SOS",
    flFAQ: "Sıkça Sorulan Sorular",
    flPrivacy: "Gizlilik Politikası (Privacy)",
    flEULA: "Son Kullanıcı Lisansı (EULA)",
    flCompliance: "KVKK & GDPR Uyumluluğu",
    flSupport: "Destek Masası",
    flYEDAM: "Yeşilay YEDAM (115)",
    flTerms: "Kullanım Koşulları & İptal",
    flGamcare: "GamCare Uluslararası",
    botPrivacy: "Gizlilik",
    botEula: "EULA",
    botSupport: "Destek",

    // Privacy Page
    privacyTitle: "Gizlilik Politikası",
    privacySubtitle: "Nora, mahremiyetinizi en üst seviyede tutar. Verileriniz asla satılmaz, kumar kayıtlarınız cihazınızda şifrelenir.",
    privacySideTitle: "Maddeler",
    privacySide1: "1. Veri Sorumlusu Taahhüdü",
    privacySide2: "2. Cihazda Yerel Saklama",
    privacySide3: "3. Sistem İzinleri & DNS",
    privacySide4: "4. Abonelik ve Ödemeler",
    privacySide5: "5. Anonim Analitikler",
    privacySide6: "6. KVKK ve GDPR Hakları",
    privacySide7: "7. İletişim & Destek",
    privacySideEula: "› EULA Sözleşmesine Git",
    privacySideSupport: "› Destek Masasına Git",

    // EULA Page
    eulaTitle: "Lisans Sözleşmesi (EULA)",
    eulaSubtitle: "Apple Standard EULA ve Nora lisans koşulları, otomatik yenilenen abonelik şartları ve tıbbi feragatname.",
    eulaSideTitle: "Maddeler",
    eulaSide1: "1. Lisansın Verilmesi",
    eulaSide2: "2. Tıbbi Feragatname (Önemli)",
    eulaSide3: "3. Kapsam ve Kısıtlamalar",
    eulaSide4: "4. Abonelik ve İptaller",
    eulaSide5: "5. Garanti Reddi",
    eulaSide6: "6. Fesih ve Değişiklikler",
    eulaSide7: "7. Hukuki İletişim",
    eulaSidePrivacy: "› Gizlilik Politikasına Git",
    eulaSideSupport: "› Destek Masasına Git",

    // Support Page
    supportTitle: "Destek & Kriz Merkezi",
    supportSubtitle: "Biz buradayız, bu yolda asla yalnız değilsin. Teknik yardım, site bildirimleri veya acil danışmanlık için bize dilediğin an ulaşabilirsin.",
    supportHelplinesTitle: "Acil Yardım & Kriz Hatları",
    hotline1Badge: "7/24 ÜCRETSİZ & GİZLİ DANIŞMANLIK HATTI (TÜRKİYE)",
    hotline1Phone: "115 (YEDAM)",
    hotline1Desc: "Yeşilay Danışmanlık Merkezi; uzman klinik psikologlar ve sosyal hizmet uzmanları eşliğinde kumar bağımlılığıyla mücadele eden bireylere ve ailelerine tamamen ücretsiz, şartsız ve gizli psikososyal destek sunar.",
    hotline1CallBtn: "📞 Hemen 115'i Ara (Ücretsiz)",
    hotline2Badge: "ULUSLARARASI DESTEK (GLOBAL SUPPORT)",
    hotline2Desc: "Dünya çapında 24 saat canlı destek grupları, bağımlılık danışmanlık forumları ve ücretsiz yardım hatları:",
    hotline2UK: "İngiltere / Avrupa:",
    hotline2US: "ABD / Global:",
    emailBoxTitle: "📧 Doğrudan Destek E-postası",
    emailBoxDesc: "Uygulama teknik sorunları, engellenmeyen yeni bahis alan adı bildirimleri ve fatura/abonelik soruları için:",
    emailBoxNote: "* Destek ekibimiz e-postaları 24 saat içinde yanıtlamaktadır.",
    formBoxTitle: "Destek Talebi Gönder",
    formBoxDesc: "Lütfen sorununuzu veya geri bildiriminizi bize iletin.",
    lblName: "Adınız / Takma Adınız",
    namePlaceholder: "Örn: Deniz",
    lblEmail: "E-posta Adresiniz",
    lblCat: "Konu Seçiniz",
    optTech: "Teknik Sorun & Hata Bildirimi",
    optBlock: "Engellenmeyen Bahis Sitesi Bildir",
    optSub: "Abonelik & Fatura Sorusu",
    optGen: "Genel Öneri & Geri Bildirim",
    lblMsg: "Mesajınız",
    msgPlaceholder: "Yaşadığınız durumu veya bildirmek istediğiniz siteyi detaylandırın...",
    btnSubmit: "Mesajı Gönder",
    formSuccess: "✓ Mesajınız alındı! Destek ekibimiz en geç 24 saat içinde e-posta adresinize dönüş yapacaktır.",
    adviceTitle: "💡 Kriz Anında Ne Yapmalısın?",
    adviceDesc: "Ani bir kumar isteği duyuyorsan ana sayfadaki <strong>Dürtü Sörfü</strong> nefes aracını aç. 4 saniye nefes al, 4 saniye tut, 4 saniye ver. Beynindeki dopamin fırtınası ortalama 12 dakika içinde sönecektir.",

    // Download & Mobile Page
    downloadTitle: "Web Kalkanı Çok Yakında Hizmetinizde!",
    downloadSubtitle: "Nora'nın tavizsiz engelleme ve katı koruma mekanizması şu anda yalnızca mobil platformlarda (iOS ve Android) tam sistem entegrasyonuyla aktiftir. Cebindeki parayı ve huzurunu korumak için Nora'yı hemen telefonuna indirebilirsin.",
    downloadHeroBadge: "🚀 WEB SÜRÜMÜ ÇOK YAKINDA • ŞU AN MOBİLDE AKTİF",
    bcDownload: "Uygulamayı İndir",
    iosCardBadge: "iOS İÇİN AKTİF",
    iosCardTitle: "Apple App Store",
    iosCardCompat: "iOS 16.0 veya üzeri • iPhone & iPad Uyumlu",
    iosCardBtn: "App Store'dan İndir",
    androidCardBadge: "ANDROID İÇİN AKTİF",
    androidCardTitle: "Google Play Store",
    androidCardCompat: "Android 9.0 veya üzeri • Tüm Telefon & Tabletler",
    androidCardBtn: "Google Play'den İndir",
    scanQrHint: "📱 Kameranla Tara ve Anında İndir",
    whyMobileHead: "Neden Şu Anda Sadece Mobilde Aktif?",
    why1Title: "🛡️ Sistem Düzeyinde Katı Kalkan",
    why1Desc: "Kumar sitelerini ve casino uygulamalarını tamamen engelleyebilmek için iOS ve Android'in yerel DNS ve Ekran Süresi çekirdeğine entegre çalışıyoruz.",
    why2Title: "⏱️ 7/24 Yanında & En Zayıf Anlarında",
    why2Desc: "Kumar dürtüsü en çok yalnız, yatakta veya stresli anlarda telefonda ortaya çıkar. Nora, zayıf anında anında devreye girerek paranı korur.",
    why3Title: "🔒 Bypass Edilemez Güvenlik PIN'i",
    why3Desc: "Anlık krizlerde kalkanı devre dışı bırakmayı veya uygulamayı kaldırmayı engelleyen özel güvenlik gecikmesi ve koruma mekanizması.",
    earlyAccessHead: "Web Kalkanı Çıktığında İlk Senin Haberin Olsun",
    earlyAccessSub: "Chrome, Safari, macOS ve Windows için geliştirdiğimiz web engelleme uzantısı tamamlandığında erken erişim davetiyesi almak için e-postanı bırak.",
    earlyAccessPlaceholder: "E-posta adresinizi giriniz...",
    earlyAccessBtn: "Bana Haber Ver",
    earlyAccessSuccess: "✓ Teşekkürler! Web kalkanı hazır olduğunda sana ilk davetiyeyi göndereceğiz."
  },

  en: {
    // Nav
    navFeatures: "Features",
    navCalculator: "Savings Vault",
    navSOS: "Urge Surfing",
    navSupport: "Support",
    navPrivacy: "Privacy",
    navEULA: "EULA",
    navHomeBtn: "Back to Home",
    langBtn: "TR",

    // Breadcrumbs base
    bcHome: "Home",
    bcLegal: "Legal",
    bcHelp: "Help",
    bcApp: "App",

    // Footer
    footerDesc: "Nora is the unyielding digital shield built for anyone looking to break the gambling cycle, safeguard their wealth, and reclaim self-mastery.",
    footerColQuick: "Quick Links",
    footerColLegal: "Legal & Terms",
    footerColSupport: "Support & Crisis",
    footerRights: "© 2026 Nora App. All rights reserved.",
    footerMedicalNote: "Disclaimer: Nora is a behavioral habit tool and content filter; it is not a substitute for clinical psychological or psychiatric therapy.",
    flFeatures: "Features",
    flCalc: "Savings Vault",
    flSOS: "Urge Surfing SOS",
    flFAQ: "FAQ",
    flPrivacy: "Privacy Policy",
    flEULA: "End User License (EULA)",
    flCompliance: "GDPR & KVKK Compliance",
    flSupport: "Support Desk",
    flYEDAM: "YEDAM Hotline (115)",
    flTerms: "Terms of Use & Cancellation",
    flGamcare: "GamCare International",
    botPrivacy: "Privacy",
    botEula: "EULA",
    botSupport: "Support",

    // Privacy Page
    privacyTitle: "Privacy Policy",
    privacySubtitle: "Nora holds your confidentiality at highest standards. Data is never sold, records remain encrypted on your device.",
    privacySideTitle: "Sections",
    privacySide1: "1. Data Controller",
    privacySide2: "2. On-Device Storage",
    privacySide3: "3. System Permissions & DNS",
    privacySide4: "4. Subscriptions & Billing",
    privacySide5: "5. Anonymous Analytics",
    privacySide6: "6. GDPR & User Rights",
    privacySide7: "7. Contact & Security",
    privacySideEula: "› Go to EULA License",
    privacySideSupport: "› Go to Support Desk",

    // EULA Page
    eulaTitle: "End User License Agreement (EULA)",
    eulaSubtitle: "Apple Standard EULA and Nora license terms, auto-renewing subscription terms, and medical disclaimer.",
    eulaSideTitle: "Sections",
    eulaSide1: "1. Grant of License",
    eulaSide2: "2. Medical Disclaimer (Important)",
    eulaSide3: "3. Scope & Restrictions",
    eulaSide4: "4. Subscriptions & Cancellations",
    eulaSide5: "5. Warranty Disclaimer",
    eulaSide6: "6. Termination & Changes",
    eulaSide7: "7. Legal Contact",
    eulaSidePrivacy: "› Go to Privacy Policy",
    eulaSideSupport: "› Go to Support Desk",

    // Support Page
    supportTitle: "Support & Crisis Desk",
    supportSubtitle: "We are here, you are never alone. Reach us anytime for technical aid, reporting unblocked domains, or crisis counseling.",
    supportHelplinesTitle: "Emergency Helplines & Crisis Centers",
    hotline1Badge: "24/7 FREE & CONFIDENTIAL COUNSELING (TURKEY)",
    hotline1Phone: "115 (YEDAM)",
    hotline1Desc: "Green Crescent Counseling Center (YEDAM); provides free, anonymous, and confidential psychosocial counseling with clinical psychologists for gambling recovery.",
    hotline1CallBtn: "📞 Call 115 Helpline (Free)",
    hotline2Badge: "GLOBAL SUPPORT HELPLINES",
    hotline2Desc: "24/7 live international recovery groups, counseling chats, and hotlines worldwide:",
    hotline2UK: "UK / Europe:",
    hotline2US: "US / Global:",
    emailBoxTitle: "📧 Direct Support Email",
    emailBoxDesc: "For technical app issues, reporting unblocked betting domains, or billing inquiries:",
    emailBoxNote: "* Our support team replies within 24 hours.",
    formBoxTitle: "Submit Support Ticket",
    formBoxDesc: "Please share your issue or feedback with us.",
    lblName: "Your Name / Alias",
    namePlaceholder: "e.g. Alex",
    lblEmail: "Email Address",
    lblCat: "Select Category",
    optTech: "Technical Issue / App Bug",
    optBlock: "Report Unblocked Gambling Site",
    optSub: "Subscription & Billing Question",
    optGen: "General Inquiries & Feedback",
    lblMsg: "Your Message",
    msgPlaceholder: "Please describe the situation or domain you wish to report...",
    btnSubmit: "Send Message",
    formSuccess: "✓ Message received! Our support team will reply to your email within 24 hours.",
    adviceTitle: "💡 What to Do in Acute Craving?",
    adviceDesc: "If you feel an acute urge, open the <strong>Urge Surfing</strong> tool on the homepage. Inhale 4s, hold 4s, exhale 4s. The dopamine surge naturally subsides within 10-15 minutes.",

    // Download & Mobile Page
    downloadTitle: "Web Shield Coming Soon!",
    downloadSubtitle: "Nora's uncompromising strict barrier is currently active exclusively on mobile platforms (iOS & Android) with full system-level integration. Download Nora to your mobile device today to safeguard your wealth and peace of mind.",
    downloadHeroBadge: "🚀 WEB SHIELD COMING SOON • CURRENTLY ACTIVE ON MOBILE",
    bcDownload: "Download App",
    iosCardBadge: "ACTIVE FOR iOS",
    iosCardTitle: "Apple App Store",
    iosCardCompat: "Requires iOS 16.0 or later • iPhone & iPad",
    iosCardBtn: "Download on App Store",
    androidCardBadge: "ACTIVE FOR ANDROID",
    androidCardTitle: "Google Play Store",
    androidCardCompat: "Requires Android 9.0 or later • Phones & Tablets",
    androidCardBtn: "Get it on Google Play",
    scanQrHint: "📱 Scan with Camera to Download",
    whyMobileHead: "Why Is Nora Currently Mobile-First?",
    why1Title: "🛡️ System-Level Strict Protection",
    why1Desc: "To strictly eliminate gambling domains and casino apps, Nora deeply integrates into native iOS and Android DNS and Screen Time kernels.",
    why2Title: "⏱️ Always in Your Pocket",
    why2Desc: "Urges strike most when alone or stressed on your phone. Nora stands guard at your side 24/7 to safeguard your financial future.",
    why3Title: "🔒 Unbypassable PIN Protection",
    why3Desc: "Friction mechanisms and PIN security that prevent impulsive uninstallation or barrier deactivation during acute craving episodes.",
    earlyAccessHead: "Be Notified When Web Shield Launches",
    earlyAccessSub: "Leave your email to receive early access invitation when our Chrome, Safari, macOS and Windows web extension is ready.",
    earlyAccessPlaceholder: "Enter your email address...",
    earlyAccessBtn: "Notify Me",
    earlyAccessSuccess: "✓ Thank you! We will send you an exclusive early access invite as soon as the Web Shield goes live."
  }
};

let currentLang = 'tr';

function setTxt(id, val) {
  const el = document.getElementById(id);
  if (el) el.textContent = val;
}

function setHTML(id, val) {
  const el = document.getElementById(id);
  if (el) el.innerHTML = val;
}

function applyLanguage(lang) {
  currentLang = lang;
  document.documentElement.setAttribute('lang', lang);
  localStorage.setItem('nora-lang', lang);
  const t = subpageTranslations[lang];

  // Common Header Nav
  setTxt('subnav-features', t.navFeatures);
  setTxt('subnav-calc', t.navCalculator);
  setTxt('subnav-sos', t.navSOS);
  setTxt('subnav-support', t.navSupport);
  setTxt('subnav-privacy', t.navPrivacy);
  setTxt('subnav-eula', t.navEULA);
  setTxt('subnav-home-btn', t.navHomeBtn);
  setTxt('lang-btn-text', t.langBtn);

  // Common Breadcrumbs
  setTxt('bc-home', t.bcHome);

  // Common Footer
  setTxt('footer-desc', t.footerDesc);
  setTxt('footer-col-quick', t.footerColQuick);
  setTxt('footer-col-legal', t.footerColLegal);
  setTxt('footer-col-support', t.footerColSupport);
  setTxt('footer-rights', t.footerRights);
  setTxt('footer-medical-note', t.footerMedicalNote);
  setTxt('fl-features', t.flFeatures);
  setTxt('fl-calc', t.flCalc);
  setTxt('fl-sos', t.flSOS);
  setTxt('fl-faq', t.flFAQ);
  setTxt('fl-privacy', t.flPrivacy);
  setTxt('fl-eula', t.flEULA);
  setTxt('fl-compliance', t.flCompliance);
  setTxt('fl-support', t.flSupport);
  setTxt('fl-yedam', t.flYEDAM);
  setTxt('fl-terms', t.flTerms);
  setTxt('fl-gamcare', t.flGamcare);
  setTxt('footer-bot-privacy', t.botPrivacy);
  setTxt('footer-bot-eula', t.botEula);
  setTxt('footer-bot-support', t.botSupport);

  // Detect which subpage we are on
  const path = window.location.pathname.toLowerCase();
  const isPrivacy = path.includes('privacy');
  const isEula = path.includes('eula');
  const isSupport = path.includes('support');
  const isDownload = path.includes('download');

  if (isPrivacy) {
    setTxt('bc-cat', t.bcLegal);
    setTxt('bc-current', t.privacyTitle);
    setTxt('page-title-text', t.privacyTitle);
    setTxt('page-subtitle-text', t.privacySubtitle);
    setTxt('side-title', t.privacySideTitle);
    setTxt('side-1', t.privacySide1);
    setTxt('side-2', t.privacySide2);
    setTxt('side-3', t.privacySide3);
    setTxt('side-4', t.privacySide4);
    setTxt('side-5', t.privacySide5);
    setTxt('side-6', t.privacySide6);
    setTxt('side-7', t.privacySide7);
    setTxt('side-link-eula', t.privacySideEula);
    setTxt('side-link-support', t.privacySideSupport);

    // Invalidate and inject privacy legal content
    setHTML('legal-content-target', legalDocuments.privacy[lang]);
  } else if (isEula) {
    setTxt('bc-cat', t.bcLegal);
    setTxt('bc-current', t.eulaTitle);
    setTxt('page-title-text', t.eulaTitle);
    setTxt('page-subtitle-text', t.eulaSubtitle);
    setTxt('side-title', t.eulaSideTitle);
    setTxt('side-1', t.eulaSide1);
    setTxt('side-2', t.eulaSide2);
    setTxt('side-3', t.eulaSide3);
    setTxt('side-4', t.eulaSide4);
    setTxt('side-5', t.eulaSide5);
    setTxt('side-6', t.eulaSide6);
    setTxt('side-7', t.eulaSide7);
    setTxt('side-link-privacy', t.eulaSidePrivacy);
    setTxt('side-link-support', t.eulaSideSupport);

    // Invalidate and inject EULA legal content
    setHTML('legal-content-target', legalDocuments.eula[lang]);
  } else if (isSupport) {
    setTxt('bc-cat', t.bcHelp);
    setTxt('bc-current', t.supportTitle);
    setTxt('page-title-text', t.supportTitle);
    setTxt('page-subtitle-text', t.supportSubtitle);
    setTxt('support-sec-helplines-title', t.supportHelplinesTitle);
    setTxt('hotline1-badge', t.hotline1Badge);
    setTxt('hotline1-phone', t.hotline1Phone);
    setTxt('hotline1-desc', t.hotline1Desc);
    setTxt('hotline1-call-btn', t.hotline1CallBtn);
    setTxt('hotline2-badge', t.hotline2Badge);
    setTxt('hotline2-desc', t.hotline2Desc);
    setTxt('hotline2-uk', t.hotline2UK);
    setTxt('hotline2-us', t.hotline2US);
    setTxt('email-box-title', t.emailBoxTitle);
    setTxt('email-box-desc', t.emailBoxDesc);
    setTxt('email-box-note', t.emailBoxNote);
    setTxt('form-box-title', t.formBoxTitle);
    setTxt('form-box-desc', t.formBoxDesc);
    setTxt('lbl-name', t.lblName);
    const nameInput = document.getElementById('input-name');
    if (nameInput) nameInput.placeholder = t.namePlaceholder;
    setTxt('lbl-email', t.lblEmail);
    setTxt('lbl-cat', t.lblCat);
    setTxt('opt-tech', t.optTech);
    setTxt('opt-block', t.optBlock);
    setTxt('opt-sub', t.optSub);
    setTxt('opt-gen', t.optGen);
    setTxt('lbl-msg', t.lblMsg);
    const msgInput = document.getElementById('input-msg');
    if (msgInput) msgInput.placeholder = t.msgPlaceholder;
    setTxt('btn-submit', t.btnSubmit);
    setTxt('advice-title', t.adviceTitle);
    setHTML('advice-desc', t.adviceDesc);
  } else if (isDownload) {
    setTxt('bc-cat', t.bcApp);
    setTxt('bc-current', t.bcDownload);
    setTxt('download-hero-badge', t.downloadHeroBadge);
    setTxt('page-title-text', t.downloadTitle);
    setTxt('page-subtitle-text', t.downloadSubtitle);
    setTxt('ios-card-badge', t.iosCardBadge);
    setTxt('ios-card-title', t.iosCardTitle);
    setTxt('ios-card-compat', t.iosCardCompat);
    setTxt('ios-card-btn-text', t.iosCardBtn);
    setTxt('ios-scan-hint', t.scanQrHint);
    setTxt('android-card-badge', t.androidCardBadge);
    setTxt('android-card-title', t.androidCardTitle);
    setTxt('android-card-compat', t.androidCardCompat);
    setTxt('android-card-btn-text', t.androidCardBtn);
    setTxt('android-scan-hint', t.scanQrHint);
    setTxt('why-mobile-head', t.whyMobileHead);
    setTxt('why1-title', t.why1Title);
    setTxt('why1-desc', t.why1Desc);
    setTxt('why2-title', t.why2Title);
    setTxt('why2-desc', t.why2Desc);
    setTxt('why3-title', t.why3Title);
    setTxt('why3-desc', t.why3Desc);
    setTxt('early-access-head', t.earlyAccessHead);
    setTxt('early-access-sub', t.earlyAccessSub);
    const earlyInput = document.getElementById('early-email-input');
    if (earlyInput) earlyInput.placeholder = t.earlyAccessPlaceholder;
    setTxt('early-access-btn-text', t.earlyAccessBtn);
  }
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
  // 1. Restore theme
  const savedTheme = localStorage.getItem('nora-theme') || 'light';
  document.documentElement.setAttribute('data-theme', savedTheme);
  const icon = document.getElementById('theme-icon');
  if (icon) icon.textContent = savedTheme === 'dark' ? '🌙' : '☀️';

  // 2. Restore saved language across all pages
  const savedLang = localStorage.getItem('nora-lang') || 'tr';
  applyLanguage(savedLang);

  // Theme toggle listener
  const themeBtn = document.getElementById('theme-toggle-btn');
  if (themeBtn) themeBtn.addEventListener('click', toggleTheme);

  // Lang switch listener
  const langBtn = document.getElementById('lang-switch-btn');
  if (langBtn) {
    langBtn.addEventListener('click', () => {
      const nextLang = currentLang === 'tr' ? 'en' : 'tr';
      applyLanguage(nextLang);
    });
  }

  // Mobile menu toggle
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

  // Subpage Support Form
  const subpageForm = document.getElementById('support-subpage-form');
  if (subpageForm) {
    subpageForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const status = document.getElementById('subpage-form-status');
      if (status) {
        status.textContent = subpageTranslations[currentLang].formSuccess;
        status.className = 'form-status-msg success';
        subpageForm.reset();
        setTimeout(() => {
          status.style.display = 'none';
        }, 8000);
      }
    });
  }

  // Early Access Form on Download Page
  const earlyForm = document.getElementById('early-access-form');
  if (earlyForm) {
    earlyForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const status = document.getElementById('early-status-msg');
      if (status) {
        status.textContent = subpageTranslations[currentLang].earlyAccessSuccess;
        status.className = 'form-status-msg success';
        earlyForm.reset();
        setTimeout(() => {
          status.style.display = 'none';
        }, 8000);
      }
    });
  }
});
