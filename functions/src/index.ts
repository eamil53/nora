import * as admin from "firebase-admin";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import { onDocumentCreated, onDocumentUpdated } from "firebase-functions/v2/firestore";

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();

// Timezone for Istanbul / Turkey schedules
const TIMEZONE = "Europe/Istanbul";

interface CampaignConfig {
  campaignId: string;
  titleTr: string;
  bodyTr: string;
  titleEn: string;
  bodyEn: string;
  offerType: string;
  discountCode?: string;
}

/**
 * Sends campaign notifications to localized non-premium topics and records the dispatch metrics in Firestore.
 */
async function sendCampaignPush(config: CampaignConfig): Promise<{ success: boolean; message: string }> {
  const { campaignId, titleTr, bodyTr, titleEn, bodyEn, offerType, discountCode } = config;
  const now = admin.firestore.FieldValue.serverTimestamp();

  try {
    // 1. Send to Turkish non-premium users
    const trMessage: admin.messaging.Message = {
      topic: "non_premium_tr",
      notification: {
        title: titleTr,
        body: bodyTr,
      },
      data: {
        screen: "paywall",
        campaign_id: campaignId,
        offer_type: offerType,
        ...(discountCode ? { discount_code: discountCode } : {}),
        sent_at: new Date().toISOString(),
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    };

    // 2. Send to English non-premium users
    const enMessage: admin.messaging.Message = {
      topic: "non_premium_en",
      notification: {
        title: titleEn,
        body: bodyEn,
      },
      data: {
        screen: "paywall",
        campaign_id: campaignId,
        offer_type: offerType,
        ...(discountCode ? { discount_code: discountCode } : {}),
        sent_at: new Date().toISOString(),
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    };

    const [trResponse, enResponse] = await Promise.all([
      messaging.send(trMessage).catch((e) => `TR Error: ${e}`),
      messaging.send(enMessage).catch((e) => `EN Error: ${e}`),
    ]);

    // 3. Atomically update or create campaign metadata and dispatch counter in Firestore
    const campaignRef = db.collection("notification_campaigns").doc(campaignId);
    await campaignRef.set(
      {
        campaignId,
        titleTr,
        bodyTr,
        titleEn,
        bodyEn,
        offerType,
        lastSentAt: now,
        totalSentDispatches: admin.firestore.FieldValue.increment(1),
        updatedAt: now,
      },
      { merge: true }
    );

    console.log(`[FCM Campaign: ${campaignId}] Dispatched successfully. TR: ${trResponse}, EN: ${enResponse}`);
    return {
      success: true,
      message: `Dispatched campaign ${campaignId}. TR: ${trResponse}, EN: ${enResponse}`,
    };
  } catch (error) {
    console.error(`[FCM Campaign Error: ${campaignId}]`, error);
    return {
      success: false,
      message: `Failed to dispatch campaign ${campaignId}: ${error}`,
    };
  }
}

// ======================================================================
// 🌅 1. GÜNLÜK SABAH MOTİVASYON BİLDİRİMİ (Her Gün 10:00)
// Güne umutla, temiz bir sayfa ve Nora desteğiyle başlama mesajları
// ======================================================================

const MORNING_MESSAGES: { [day: number]: { tr: [string, string]; en: [string, string] } } = {
  // Pazar (0)
  0: {
    tr: [
      "🌟 Kendinle Gurur Duy: Bir Günü Daha Temiz Yaşa",
      "Günaydın. Dün ne yaşandıysa geride kaldı. Bugün sevdiklerinle huzurlu, kumarsız bir pazar geçir. Nora yanında.",
    ],
    en: [
      "🌟 Be Proud: Live Another Day Clean",
      "Good morning. Leave the past behind. Spend a peaceful, gamble-free Sunday today. Nora is with you.",
    ],
  },
  // Pazartesi (1)
  1: {
    tr: [
      "🌅 Yeni Bir Hafta, Temiz Bir Başlangıç",
      "Günaydın. Yeni haftaya temiz ve güçlü bir adımla başla. Geçmiş kayıpları unut; bu haftayı birlikte kazanacağız.",
    ],
    en: [
      "🌅 New Week, Fresh Clean Start",
      "Good morning. Begin the new week strong and clear. Forget past losses; we will overcome this together.",
    ],
  },
  // Salı (2)
  2: {
    tr: [
      "☀️ Sadece Bugüne Odaklan",
      "Bir ömrü değil, sadece bugünü kumarsız geçirmeyi hedefle. Tek bir temiz gün bile büyük bir zaferdir. Yanındayız.",
    ],
    en: [
      "☀️ Focus Just on Today",
      "Don't worry about forever; just focus on staying clean today. Every clean day is a massive victory.",
    ],
  },
  // Çarşamba (3)
  3: {
    tr: [
      "💪 Hafta Ortası Gücü: Yalnız Değilsin",
      "Zorlandığın anlar olabilir, bu çok doğal. Asla pes etme; bu mücadeleyi seninle birlikte veriyoruz.",
    ],
    en: [
      "💪 Mid-Week Strength: You're Not Alone",
      "Tough moments are normal. Never give up; we are fighting this battle right alongside you.",
    ],
  },
  // Perşembe (4)
  4: {
    tr: [
      "🌱 Geleceğini ve Sevdiklerini Koru",
      "Kumara vermediğin her kuruş, ailene ve yarınlarına kattığın bir değerdir. Gücünü hatırla, biz buradayız.",
    ],
    en: [
      "🌱 Protect Your Future and Loved Ones",
      "Every penny kept from gambling is an investment in your loved ones. Remember your strength.",
    ],
  },
  // Cuma (5)
  5: {
    tr: [
      "🛡️ Hafta Sonuna Güçlü Gir: Kalkanını Sıkı Tut",
      "Cuma geldi diye gardını düşürme. Bugün temiz kalmak hafta sonunu kurtarır. Nora kalkanına güven.",
    ],
    en: [
      "🛡️ Enter the Weekend Strong: Keep Your Guard",
      "Don't lower your defense on Friday. Staying clean today saves your whole weekend. Nora stands guard.",
    ],
  },
  // Cumartesi (6)
  6: {
    tr: [
      "☕ Huzurlu Bir Hafta Sonu Sabahı",
      "Kayıp stresi yok, vicdan azabı yok. Kumarsız bir sabahın huzurunu hisset. Biz her an yanındayız.",
    ],
    en: [
      "☕ Peaceful Weekend Morning",
      "No regret, no loss anxiety. Savor the peace of a gamble-free morning. We're right here with you.",
    ],
  },
};

export const scheduledDailyMorningSupport = onSchedule(
  {
    schedule: "0 10 * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    // Determine day of week in Turkey (0 = Sun, 1 = Mon ... 6 = Sat)
    const nowTr = new Date(new Date().toLocaleString("en-US", { timeZone: TIMEZONE }));
    const day = nowTr.getDay();
    const message = MORNING_MESSAGES[day] || MORNING_MESSAGES[1];

    await sendCampaignPush({
      campaignId: `daily_morning_day${day}`,
      titleTr: message.tr[0],
      bodyTr: message.tr[1],
      titleEn: message.en[0],
      bodyEn: message.en[1],
      offerType: "morning_solidarity",
    });
  }
);

// ======================================================================
// ☕ 2. GÜNLÜK ÖĞLEDEN SONRA / GÜN ORTASI YOLDAŞI (Her Gün 15:30)
// Can sıkıntısı, yorgunluk ve gün içi ani dürtülere karşı destek mesajları
// ======================================================================

const AFTERNOON_MESSAGES: { [day: number]: { tr: [string, string]; en: [string, string] } } = {
  0: {
    tr: [
      "📈 Emeğini ve Tasarrufunu Koru",
      "Cebinde kalan para senin alın terin. Birkaç dakikalık heyecan için emeğini sitelere kaptırma. Derin bir nefes al.",
    ],
    en: [
      "📈 Protect Your Hard Work & Savings",
      "The money in your pocket is your honest work. Don't trade it for minutes of false thrill. Breathe deeply.",
    ],
  },
  1: {
    tr: [
      "☕ Derin Bir Nefes Al: Kumar Bir Çözüm Değil",
      "Gün ortasında canın sıkılmış olabilir. Kumar dertleri çözmez, sadece yenilerini ekler. Yanındayız, dayanabilirsin.",
    ],
    en: [
      "☕ Take a Deep Breath: Gambling is Not a Solution",
      "Midday boredom or stress? Gambling never solves problems; it only multiplies them. Stay strong.",
    ],
  },
  2: {
    tr: [
      "🛑 Dürtü Mü Geldi? Sadece Birkaç Dakika Bekle",
      "Kumar isteği tıpkı bir dalga gibidir: gelir, yükselir ve söner. Bir bardak su iç, derin nefes al. Nora kalkanına tutun.",
    ],
    en: [
      "🛑 Feeling an Urge? Just Wait a Few Minutes",
      "Urges are like waves: they peak and fade. Drink some water, take a walk. Lean on your Nora shield.",
    ],
  },
  3: {
    tr: [
      "💎 En Değerli Şey Senin İç Huzurun",
      "Kumarda kazanılan para yoktur; sadece kaybedilen onur ve zaman vardır. Bugün huzurunu koru, Nora seninle.",
    ],
    en: [
      "💎 Your Peace of Mind is Priceless",
      "There is no money to be won in gambling; only peace and time to be lost. Guard your peace today.",
    ],
  },
  4: {
    tr: [
      "🤝 Yalnız Değilsin: Binlerce Kişi Bu Yolda",
      "Bu zorluğu aşmaya çalışan tek kişi sen değilsin. Hepimiz aynı yoldan geçtik. Başaracaksın, pes etme.",
    ],
    en: [
      "🤝 You're Not Alone: Thousands Walk This Road",
      "You are not the only one fighting this battle. Together we overcome. Keep pushing forward.",
    ],
  },
  5: {
    tr: [
      "⚽ Akşam Maçları Başlamadan Kalkanını Kilitle",
      "Heyecan ararken hayatını ateşe atma. İradene yük bindirme; tam kalkanı devreye sok, telefonun seni korusun.",
    ],
    en: [
      "⚽ Lock Your Shield Before Matches Begin",
      "Don't risk your life chasing adrenaline. Don't fight willpower alone; let Nora lock the gates for you.",
    ],
  },
  6: {
    tr: [
      "🎯 Neden Başladığını Hatırla",
      "Bu uygulamayı neden indirdiğini hatırla: Özgürlüğün ve ailen için. Şimdi o sitelere dur de, yanındayız.",
    ],
    en: [
      "🎯 Remember Why You Started",
      "Remember why you downloaded Nora: for your freedom and dignity. Say no to temptations; we stand with you.",
    ],
  },
};

export const scheduledDailyAfternoonCompanion = onSchedule(
  {
    schedule: "30 15 * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    const nowTr = new Date(new Date().toLocaleString("en-US", { timeZone: TIMEZONE }));
    const day = nowTr.getDay();
    const message = AFTERNOON_MESSAGES[day] || AFTERNOON_MESSAGES[1];

    await sendCampaignPush({
      campaignId: `daily_afternoon_day${day}`,
      titleTr: message.tr[0],
      bodyTr: message.tr[1],
      titleEn: message.en[0],
      bodyEn: message.en[1],
      offerType: "afternoon_companion",
    });
  }
);

// ======================================================================
// 🌙 3. GÜNLÜK GECE KALKANI & NÖBET BİLDİRİMİ (Her Gün 21:45)
// Yalnızlık, gece casino dürtüleri ve en kırılgan anlara karşı kalkan mesajları
// ======================================================================

const NIGHT_MESSAGES: { [day: number]: { tr: [string, string]; en: [string, string] } } = {
  0: {
    tr: [
      "🌟 Haftayı Temiz Bitirdin, Gurur Duy",
      "Pazar gecesini kumarsız kapattın. Yeni haftaya temiz bir vicdanla uyanacaksın. Tam kalkanı açık tut, rahat uyu.",
    ],
    en: [
      "🌟 You Finished the Week Clean",
      "You closed Sunday gamble-free. You'll wake up to Monday with a clear conscience. Rest easy tonight.",
    ],
  },
  1: {
    tr: [
      "🌙 Geceyi Temiz Kapat: 'Tek Bir El' Fısıltısına Kanma",
      "Gece açılan o sekmeler sadece pişmanlık getirir. İradene yüklenme; Nora tam kalkanını tak, telefonun seni korusun.",
    ],
    en: [
      "🌙 Close Tonight Clean: Ignore 'Just One Bet'",
      "Late-night tabs bring only remorse. Don't fight fatigue; lock your full Nora shield and sleep in peace.",
    ],
  },
  2: {
    tr: [
      "🛡️ Gece Nöbeti: Sen Uyu, Nora Korur",
      "Gece gelen dürtüleri aşmanın yolu sitelere erişimi tamamen kesmektir. Premium kalkan ile tüm ayna siteleri kilitle.",
    ],
    en: [
      "🛡️ Night Watch: You Rest, Nora Guards",
      "The true way to conquer late urges is cutting off access. Shield all mirror sites with Nora Premium.",
    ],
  },
  3: {
    tr: [
      "🕊️ Yastığa Başını Huzurla Koy",
      "Kumarsız bir gecenin verdiği iç huzur hiçbir parayla satın alınamaz. Biz buradayız, bu gece de temiz kal.",
    ],
    en: [
      "🕊️ Rest Your Head with Pure Peace",
      "The peace of a gamble-free night cannot be bought. We are here with you; stay clean tonight.",
    ],
  },
  4: {
    tr: [
      "🔒 Gece Kalkanını Devreye Al",
      "Hafta sonu yaklaşırken gece dürtüleri artabilir. Kendine bir iyilik yap; kalkanını kilitle ve güvende kal.",
    ],
    en: [
      "🔒 Activate Your Night Shield",
      "As the weekend nears, night urges grow. Do yourself a favor; lock your shield and stay completely safe.",
    ],
  },
  5: {
    tr: [
      "🛑 Cuma Gecesi Tuzağına Düşme",
      "Maçlar bitti, casino siteleri çağırıyor olabilir. Bu tuzağa düşme. Nora yanında, tam kalkanı devreye al.",
    ],
    en: [
      "🛑 Don't Fall for the Friday Night Trap",
      "Matches are over, casino sites are tempting. Do not take the bait. Nora is right by your side.",
    ],
  },
  6: {
    tr: [
      "🌙 Cumartesi Gecesini Kurtar",
      "Haftanın en riskli gecesindeyiz. Tek bir tık haftalarca verilen emeği yakmasın. Nora ile zırhını tak, kazanan sen ol.",
    ],
    en: [
      "🌙 Save Your Saturday Night",
      "This is the highest risk night of the week. Don't let one click ruin weeks of hard work. Keep your shield tight.",
    ],
  },
};

export const scheduledDailyNightShield = onSchedule(
  {
    schedule: "45 21 * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    const nowTr = new Date(new Date().toLocaleString("en-US", { timeZone: TIMEZONE }));
    const day = nowTr.getDay();
    const message = NIGHT_MESSAGES[day] || NIGHT_MESSAGES[1];

    await sendCampaignPush({
      campaignId: `daily_night_day${day}`,
      titleTr: message.tr[0],
      bodyTr: message.tr[1],
      titleEn: message.en[0],
      bodyEn: message.en[1],
      offerType: "night_shield",
    });
  }
);

// ======================================================================
// ⚡ 4. HAFTA SONU & MAAŞ GÜNÜ KRİTİK TETİKLEYİCİLERİ
// ======================================================================

/**
 * Cuma 20:30 (Hafta Sonu Başlangıç Alarmı)
 */
export const scheduledFridayShieldPush = onSchedule(
  {
    schedule: "30 20 * * 5",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "weekend_shield_fri",
      titleTr: "🛑 Hafta Sonu Tuzağına Düşme",
      bodyTr: "Bu hafta sonu maçlar seni çağırmasın. Tam kalkanı kilitle, paran ve huzurun cebinde kalsın.",
      titleEn: "🛑 Don't Fall into the Weekend Trap",
      bodyEn: "Don't let weekend matches lure you in. Lock your full shield and keep your savings.",
      offerType: "weekend_shield",
    });
  }
);

