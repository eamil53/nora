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
        title: 'Yasal İddaa Siteleri (Türkiye)',
        description: 'Nesine, Misli, Bilyoner, Tuttur, Oley, Birebin ve İddaa mobil uygulamalarını ve web sitelerini engeller.',
        iconName: 'sports_soccer',
        isEnabled: true,
        blockedCount: 7,
        sampleDomains: ['nesine.com', 'misli.com', 'bilyoner.com', 'tuttur.com', 'oley.com', 'birebin.com', 'iddaa.com'],
        sampleBundleIds: [
          'com.dms.nesine',
          'com.nesine.iphone',
          'com.nesine.app',
          'com.misli.iphone',
          'com.misli.app',
          'com.bilyoner.iphone',
          'com.bilyoner.app',
          'com.tuttur.iphone',
          'com.tuttur.app',
          'com.oley.iphone',
          'com.birebin.iphone',
          'com.iddaa.iphone',
          'com.iddaa.app',
        ],
      ),
      BlockerCategory(
        id: 'illegal_betting',
        title: 'Yasa Dışı Bahis Siteleri',
        description: 'Tüm illegal kaçak bahis, canlı iddaa ve mobil bahis uygulamalarına erişimi engeller.',
        iconName: 'shield_alert',
        isEnabled: true,
        blockedCount: 1420,
        sampleDomains: ['bets10.com', '1xbet.com', 'tempobet.com', 'superbahis.com', 'mobilbahis.com', 'betboo.com', 'betpas.com', 'sahabet.com'],
        sampleBundleIds: ['com.bets10.app', 'com.1xbet.app', 'com.tempobet.app', 'com.mobilbahis.app', 'com.superbahis.app'],
      ),
      BlockerCategory(
        id: 'casino_slots',
        title: 'Online Casino & Slot Platformları',
        description: 'Canlı rulet, blackjack, poker ve Sweet Bonanza gibi casino mobil uygulamaları ve web platformlarını bloklar.',
        iconName: 'casino',
        isEnabled: true,
        blockedCount: 980,
        sampleDomains: ['casinomaxi.com', 'sweetbonanza.net', 'pinup.casino', 'spinpalace.com', 'slots.io', 'casino-metropol.com'],
        sampleBundleIds: ['com.casinomaxi.app', 'com.pinup.casino', 'com.spinpalace.app', 'com.casinometropol.app'],
      ),
      BlockerCategory(
        id: 'high_risk_forex',
        title: 'Riskli Forex & Kaldıraçlı Uygulamalar',
        description: 'Yüksek riskli merdiven altı forex, ikili opsiyon ve kumar türevi mobil uygulamaları engeller.',
        iconName: 'trending_down',
        isEnabled: true,
        blockedCount: 450,
        sampleDomains: ['olymptrade.com', 'iqoption.com', 'binomo.com', 'exness-leverage.com', 'forex-broker.net'],
        sampleBundleIds: ['com.olymptrade', 'com.iqoption', 'com.binomo', 'com.exness.app'],
      ),
      BlockerCategory(
        id: 'gambling_ads',
        title: 'Bahis Reklamları & Pop-up Ağları',
        description: 'Film ve dizi sitelerindeki bahis reklam yönlendirmelerini ve pop-up ağlarını filtreler.',
        iconName: 'block',
        isEnabled: true,
        blockedCount: 2310,
        sampleDomains: ['bet-adnetwork.com', 'popup-gambling.net', 'betting-click.org'],
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
