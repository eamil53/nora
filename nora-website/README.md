# Nora - Resmi Tanıtım Web Sitesi (Landing Page)

Nora mobil uygulamasının (Kumarı Bırak & Paran Sakla) resmi vitrin, tanıtım ve yasal dokümantasyon web sitesidir.

## 🌟 Öne Çıkan Özellikler

1. **Lüks & Modern Tasarım (Mürekkep & Mühür / OLED Dark & Crisp Light):**
   - Nora'nın mobil tasarım sistemine ve marka kimliğine sadık kalan koyu/aydınlık tema desteği.
   - Akıcı cam efekti (Glassmorphism), özel ışıltı efektleri ve mikro animasyonlar.
   - Google Fonts (Outfit & Plus Jakarta Sans) tipografisi.

2. **İnteraktif Finansal Tasarruf Hesaplayıcısı (Savings Vault):**
   - Kullanıcının aylık kumar kaybına göre 1 ay, 1 yıl ve 5 yılda kurtaracağı tutarı hesaplayan canlı kaydırıcı.
   - TRY (₺) ve USD ($) para birimi desteği ve gerçek hayat kıyaslama kartları.

3. **İnteraktif Dürtü Sörfü (Urge Surfing) Simülatörü:**
   - Kriz anında dopamin dalgasını yatıştıran rehberli nefes döngüsü (Nefes Al, Tut, Ver) ve interaktif seans başlatıcı.

4. **Kapsamlı Yasal Uyumluluk (Legal & Compliance):**
   - **Gizlilik Politikası (Privacy Policy):** KVKK ve GDPR uyumlu, cihazda yerel şifreleme ve sıfır veri satışı garantisi.
   - **Son Kullanıcı Lisans Sözleşmesi (EULA):** Apple Standard EULA ve Nora lisans koşulları, otomatik yenileme şartları ve **Tıbbi Feragatname (Medical Disclaimer)**.
   - **Destek Merkezi & Acil Yardım:** Canlı destek formu, 7/24 Yeşilay YEDAM (115) ve GamCare acil kriz hatları ile doğrudan e-posta desteği (`destek@noraapp.com`).

5. **Çoklu Dil Desteği:**
   - Türkçe (TR) ve İngilizce (EN) arasında anında geçiş sağlayan reaktif dil motoru.

---

## 🚀 Yerel Olarak Çalıştırma

Geliştirme sunucusunu başlatmak için:

```bash
cd nora-website
npm install
npm run dev
```

Sunucu varsayılan olarak `http://localhost:5173` adresinde çalışır.

---

## 📦 Prodüksiyon Derlemesi (Build)

```bash
npm run build
```

Derlenen statik dosyalar `dist/` klasörüne çıkarılır ve Vercel, Netlify, Cloudflare Pages veya Firebase Hosting gibi herhangi bir statik sunucuda doğrudan yayınlanabilir.

---

## 📁 Proje Dizin Yapısı

```
nora-website/
├── index.html              # Ana HTML, SEO etiketleri ve sayfa bileşenleri
├── package.json            # Proje bağımlılıkları ve Vite betikleri
├── public/
│   └── images/             # Nora logo, animasyon ve tanıtım görselleri
├── src/
│   ├── style.css           # Vanilla CSS tasarım sistemi (Dark/Light token'ları)
│   └── main.js             # Çoklu dil (TR/EN), hesaplayıcı, modal ve nefes mantığı
└── dist/                   # Optimize edilmiş üretim çıktısı
```