/**
 * Cumartesi 23:15 (Gece Casino & Kayıp Telafisi Tuzağı)
 */
export const scheduledSaturdayNightPush = onSchedule(
  {
    schedule: "15 23 * * 6",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "night_casino_sat",
      titleTr: "🌙 Gece Açılan Casino Sekmelerine Dikkat",
      bodyTr: "Gece gelen 'kaybettiklerimi kurtarayım' hissi en büyük yalandır. Nora kalkanını kilitle, bu geceyi kurtar.",
      titleEn: "🌙 Guard Against Late-Night Loss Chasing",
      bodyEn: "Late-night chasing losses is a trap. Lock your Nora shield and rescue tonight.",
      offerType: "night_shield",
    });
  }
);

/**
 * Pazar 21:00 (Haftalık Muhasebe & Tasarruf Karşılaştırması)
 */
export const scheduledSundayReflectionPush = onSchedule(
  {
    schedule: "0 21 * * 0",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "sunday_reflection",
      titleTr: "📉 Bu Hafta Kumar Sitelerine Ne Kadar Gitti?",
      bodyTr: "Bir haftalık kumar harcaman, 1 yıllık Nora Premium'dan kat kat fazla. Bugün kumar döngüsünü tamamen kır.",
      titleEn: "📉 How Much Was Lost This Week?",
      bodyEn: "One week of gambling losses costs far more than 1 year of Nora. Break the cycle today.",
      offerType: "savings_shield",
    });
  }
);

