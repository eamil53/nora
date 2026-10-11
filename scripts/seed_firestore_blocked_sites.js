/**
 * Nora - Firestore Seed Script for Blocked Sites
 * 
 * Usage:
 * node scripts/seed_firestore_blocked_sites.js
 */

const admin = require('../functions/node_modules/firebase-admin');

// Initialize with default credentials or project ID
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'nora-manager',
  });
}

const db = admin.firestore();

const BLOCKED_SITES_SEED = [
  // Legal Betting & Lottery (TR)
  { domain: 'nesine.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'misli.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bilyoner.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'tuttur.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'oley.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'birebin.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'iddaa.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'millipiyangoonline.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sisal-sans.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'tjk.org', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'atyarisi.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'ganyan.com', category: 'legal_betting', categoryTitle: 'Yasal İddaa & Şans Oyunları (Türkiye)', isEnabled: true, isSystemDefault: true, type: 'domain' },

  // Illegal Betting & Kaçak İddaa (TR & Global)
  { domain: 'bets10.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '1xbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'tempobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'superbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'mobilbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betboo.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betpas.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sahabet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'tipobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'tipobet365.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'matbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sekabet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'jojobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'holiganbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'grandpashabet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betwoon.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'mariobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'retrobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'meritking.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'meritbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'restbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betebet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'onwin.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'paribahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pashagamers.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'vegasbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'piabet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pinbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betpark.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betnano.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betgaranti.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betmarlo.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pokerklas.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'klasbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'superbetin.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'youwin.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'hepsi-bahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bahsegel.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betmatik.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'dumanbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'lordbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'lunabit.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'cratosbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betist.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'interbahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'hiltonbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'perabet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'turbobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'asyabahis.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'supertotobet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bet365.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'unibet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bwin.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betway.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'williamhill.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'paddypower.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'ladbrokes.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betfair.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'skybet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betfred.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bovada.lv', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betonline.ag', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sportsbetting.ag', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'parimatch.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'mostbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'melbet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'linebet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'megapari.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betwinner.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '22bet.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'fonbet.ru', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'winline.ru', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sportsbet.io', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '1xbit.com', category: 'illegal_betting', categoryTitle: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri', isEnabled: true, isSystemDefault: true, type: 'domain' },

  // Casino Slots, Crypto & Poker
  { domain: 'casinomaxi.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'casino-metropol.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'discountcasino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'anadolucasino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'vdcasino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'slotbar.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'cratosslot.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'sweetbonanza.net', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pinup.casino', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pin-up.bet', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'stake.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'stake.us', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'stake.bet', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'roobet.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'rollbit.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bc.game', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'gamdom.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'duelbits.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'shuffle.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'spinpalace.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'slots.io', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '888casino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '888poker.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '888sport.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: '888.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pokerstars.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'ggpoker.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'partypoker.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'cloudbet.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'bitstarz.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'fortunejack.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betsson.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'leovegas.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'casumo.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'mrgreen.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'dunder.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'rizk.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'guts.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'wildcasino.ag', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'slotozal.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'vulkan-casino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'rubyfortune.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'jackpotcitycasino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'royalvegascasino.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'mroyun.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pragmaticplay.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'evolution.com', category: 'casino_slots', categoryTitle: 'Online Casino, Slot & Poker Platformları', isEnabled: true, isSystemDefault: true, type: 'domain' },

  // High Risk Forex & Financial Gambling
  { domain: 'olymptrade.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'iqoption.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'binomo.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'pocketoption.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'quotex.io', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'quotex.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'expertoption.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'deriv.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'binary.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'highlow.net', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'exness-leverage.com', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'forex-broker.net', category: 'high_risk_forex', categoryTitle: 'Riskli Forex & Kaldıraçlı Opsiyonlar', isEnabled: true, isSystemDefault: true, type: 'domain' },

  // Gambling Ads Networks
  { domain: 'bet-adnetwork.com', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'popup-gambling.net', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betting-click.org', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'gambling-pop.com', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'affiliate-bet.net', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'casinopopup.com', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
  { domain: 'betadserver.com', category: 'gambling_ads', categoryTitle: 'Bahis Reklamları & Pop-up Ağları', isEnabled: true, isSystemDefault: true, type: 'domain' },
];

async function seedFirestore() {
  console.log('🌱 Starting Firestore seed for "blocked_sites" collection...');
  const batch = db.batch();

  for (const site of BLOCKED_SITES_SEED) {
    const docId = site.domain.replace(/\./g, '_');
    const ref = db.collection('blocked_sites').doc(docId);
    batch.set(ref, {
      ...site,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
  }

  await batch.commit();
  console.log(`✅ Successfully seeded ${BLOCKED_SITES_SEED.length} blocked sites into Firestore collection "blocked_sites"!`);
}

seedFirestore().catch(console.error);
