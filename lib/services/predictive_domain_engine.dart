/// Position of the sequence number in the domain.
enum DomainNumberPosition {
  suffix, // e.g., bets10-942.com, mobilbahis821.com, pm-842.xyz
  prefix, // e.g., 101mostbet.com, 777roobet.com, 1-king-837.club
}

/// Represents a decomposed numeric domain pattern.
/// e.g., 'bets10-942.com' -> base: 'bets10', separator: '-', number: 942, tld: '.com'
/// or '101mostbet.com' -> base: 'mostbet', separator: '', number: 101, position: prefix
class DomainPatternComponents {
  final String originalDomain;
  final String baseName;
  final String separator;
  final int currentNumber;
  final int numberStringLength;
  final bool hasLeadingZero;
  final String tld;
  final DomainNumberPosition position;

  const DomainPatternComponents({
    required this.originalDomain,
    required this.baseName,
    required this.separator,
    required this.currentNumber,
    required this.numberStringLength,
    required this.hasLeadingZero,
    required this.tld,
    this.position = DomainNumberPosition.suffix,
  });

  /// Rebuilds a domain with a new sequence number.
  String buildDomain(int number, {String? customTld}) {
    final numStr = hasLeadingZero
        ? number.toString().padLeft(numberStringLength, '0')
        : number.toString();
    final effectiveTld = customTld ?? tld;
    final cleanTld = effectiveTld.startsWith('.') ? effectiveTld : '.$effectiveTld';

    if (position == DomainNumberPosition.prefix) {
      return '$numStr$separator$baseName$cleanTld';
    }
    return '$baseName$separator$numStr$cleanTld';
  }
}

/// Result of domain sequence prediction.
class PredictiveDerivationResult {
  final String seedDomain;
  final DomainPatternComponents components;
  final List<String> predictedDomains;

  const PredictiveDerivationResult({
    required this.seedDomain,
    required this.components,
    required this.predictedDomains,
  });
}

/// Advanced Global Predictive Domain Engine for dynamically deriving, anticipating,
/// and matching sequential gambling/betting mirror domains across worldwide operators.
class PredictiveDomainEngine {
  PredictiveDomainEngine._();

  /// Curated worldwide gambling brands that frequently deploy dynamic mirror domains
  /// (Covering Global Crypto, Western Europe, UK, North America, Latin America, Asia, CIS, and Turkey)
  static const Set<String> knownGamblingBrandRoots = {
    // 1. Global Crypto & Web3 Casinos
    'stake', 'roobet', 'rollbit', 'bcgame', 'bc-game', 'duelbits', 'gamdom',
    'shuffle', 'betfury', 'bitcasino', 'cloudbet', 'sportsbet', '1xbit',
    'vave', 'fairspin', 'csgoroll', 'hellcase', 'keydrop', 'key-drop',
    'dmarket', 'skinsmonkey', 'csgo500', '500casino', 'clashgg', 'rustclash',
    'hypedrop', 'bitstarz', 'fortunejack',

    // 2. Worldwide Sportsbooks & Multi-National Mirror Giants
    '1xbet', '22bet', '20bet', 'bet365', 'parimatch', 'mostbet', 'melbet',
    'betwinner', 'marathonbet', 'betway', 'unibet', 'bwin', 'pinnacle',
    'betfair', 'williamhill', 'ladbrokes', 'coral', 'paddypower', 'skybet',
    'betfred', 'boylesports', '888sport', '888casino', '888poker', 'mrgreen',
    'leovegas', 'casumo', 'rizk', 'betsson', 'betsafe', 'nordicbet', 'megapari',
    'linebet', 'interwetten',

    // 3. Asian Mega Bookmakers & Rotating Mirror Networks
    'dafabet', 'm88', 'mansion88', 'w88', 'fun88', '188bet', '12bet',
    'sbobet', 'cmd368', 'bk8', 'me88', 'maxim88', 'uea8', 'k9win',
    'nova88', 'saba', 'sabasports', 'singbet',

    // 4. North America / Offshore & Social / Sweepstakes
    'bovada', 'ignitioncasino', 'slotslv', 'cafecasino', 'betonline',
    'sportsbetting', 'mybookie', 'xbet', 'betus', 'everygame', 'wildcasino',
    'superslots', 'chumba', 'luckyland', 'pulsz', 'fortunecoins', 'high5casino',
    'mcluck', 'wowvegas', 'globalpoker', 'modo',

    // 5. Latin America / Brazil Heavy-Rotation Brands
    'betano', 'betnacional', 'estrelabet', 'esportesdasorte', 'pixbet',
    'f12bet', 'kto', 'vaidebet', 'galera', 'blaze', 'jonbet', 'codere',
    'caliente', 'betplay', 'wplay', 'rushbet',

    // 6. Eastern Europe & CIS Rotating Mirror Platforms
    'fonbet', 'ligastavok', 'winline', 'betcity', 'olimp', 'leon',
    'ggbet', 'vulkan', 'vulkanvegas', 'pinup', 'pin-up', 'joycasino',
    'playfortuna', 'booi', 'catcasino',

    // 7. Turkish & Regional Regulated/Offshore Rotation Sites
    'bets10', 'mobilbahis', 'superbahis', 'casinomaxi', 'casinometropol',
    'tempobet', 'tipobet', 'matbet', 'jojobet', 'holiganbet', 'sekabet',
    'cratos', 'cratosroyal', 'cratosroyalbet', 'meritking', 'grandpashabet',
    'betebet', 'betvole', 'supertotobet', 'mariobet', 'onwin', 'piabet',
    'vdcasino', 'betpark', 'asyabahis', 'dumanbet', 'retrobet', 'sahabet',
    'restbet', 'pashagaming', 'vegasbahis', 'kingbet', 'betwoon', 'paribahis',
  };