/**
 * Her Ayın 1'i 11:00 (Maaş Günü Finansal Zırh)
 */
export const scheduledPayday1stPush = onSchedule(
  {
    schedule: "0 11 1 * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "payday_protection_1st",
      titleTr: "💰 Maaşın Masada Kalmasın",
      bodyTr: "Kazandığın emeği kumar sitelerine bağışlama. Nora ile finansal zırhını tak, ayın başında güvende kal.",
      titleEn: "💰 Protect Your Hard-Earned Paycheck",
      bodyEn: "Don't hand over your hard work to gambling sites. Shield your finances with Nora.",
      offerType: "salary_lock",
    });
  }
);

/**
 * Her Ayın 15'i 11:00 (Ay Ortası Maaş / Avans Koruması)
 */
export const scheduledPayday15thPush = onSchedule(
  {
    schedule: "0 11 15 * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "payday_protection_15th",
      titleTr: "🛡️ Ay Ortası Finansal Güvencen",
      bodyTr: "Ay ortasında gelen dürtüleri durdur. Nora kalkanını tam güç devrede tut, geleceğine sahip çık.",
      titleEn: "🛡️ Mid-Month Financial Guard",
      bodyEn: "Keep temptations at bay mid-month. Maintain your Nora shield at full strength.",
      offerType: "salary_lock",
    });
  }
);

