class BlockerCategory {
  final String id;
  final String title;
  final String description;
  final String iconName;
  bool isEnabled;
  final int blockedCount;
  final List<String> sampleDomains;
  final List<String> sampleBundleIds;

  BlockerCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isEnabled = true,
    required this.blockedCount,
    required this.sampleDomains,
    this.sampleBundleIds = const [],
  });

  String getTitle(bool isTr) {
    if (isTr) return title;
    switch (id) {
      case 'legal_betting':
        return 'Domestic Bookmakers & Betting Apps';
      case 'illegal_betting':
        return 'Offshore & Sports Betting Platforms';
      case 'casino_slots':
        return 'Online Casino & Slot Platforms';
      case 'high_risk_forex':
        return 'High-Risk Forex & Leveraged Trading';
      default:
        return title;
    }
  }

  String getDescription(bool isTr) {
    if (isTr) return description;
    switch (id) {
      case 'legal_betting':
        return 'Blocks sportsbooks, domestic betting apps and web platform mirrors.';
      case 'illegal_betting':
        return 'Blocks offshore sports betting sites, live bookmakers, and gambling mirrors.';
      case 'casino_slots':
        return 'Blocks live roulette, blackjack, poker, slot games and casino websites.';
      case 'high_risk_forex':
        return 'Blocks unregulated binary options, high leverage platforms and gambling clones.';
      default:
        return description;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isEnabled': isEnabled,
      'blockedCount': blockedCount,
      'sampleDomains': sampleDomains,
      'sampleBundleIds': sampleBundleIds,
    };
  }

  factory BlockerCategory.fromMap(Map<String, dynamic> map) {
    return BlockerCategory(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconName: map['iconName'],
      isEnabled: map['isEnabled'] ?? true,
      blockedCount: map['blockedCount'] ?? 0,
      sampleDomains: List<String>.from(map['sampleDomains'] ?? []),
      sampleBundleIds: List<String>.from(map['sampleBundleIds'] ?? []),
    );
  }

  static List<BlockerCategory> getDefaultCategories() {
    return [
      BlockerCategory(
        id: 'legal_betting',
        title: 'Yasal İddaa Siteleri & Şans Oyunları (Türkiye)',
        description: 'Nesine, Misli, Bilyoner, Tuttur, Oley, Birebin, İddaa, Milli Piyango ve TJK mobil uygulamalarını ve web sitelerini engeller.',
        iconName: 'sports_soccer',
        isEnabled: true,
        blockedCount: 15,
        sampleDomains: [
          'nesine.com', 'misli.com', 'bilyoner.com', 'tuttur.com',
          'oley.com', 'birebin.com', 'iddaa.com', 'millipiyangoonline.com',
          'sisal-sans.com', 'tjk.org', 'atyarisi.com', 'ganyan.com',
        ],
        sampleBundleIds: [
          'com.dms.nesine', 'com.nesine.iphone', 'com.nesine.app',
          'com.misli.iphone', 'com.misli.app',
          'com.bilyoner.iphone', 'com.bilyoner.app',
          'com.tuttur.iphone', 'com.tuttur.app',
          'com.oley.iphone', 'com.birebin.iphone',
          'com.iddaa.iphone', 'com.iddaa.app',
          'com.sisal.millipiyango', 'org.tjk.mobile',
        ],
      ),
      BlockerCategory(
        id: 'illegal_betting',
        title: 'Yasa Dışı Bahis & Kaçak İddaa Siteleri',
        description: 'Türkiye ve dünya çapındaki tüm kaçak bahis, illegal iddaa, canlı spor bahisleri ve offshore platformlara erişimi engeller.',
        iconName: 'shield_alert',
        isEnabled: true,
        blockedCount: 8450,
        sampleDomains: [
          '1-king-837.club', 'meritking.club', 'meritking837.com', 'bets10-912.xyz',
          'jojobet-452.site', 'cratos-385.top', 'holiganbet999.vip',
          'bets10.com', '1xbet.com', 'tempobet.com', 'superbahis.com',
          'mobilbahis.com', 'betboo.com', 'betpas.com', 'sahabet.com',
          'tipobet.com', 'tipobet365.com', 'matbet.com', 'sekabet.com',
          'jojobet.com', 'holiganbet.com', 'grandpashabet.com', 'betwoon.com',
          'mariobet.com', 'retrobet.com', 'meritking.com', 'meritbet.com',
          'restbet.com', 'betebet.com', 'onwin.com', 'paribahis.com',
          'pashagamers.com', 'vegasbet.com', 'piabet.com', 'pinbahis.com',
          'betpark.com', 'betnano.com', 'betgaranti.com', 'betmarlo.com',
          'pokerklas.com', 'klasbahis.com', 'superbetin.com', 'youwin.com',
          'hepsi-bahis.com', 'bahsegel.com', 'betmatik.com', 'dumanbet.com',
          'lordbahis.com', 'lunabit.com', 'cratosbet.com', 'betist.com',
          'interbahis.com', 'hiltonbet.com', 'perabet.com', 'turbobet.com',
          'asyabahis.com', 'supertotobet.com', 'bet365.com', 'unibet.com',
          'bwin.com', 'betway.com', 'williamhill.com', 'paddypower.com',
          'ladbrokes.com', 'betfair.com', 'skybet.com', 'betfred.com',
          'bovada.lv', 'betonline.ag', 'sportsbetting.ag', 'parimatch.com',
          'mostbet.com', 'melbet.com', 'linebet.com', 'megapari.com',
          'betwinner.com', '22bet.com', 'fonbet.ru', 'winline.ru',
          'sportsbet.io', '1xbit.com',
        ],
        sampleBundleIds: [
          'com.bets10.app', 'com.1xbet.app', 'com.tempobet.app',
          'com.mobilbahis.app', 'com.superbahis.app', 'com.betboo.app',
          'com.tipobet.app', 'com.matbet.app', 'com.jojobet.app',
          'com.holiganbet.app', 'com.bet365', 'com.unibet.app',
          'com.bwin.app', 'com.mostbet.app', 'com.melbet.app',
          'com.parimatch.app', 'com.betway.app',
        ],
      ),
      BlockerCategory(
        id: 'casino_slots',
        title: 'Online Casino, Slot & Poker Platformları',
        description: 'Canlı casino, rulet, blackjack, poker, Sweet Bonanza, Stake, Roobet ve tüm slot platformlarını engeller.',
        iconName: 'casino',
        isEnabled: true,
        blockedCount: 6120,
        sampleDomains: [
          'casinomaxi.com', 'casino-metropol.com', 'discountcasino.com',
          'anadolucasino.com', 'vdcasino.com', 'slotbar.com', 'cratosslot.com',
          'sweetbonanza.net', 'pinup.casino', 'pin-up.bet', 'stake.com',
          'stake.us', 'stake.bet', 'roobet.com', 'rollbit.com', 'bc.game',
          'gamdom.com', 'duelbits.com', 'shuffle.com', 'spinpalace.com',
          'slots.io', '888casino.com', '888poker.com', '888sport.com',
          '888.com', 'pokerstars.com', 'ggpoker.com', 'partypoker.com',
          'cloudbet.com', 'bitstarz.com', 'fortunejack.com', 'betsson.com',
          'leovegas.com', 'casumo.com', 'mrgreen.com', 'dunder.com',
          'rizk.com', 'guts.com', 'wildcasino.ag', 'slotozal.com',
          'vulkan-casino.com', 'rubyfortune.com', 'jackpotcitycasino.com',
          'royalvegascasino.com', 'mroyun.com', 'pragmaticplay.com',
          'evolution.com',
        ],
        sampleBundleIds: [
          'com.casinomaxi.app', 'com.pinup.casino', 'com.spinpalace.app',
          'com.casinometropol.app', 'com.stake.app', 'com.roobet.app',
          'com.pokerstars.app', 'com.ggpoker.app', 'com.888casino',
          'com.leovegas.app',
        ],
      ),
      BlockerCategory(
        id: 'high_risk_forex',
        title: 'Riskli Forex & Kaldıraçlı Opsiyonlar',
        description: 'Yüksek riskli merdiven altı forex, ikili opsiyon ve kumar türevi finansal alım-satım uygulamalarını engeller.',
        iconName: 'trending_down',
        isEnabled: true,
        blockedCount: 1850,
        sampleDomains: [
          'olymptrade.com', 'iqoption.com', 'binomo.com', 'pocketoption.com',
          'quotex.io', 'quotex.com', 'expertoption.com', 'deriv.com',
          'binary.com', 'highlow.net', 'exness-leverage.com', 'forex-broker.net',
        ],
        sampleBundleIds: [
          'com.olymptrade', 'com.iqoption', 'com.binomo',
          'com.pocketoption', 'com.quotex', 'com.exness.app',
          'com.expertoption',
        ],
      ),
      BlockerCategory(
        id: 'gambling_ads',
        title: 'Bahis Reklamları & Pop-up Ağları',
        description: 'Film, dizi ve spor sitelerindeki illegal bahis reklam yönlendirmelerini, pop-up ve yönlendirme ağlarını filtreler.',
        iconName: 'block',
        isEnabled: true,
        blockedCount: 4290,
        sampleDomains: [
          'bet-adnetwork.com', 'popup-gambling.net', 'betting-click.org',
          'gambling-pop.com', 'affiliate-bet.net', 'casinopopup.com',
          'betadserver.com',
        ],
        sampleBundleIds: [],
      ),
    ];
  }
}

class DomainCheckResult {
  final String domain;
  final bool isBlocked;
  final String? matchedCategory;
  final String reason;

  DomainCheckResult({
    required this.domain,
    required this.isBlocked,
    this.matchedCategory,
    required this.reason,
  });
}