  /// Common global mirror affixes used in redirect and proxy gateways
  static const Set<String> globalMirrorAffixes = {
    'link', 'login', 'mirror', 'entry', 'access', 'app', 'm', 'mobile',
    'vip', 'play', 'direct', 'online', 'official', 'portal', 'sports',
    'casino', 'bet', 'games', 'club', 'secure', 'web', 'alternatif',
    'giris', 'guncel', 'tr', 'asia', 'global',
  };

  /// Common alternative TLDs frequently used for rotating gambling mirrors worldwide
  static const List<String> commonMirrorTlds = [
    'com', 'net', 'org', 'xyz', 'me', 'club', 'top', 'site', 'live', 'vip',
    'link', 'online', 'games', 'bet', 'casino', 'win', 'pro', 'zone', 'io',
    'gg', 'cc', 'is', 'to', 'ag', 'lv', 'asia', 'fun', 'space', 'click',
    'monster', 'icu', 'cyou', 'app', 'world'
  ];

  /// Cleans a domain by stripping protocol, paths, and 'www.'
  static String cleanDomain(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'https?://'), '')
        .replaceAll(RegExp(r'/.*'), '')
        .replaceAll(RegExp(r'^www\.'), '');
  }

  /// Decomposes a domain into base name, separator, sequential number, and TLD.
  /// Handles both suffix numbers (e.g., `bets10-942.com`, `pm-842.xyz`)
  /// and prefix numbers (e.g., `101mostbet.com`, `777roobet.com`, `1-king-837.club`).
  static DomainPatternComponents? decompose(String domain) {
    final clean = cleanDomain(domain);
    if (clean.isEmpty) return null;

    final dotIndex = clean.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex >= clean.length - 1) return null;

    // Check for two-part TLD (e.g., .co.uk, .com.tr, .org.tr)
    String tld = clean.substring(dotIndex);
    String domainBody = clean.substring(0, dotIndex);

    final secondDotIndex = domainBody.lastIndexOf('.');
    if (secondDotIndex > 0) {
      final possibleSecondTld = clean.substring(secondDotIndex);
      if (RegExp(r'^\.(?:co|com|org|net|gov|edu)\.[a-z]{2,4}$').hasMatch(possibleSecondTld)) {
        tld = possibleSecondTld;
        domainBody = clean.substring(0, secondDotIndex);
      }
    }

    // 1. Try Suffix match (e.g. bets10-942, mobilbahis821, pm-842)
    final suffixMatch = RegExp(r'^(.*?)([\-_]?)(\d{1,6})$').firstMatch(domainBody);
    if (suffixMatch != null) {
      final base = suffixMatch.group(1) ?? '';
      final separator = suffixMatch.group(2) ?? '';
      final numberStr = suffixMatch.group(3) ?? '';

      if (base.isNotEmpty && numberStr.isNotEmpty) {
        final parsedNumber = int.tryParse(numberStr);
        if (parsedNumber != null) {
          final hasLeadingZero = numberStr.startsWith('0') && numberStr.length > 1;
          return DomainPatternComponents(
            originalDomain: clean,
            baseName: base,
            separator: separator,
            currentNumber: parsedNumber,
            numberStringLength: numberStr.length,
            hasLeadingZero: hasLeadingZero,
            tld: tld,
            position: DomainNumberPosition.suffix,
          );
        }
      }
    }

    // 2. Try Prefix match (e.g. 101mostbet, 777roobet, 1-king-837)
    final prefixMatch = RegExp(r'^(\d{1,6})([\-_]?)(.*?)$').firstMatch(domainBody);
    if (prefixMatch != null) {
      final numberStr = prefixMatch.group(1) ?? '';
      final separator = prefixMatch.group(2) ?? '';
      final base = prefixMatch.group(3) ?? '';

      if (base.isNotEmpty && numberStr.isNotEmpty) {
        final parsedNumber = int.tryParse(numberStr);
        if (parsedNumber != null) {
          final hasLeadingZero = numberStr.startsWith('0') && numberStr.length > 1;
          return DomainPatternComponents(
            originalDomain: clean,
            baseName: base,
            separator: separator,
            currentNumber: parsedNumber,
            numberStringLength: numberStr.length,
            hasLeadingZero: hasLeadingZero,
            tld: tld,
            position: DomainNumberPosition.prefix,
          );
        }
      }
    }

    return null;
  }

  /// Checks if a domain has a detectable numeric sequential pattern.
  static bool hasNumericPattern(String domain) {
    return decompose(domain) != null;
  }

  /// Generates upcoming sequential variations for a given domain.
  ///
  /// - [forwardCount]: Number of future sequence domains to generate (default: 20)
  /// - [backwardCount]: Number of past sequence domains to generate (default: 2)
  /// - [includeCrossTlds]: If true, generates variations across common alternative mirror TLDs
  static PredictiveDerivationResult? deriveSequence(
    String domain, {
    int forwardCount = 20,
    int backwardCount = 2,
    bool includeCrossTlds = false,
  }) {
    final components = decompose(domain);
    if (components == null) return null;

    final Set<String> predicted = {};

    final startNum = (components.currentNumber - backwardCount).clamp(1, components.currentNumber);
    final endNum = components.currentNumber + forwardCount;

    for (int num = startNum; num <= endNum; num++) {
      if (num == components.currentNumber) continue; // Original already known
      predicted.add(components.buildDomain(num));

      if (includeCrossTlds) {
        for (final altTld in commonMirrorTlds) {
          predicted.add(components.buildDomain(num, customTld: altTld));
        }
      }
    }

    return PredictiveDerivationResult(
      seedDomain: components.originalDomain,
      components: components,
      predictedDomains: predicted.toList()..sort(),
    );
  }

  /// Derives future sequences for a collection of seed domains.
  /// Deduplicates and returns all derived domains.
  static List<String> deriveSequencesForList(
    Iterable<String> seedDomains, {
    int forwardCount = 15,
    int backwardCount = 1,
    bool includeCrossTlds = false,
  }) {
    final Set<String> allDerived = {};

    for (final seed in seedDomains) {
      final res = deriveSequence(
        seed,
        forwardCount: forwardCount,
        backwardCount: backwardCount,
        includeCrossTlds: includeCrossTlds,
      );
      if (res != null) {
        allDerived.addAll(res.predictedDomains);
      }
    }

    return allDerived.toList()..sort();
  }

  /// Checks whether a domain matches a global mirror affix pattern without numbers
  /// (e.g. `stake-mirror.com`, `login-roobet.org`, `1xbet-access.xyz`).
  static bool isGlobalMirrorAffixMatch(String domain) {
    final clean = cleanDomain(domain);
    final dotIdx = clean.lastIndexOf('.');
    if (dotIdx <= 0) return false;
    final domainBody = clean.substring(0, dotIdx).toLowerCase();

    for (final brand in knownGamblingBrandRoots) {
      for (final affix in globalMirrorAffixes) {
        if (domainBody == '$brand-$affix' ||
            domainBody == '$brand$affix' ||
            domainBody == '$affix-$brand' ||
            domainBody == '$affix$brand') {
          return true;
        }
      }
    }
    return false;
  }

  /// Evaluates whether an arbitrary tested domain is a predictive match for:
  /// 1) An active sequence of any of the provided [knownDomains].
  /// 2) A known global gambling brand root combined with sequential numeric suffix/prefix.
  /// 3) A global mirror affix pattern (e.g. `stake-mirror.com`).
  static bool isPredictiveMatch(
    String candidateDomain,
    Iterable<String> knownDomains,
  ) {
    final clean = cleanDomain(candidateDomain);
    if (clean.isEmpty) return false;

    // Check mirror affix pattern
    if (isGlobalMirrorAffixMatch(clean)) {
      return true;
    }

    final candidateComp = decompose(clean);
    if (candidateComp == null) return false;

    final candidateBaseClean = candidateComp.baseName.replaceAll(RegExp(r'[\-_]'), '').toLowerCase();

    // 1. Direct base match with any known domain
    for (final known in knownDomains) {
      final knownComp = decompose(known);
      if (knownComp != null) {
        final knownBaseClean = knownComp.baseName.replaceAll(RegExp(r'[\-_]'), '').toLowerCase();
        if (candidateBaseClean == knownBaseClean) {
          return true;
        }
      } else {
        final cleanKnown = cleanDomain(known);
        final dotIdx = cleanKnown.indexOf('.');
        final knownBody = dotIdx > 0 ? cleanKnown.substring(0, dotIdx) : cleanKnown;
        if (candidateBaseClean == knownBody || candidateBaseClean.contains(knownBody) || knownBody.contains(candidateBaseClean)) {
          return true;
        }
      }
    }

    // 2. Base match with curated worldwide gambling brands
    for (final brand in knownGamblingBrandRoots) {
      if (candidateBaseClean == brand || candidateBaseClean.contains(brand)) {
        return true;
      }
    }

    return false;
  }

  /// Formats internationalized human-readable explanation of why this domain
  /// was flagged by the predictive engine (supports English and Turkish).
  static String? getPredictiveBlockReason(
    String candidateDomain,
    Iterable<String> knownDomains, {
    bool isTr = false,
  }) {
    final clean = cleanDomain(candidateDomain);

    if (isGlobalMirrorAffixMatch(clean)) {
      return isTr
          ? 'Global ayna ağ geçidi ve yönlendirme deseni tespit edildi.'
          : 'Proactive AI Shield: Dynamic global mirror gateway affix detected.';
    }

    final comp = decompose(clean);
    if (comp == null) return null;

    final candidateBaseClean = comp.baseName.replaceAll(RegExp(r'[\-_]'), '').toLowerCase();

    for (final brand in knownGamblingBrandRoots) {
      if (candidateBaseClean == brand || candidateBaseClean.contains(brand)) {
        return isTr
            ? 'Global bahis operatörü ("$brand") ve ardışık ayna deseni (#${comp.currentNumber}) tespiti.'
            : 'Proactive AI Shield: Sequential dynamic mirror for global gambling brand ("$brand") with pattern #${comp.currentNumber}.';
      }
    }

    for (final known in knownDomains) {
      final knownComp = decompose(known);
      if (knownComp != null) {
        final knownBaseClean = knownComp.baseName.replaceAll(RegExp(r'[\-_]'), '').toLowerCase();
        if (candidateBaseClean == knownBaseClean) {
          return isTr
              ? '"${knownComp.originalDomain}" alan adının ardışık yeni ayna varyasyonu (#${comp.currentNumber}).'
              : 'Sequential dynamic mirror (#${comp.currentNumber}) derived from protected seed "${knownComp.originalDomain}".';
        }
      }
    }

    return isTr
        ? 'Dinamik sayısal ayna paterni tespit edildi.'
        : 'Dynamic sequential gambling mirror pattern detected.';
  }
}