// ======================================================================
// 💎 5. PREMIUM DÖNÜŞÜMÜ İÇİN İKNA EDİCİ KAMPANYALAR (NON-PREMIUM TOPICS)
// ======================================================================

/**
 * Salı 13:00 (Finansal Karşılaştırma & ROI Amorti Kampanyası)
 * Tek bir kupon veya canlı bahiste kaybedilen para ile 1 yıllık huzurun karşılaştırması
 */
export const scheduledRoiMathPush = onSchedule(
  {
    schedule: "0 13 * * 2",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "roi_math_tue",
      titleTr: "💰 Kumara 1 Saatte Verdiğin Para vs. 1 Yıllık Nora",
      bodyTr: "Tek bir bahiste saniyeler içinde giden binlerce lirayı hatırla. Nora Premium günlük sadece 9₺; cebindeki parayı, aileni ve huzurunu garanti altına alır. Kendine yatırım yap.",
      titleEn: "💰 Lost in 1 Bet vs. 1 Year of Nora",
      bodyEn: "Remember the thousands lost in seconds. Nora Premium costs just a tiny fraction of a bet to shield your savings and peace. Invest in your freedom.",
      offerType: "roi_math",
    });
  }
);

/**
 * Çarşamba 20:30 (Kayıp Telafisi "Zararı Çıkarayım" Tuzağı)
 * Kullanıcıların en çok para kaybettiği kayıp telafisi dürtüsüne karşı VIP kalkan iknası
 */
export const scheduledLossChasingPush = onSchedule(
  {
    schedule: "30 20 * * 3",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "loss_chasing_wed",
      titleTr: "🛑 \"Kaybettiğimi Kurtarayım\" En Büyük Yalandır",
      bodyTr: "O parayı kumar sitelerinden geri alamazsın; ama kalanını ve yarınını koruyabilirsin. Nora VIP Kalkanı ile tüm kapıları kilitle, döngüyü sonsuza dek kır.",
      titleEn: "🛑 \"Chasing Losses\" is the Biggest Trap",
      bodyEn: "You cannot win back lost money; but you can save your future. Lock all doors with Nora VIP Shield and break the cycle forever.",
      offerType: "loss_chasing_shield",
    });
  }
);

/**
 * Perşembe 22:30 (Gece Kırılganlığı ve Zayıf An Zırhı)
 * Gece irade yorulduğunda devreye giren tam otomatik VIP koruma
 */
export const scheduledNightWillpowerPush = onSchedule(
  {
    schedule: "30 22 * * 4",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "night_willpower_thu",
      titleTr: "🌙 İraden Gece 02:00'de Yorulur, Nora Yorulmaz",
      bodyTr: "Gündüz verilen sözler gece unutulabilir. Nora Premium senin yerine nöbet tutar; en zayıf anında bile sitelere erişimi imkansız kılar. Bu gece huzurla uyu.",
      titleEn: "🌙 Willpower Fails at 2 AM, Nora Never Sleeps",
      bodyEn: "Promises made by day fade at night. Nora Premium guards you 24/7, making temptations impossible even when you feel weak. Rest peacefully.",
      offerType: "night_willpower",
    });
  }
);

/**
 * Cumartesi 16:00 (Teknik Üstünlük: Dinamik Ayna Siteler ve Anti-Bypass)
 * Hafta sonu maç trafiği öncesinde yeni türeyen ayna sitelere karşı bulut koruması
 */
export const scheduledDynamicMirrorBlockPush = onSchedule(
  {
    schedule: "0 16 * * 6",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    await sendCampaignPush({
      campaignId: "dynamic_mirror_block_sat",
      titleTr: "⚡ Kumar Siteleri Her Gün Yeni Adres Açıyor",
      bodyTr: "Yeni açılan ayna siteler iradeni sınamasın. Nora VIP, dakikalar içinde güncellenen bulut kalkanıyla 10.000+ kumar adresini anında etkisiz hale getirir.",
      titleEn: "⚡ New Gambling Domains Appear Daily",
      bodyEn: "Don't let mirror sites bypass your limits. Nora VIP updates in real-time to block 10,000+ gambling domains instantly.",
      offerType: "dynamic_mirror_block",
    });
  }
);

/**
 * 🎯 Her Gün 12:00 (Yeni İndiren Kullanıcılar İçin Yaşam Döngüsü Drip Bildirimi)
 * Uygulamayı indirmiş fakat henüz premium olmamış kullanıcıları hesap yaşına (createdAt) göre
 * 1. Gün, 3. Gün ve 7. Gün hedefe yönelik ikna edici bildirimlerle karşılar.
 */
export const scheduledDripNonPremiumNudge = onSchedule(
  {
    schedule: "0 12 * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    try {
      const now = Date.now();
      const oneDayMs = 24 * 60 * 60 * 1000;

      // isPremium == false olan kullanıcıları çek
      const snapshot = await db
        .collection("users")
        .where("isPremium", "==", false)
        .get();

      if (snapshot.empty) return;

      console.log(`[Drip Campaign Monitor] ${snapshot.size} non-premium kullanıcı inceleniyor...`);

      const promises = snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const fcmToken = data.fcmToken as string | undefined;
        if (!fcmToken) return;

        const createdAt = data.createdAt?.toMillis ? data.createdAt.toMillis() : null;
        if (!createdAt) return;

        const ageDays = Math.floor((now - createdAt) / oneDayMs);
        const lang = (data.deviceLanguage as string) || "tr";
        const isTr = lang.toLowerCase().startsWith("tr");

        let title = "";
        let body = "";
        let campaignId = "";

        if (ageDays === 1) {
          campaignId = "drip_day_1";
          title = isTr ? "🌱 İlk Adımı Attın, Şimdi Zırhını Tamamla" : "🌱 Great First Step, Now Shield Up";
          body = isTr
            ? "Dün temiz bir sayfa açtın. Kumar bağımlılığına karşı en kritik ilk günlerde VIP korumayı devrede tut, zayıf anında riske girme."
            : "You opened a clean page yesterday. Complete your VIP armor during these critical first days to stay 100% safe.";
        } else if (ageDays === 3) {
          campaignId = "drip_day_3";
          title = isTr ? "📊 3 Günlük Temiz Zafer" : "📊 3 Days Clean Victory";
          body = isTr
            ? "Kumar sitelerine vermediğin para şimdiden Nora aboneliğinden kat kat fazla. Kalıcı özgürlüğünü bugün garantile."
            : "The money you kept safe in 3 days is already more than Nora Premium. Lock in your permanent freedom today.";
        } else if (ageDays === 7) {
          campaignId = "drip_day_7";
          title = isTr ? "🏆 1 Haftalık Özgürlük: Gurur Duy" : "🏆 1 Week Freedom: Be Proud";
          body = isTr
            ? "1 haftadır temizsin! Bu başarıyı anlık bir dürtüye kurban etme. Nora VIP ile kalkanını sağlamlaştır."
            : "One full week gamble-free! Don't risk this milestone to a fleeting urge. Strengthen your shield with VIP.";
        } else {
          return;
        }

        // Mükerrer kontrolü: Kullanıcı bu aşamadaki drip mesajını daha önce aldı mı?
        const lastDripSentKey = `dripSent_${campaignId}`;
        if (data[lastDripSentKey]) return;

        const message: admin.messaging.Message = {
          token: fcmToken,
          notification: { title, body },
          data: {
            screen: "paywall",
            campaign_id: campaignId,
            offer_type: "lifecycle_drip",
            timestamp: new Date().toISOString(),
          },
          apns: {
            payload: {
              aps: { sound: "default", badge: 1 },
            },
          },
        };

        try {
          await messaging.send(message);
          await doc.ref.update({
            [lastDripSentKey]: admin.firestore.FieldValue.serverTimestamp(),
          });
          console.log(`[Drip Campaign: ${campaignId}] Sent to user ${doc.id}`);
        } catch (e) {
          console.error(`[Drip Campaign Error: ${campaignId}] User ${doc.id}:`, e);
        }
      });

      await Promise.all(promises);
    } catch (err) {
      console.error("[scheduledDripNonPremiumNudge Error]", err);
    }
  }
);

/**
 * 🛡️ Cloud Scheduler Job: Kalkanını yakın zamanda tekrar aktif eden kullanıcıları takip eder.
 * Her Gün 18:00'de çalışır; kalkanı devrede olan ve son 24 saatte kalkanını açmış kullanıcılara tebrik ve güçlendirici bildirim gönderir.
 */
export const scheduledProtectionStreakFollowup = onSchedule(
  {
    schedule: "0 18 * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    try {
      const now = Date.now();
      const twentyFourHoursAgo = new Date(now - 24 * 60 * 60 * 1000);

      // antiBypassEnabled == true ve antiBypassReEnabledAt >= son 24 saat olan kullanıcıları kontrol et
      const snapshot = await db
        .collection("users")
        .where("antiBypassEnabled", "==", true)
        .where("antiBypassReEnabledAt", ">=", twentyFourHoursAgo)
        .get();

      if (snapshot.empty) return;

      console.log(`[Protection Followup] Kalkanını son 24 saatte açan ${snapshot.size} kullanıcı tespit edildi.`);

      const promises = snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const fcmToken = data.fcmToken as string | undefined;
        if (!fcmToken) return;

        // Son 20 saat içinde bu takip bildirimi gönderildiyse tekrar gönderme
        const lastFollowup = data.lastReactivationFollowupAt?.toMillis?.() || 0;
        if (now - lastFollowup < 20 * 60 * 60 * 1000) return;

        const lang = (data.deviceLanguage as string) || "tr";
        const isTr = lang.toLowerCase().startsWith("tr");

        const title = isTr
          ? "🛡️ Kalkanın Güçlü, İraden Güvende"
          : "🛡️ Shield Strong, Recovery Safe";
        const body = isTr
          ? "Korumayı tekrar aktif ederek harika bir karar verdin. Nora kalkanın 7/24 arkanda; bugün de tertemiz bir gün seninle."
          : "Re-activating your shield was the best choice. Nora stands guard 24/7; keep winning today.";

        const message: admin.messaging.Message = {
          token: fcmToken,
          notification: { title, body },
          data: {
            screen: "blocker",
            alert_type: "protection_followup",
            timestamp: new Date().toISOString(),
          },
          apns: {
            payload: {
              aps: { sound: "default", badge: 1 },
            },
          },
        };

        try {
          await messaging.send(message);
          await doc.ref.update({
            lastReactivationFollowupAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          console.log(`[Protection Followup] Follow-up bildirim gönderildi: ${doc.id}`);
        } catch (e) {
          console.error(`[Protection Followup Error] User ${doc.id}:`, e);
        }
      });

      await Promise.all(promises);
    } catch (err) {
      console.error("[scheduledProtectionStreakFollowup Error]", err);
    }
  }
);

// ======================================================================
// 🛠️ ADMIN & ANALYTICS ENDPOINTS
// ======================================================================

/**
 * HTTP endpoint to manually test or trigger any campaign on demand.
 */
export const sendManualCampaignPush = onRequest(async (req, res) => {
  const campaignId = (req.query.campaignId as string) || req.body?.campaignId || "test_campaign";
  const title = req.body?.title || "🤝 Nora: Yanındayız, Yalnız Değilsin";
  const body = req.body?.body || "Zorlandığın her an buradayız. Kalkanını kilitle, bu mücadeleyi birlikte kazanalım.";

  const result = await sendCampaignPush({
    campaignId,
    titleTr: title,
    bodyTr: body,
    titleEn: title,
    bodyEn: body,
    offerType: "manual_test",
  });

  res.status(result.success ? 200 : 500).json(result);
});

/**
 * HTTP endpoint returning calculated conversion rates for all notification campaigns.
 * Computes conversion rate: (totalConversions / totalOpens) * 100%
 */
export const getCampaignAnalytics = onRequest(async (_, res) => {
  try {
    const snapshot = await db.collection("notification_campaigns").get();
    const reports: Record<string, unknown>[] = [];

    snapshot.forEach((doc) => {
      const data = doc.data();
      const opens = (data.totalOpens as number) || 0;
      const conversions = (data.totalConversions as number) || 0;
      const dispatches = (data.totalSentDispatches as number) || 0;
      const rate = opens > 0 ? ((conversions / opens) * 100).toFixed(2) + "%" : "0.00%";

      reports.push({
        campaignId: doc.id,
        title: data.titleTr || doc.id,
        totalSentDispatches: dispatches,
        totalOpens: opens,
        totalConversions: conversions,
        conversionRate: rate,
        lastSentAt: data.lastSentAt ? data.lastSentAt.toDate() : null,
        lastConvertedAt: data.lastConvertedAt ? data.lastConvertedAt.toDate() : null,
      });
    });

    res.status(200).json({
      success: true,
      timestamp: new Date().toISOString(),
      totalCampaigns: reports.length,
      campaigns: reports,
    });
  } catch (error) {
    res.status(500).json({ success: false, error: String(error) });
  }
});

// ======================================================================
// 🛡️ ANTI-BYPASS KALKANI KORUMASI VE UYARI SİSTEMİ
// ======================================================================

/**
 * 🚨 Firestore Trigger: Kullanıcı Anti-Bypass kalkanını kapattığı anda tetiklenir.
 * Doğrudan kullanıcının cihazına (FCM Token) yüksek öncelikli acil durum uyarısı yollar.
 */
export const onAntiBypassStatusChanged = onDocumentUpdated(
  "users/{userId}",
  async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();

    if (!afterData) return;

    // Kalkan aktiften pasife (false) geçmiş mi kontrol et
    const wasEnabled = beforeData?.antiBypassEnabled !== false;
    const isNowDisabled = afterData.antiBypassEnabled === false;

    if (wasEnabled && isNowDisabled) {
      const fcmToken = afterData.fcmToken as string | undefined;
      const lang = (afterData.deviceLanguage as string) || "tr";
      const userId = event.params.userId;

      // 🛡️ Mükerrer Gönderim Koruması (Debounce - 10 Saniye):
      // Çok hızlı ardaşık Firestore güncellemelerinde kullanıcının aynı bildirimi 2 kez almasını engeller
      const lastAlertMillis = afterData.antiBypassLastAlertAt?.toMillis?.() || 0;
      const now = Date.now();
      if (now - lastAlertMillis < 10000) {
        console.log(`[Anti-Bypass Alert] Debounce: Son 10 sn içinde uyarı gönderildi (${now - lastAlertMillis}ms). Mükerrer bildirim engellendi: ${userId}`);
        return;
      }

      if (!fcmToken) {
        console.warn(`[Anti-Bypass Alert] User ${userId} has no registered fcmToken.`);
        return;
      }

      // Mükerrerliği anında engellemek için son gönderim zamanını işaretle
      await event.data?.after.ref.update({
        antiBypassLastAlertAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      const isTr = lang.toLowerCase().startsWith("tr");
      const title = isTr
        ? "🚨 DİKKAT: Anti-Bypass Kalkanı Kapatıldı!"
        : "🚨 WARNING: Anti-Bypass Shield Disabled!";
      const body = isTr
        ? "Nora korumanız devre dışı bırakıldı. İradenizi korumak ve güvende kalmak için kalkanı hemen yeniden aktif edin."
        : "Your protection is vulnerable. Re-enable the shield immediately to safeguard your recovery.";

      const message: admin.messaging.Message = {
        token: fcmToken,
        notification: {
          title,
          body,
        },
        data: {
          screen: "blocker",
          alert_type: "anti_bypass_disabled",
          user_id: userId,
          timestamp: new Date().toISOString(),
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      try {
        const response = await messaging.send(message);
        console.log(`[Anti-Bypass Alert] Immediate warning push sent to user ${userId}: ${response}`);

        // Olayı Firestore bildirim loguna kaydet
        await db.collection("security_alerts").add({
          userId,
          alertType: "anti_bypass_disabled",
          title,
          body,
          dispatchedAt: admin.firestore.FieldValue.serverTimestamp(),
          fcmResponse: response,
        });
      } catch (err) {
        console.error(`[Anti-Bypass Alert Error] Failed to send push to user ${userId}:`, err);
      }
    }

    // 🛡️ Kalkan pasiften aktife (true) geçmiş mi kontrol et (Kalkan Yeniden Aktif Edildiğinde)
    const wasDisabled = beforeData?.antiBypassEnabled === false;
    const isNowEnabled = afterData.antiBypassEnabled === true;

    if (wasDisabled && isNowEnabled) {
      const fcmToken = afterData.fcmToken as string | undefined;
      const lang = (afterData.deviceLanguage as string) || "tr";
      const userId = event.params.userId;

      // 🛡️ Mükerrer Gönderim Koruması (Debounce - 10 Saniye):
      const lastReEnabledMillis = afterData.antiBypassLastReEnabledAlertAt?.toMillis?.() || 0;
      const now = Date.now();
      if (now - lastReEnabledMillis < 10000) {
        console.log(`[Anti-Bypass Re-Enabled Alert] Debounce: Son 10 sn içinde uyarı gönderildi (${now - lastReEnabledMillis}ms). Mükerrer bildirim engellendi: ${userId}`);
        return;
      }

      if (!fcmToken) {
        console.warn(`[Anti-Bypass Re-Enabled Alert] User ${userId} has no registered fcmToken.`);
        return;
      }

      // Son gönderim ve yeniden aktif edilme zamanını güncelle
      await event.data?.after.ref.update({
        antiBypassLastReEnabledAlertAt: admin.firestore.FieldValue.serverTimestamp(),
        antiBypassReEnabledAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      const isTr = lang.toLowerCase().startsWith("tr");
      const title = isTr
        ? "🛡️ Nora Koruması Tekrar Devrede!"
        : "🛡️ Nora Protection Re-Activated!";
      const body = isTr
        ? "Harika bir karar verdin! Kalkanın yeniden devrede ve kumar sitelerine erişim tamamen engellendi. İradeni korumaya kararlılıkla devam ediyoruz."
        : "Great decision! Your shield is back online and gambling sites are blocked. Keep safeguarding your recovery.";

      const message: admin.messaging.Message = {
        token: fcmToken,
        notification: {
          title,
          body,
        },
        data: {
          screen: "blocker",
          alert_type: "anti_bypass_re_enabled",
          user_id: userId,
          timestamp: new Date().toISOString(),
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      try {
        const response = await messaging.send(message);
        console.log(`[Anti-Bypass Re-Enabled Alert] Immediate confirmation push sent to user ${userId}: ${response}`);

        // Olayı Firestore bildirim loguna kaydet
        await db.collection("security_alerts").add({
          userId,
          alertType: "anti_bypass_re_enabled",
          title,
          body,
          dispatchedAt: admin.firestore.FieldValue.serverTimestamp(),
          fcmResponse: response,
        });
      } catch (err) {
        console.error(`[Anti-Bypass Re-Enabled Alert Error] Failed to send push to user ${userId}:`, err);
      }
    }
  }
);

/**
 * ⏰ Cloud Scheduler Job: Anti-Bypass kalkanı kapalı kalan kullanıcıları takip eder.
 * Her 30 dakikada bir çalışarak kalkanı hâlâ açmamış olan kullanıcılara hatırlatma bildirimi gönderir.
 */
export const scheduledAntiBypassMonitor = onSchedule(
  {
    schedule: "*/30 * * * *",
    timeZone: TIMEZONE,
    retryCount: 1,
  },
  async () => {
    try {
      // antiBypassEnabled == false olan kullanıcıları çek
      const snapshot = await db
        .collection("users")
        .where("antiBypassEnabled", "==", false)
        .get();

      if (snapshot.empty) {
        console.log("[Anti-Bypass Monitor] Kalkanı kapalı olan kullanıcı bulunamadı.");
        return;
      }

      console.log(`[Anti-Bypass Monitor] Kalkanı kapalı ${snapshot.size} kullanıcı tespit edildi.`);

      const sendPromises = snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const fcmToken = data.fcmToken as string | undefined;
        if (!fcmToken) return;

        const lang = (data.deviceLanguage as string) || "tr";
        const isTr = lang.toLowerCase().startsWith("tr");

        const title = isTr
          ? "⚠️ Kalkanınız Hâlâ Kapalı"
          : "⚠️ Your Shield is Still Disabled";
        const body = isTr
          ? "Anti-Bypass korumanız kapalı durumda. Kumar ve bahis sitelerine erişim riski devam ediyor. Kalkanı açmayı unutmayın."
          : "Anti-Bypass protection remains off. Access risk to gambling platforms is active. Turn on your shield now.";

        const message: admin.messaging.Message = {
          token: fcmToken,
          notification: {
            title,
            body,
          },
          data: {
            screen: "blocker",
            alert_type: "anti_bypass_reminder",
            user_id: doc.id,
            timestamp: new Date().toISOString(),
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
                badge: 1,
              },
            },
          },
        };

        try {
          await messaging.send(message);
          console.log(`[Anti-Bypass Monitor] Hatırlatma bildirimi gönderildi: ${doc.id}`);
        } catch (err) {
          console.error(`[Anti-Bypass Monitor Error] Kullanıcıya bildirim gönderilemedi (${doc.id}):`, err);
        }
      });

      await Promise.all(sendPromises);
    } catch (error) {
      console.error("[Anti-Bypass Monitor Error]", error);
    }
  }
);

/**
  * 🌐 Firestore Trigger: Yeni engellenen site eklendiğinde otomatik loglar
  * ve alan adını standart formata getirir. Tüm istemciler real-time stream üzerinden 
  * bu yeni siteyi anında alır ve cihazlarında otomatik engeller.
  */
export const onBlockedSiteCreated = onDocumentCreated(
  "blocked_sites/{siteId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const siteId = event.params.siteId;
    const domain = (data.domain as string || "").trim().toLowerCase();

    console.log(`[Firestore Blocked Site Created] New blocked site registered in DB: ${domain} (ID: ${siteId})`);

    // İstenirse toplam engellenen site sayacı güncellenebilir
    try {
      const statsRef = db.collection("system_metadata").doc("blocked_sites_stats");
      await statsRef.set(
        {
          totalBlockedSites: admin.firestore.FieldValue.increment(1),
          lastAddedDomain: domain,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );
    } catch (err) {
      console.error("[Blocked Site Stats Error]", err);
    }
  }
);


