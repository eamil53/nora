import 'package:flutter_test/flutter_test.dart';
import 'package:nora/services/predictive_domain_engine.dart';
import 'package:nora/services/firebase_service.dart';
import 'package:nora/providers/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PredictiveDomainEngine Pattern & Derivation Tests', () {
    test('Correctly decomposes hyphenated numeric mirror domains', () {
      final comp = PredictiveDomainEngine.decompose('bets10-942.com');
      expect(comp, isNotNull);
      expect(comp!.baseName, equals('bets10'));
      expect(comp.separator, equals('-'));
      expect(comp.currentNumber, equals(942));
      expect(comp.tld, equals('.com'));
      expect(comp.hasLeadingZero, isFalse);
      expect(comp.position, equals(DomainNumberPosition.suffix));

      expect(comp.buildDomain(943), equals('bets10-943.com'));
    });

    test('Correctly decomposes direct numeric suffix domains without separator', () {
      final comp = PredictiveDomainEngine.decompose('mobilbahis821.com');
      expect(comp, isNotNull);
      expect(comp!.baseName, equals('mobilbahis'));
      expect(comp.separator, equals(''));
      expect(comp.currentNumber, equals(821));
      expect(comp.tld, equals('.com'));
      expect(comp.position, equals(DomainNumberPosition.suffix));

      expect(comp.buildDomain(822), equals('mobilbahis822.com'));
    });

    test('Correctly decomposes global prefix numeric mirror domains', () {
      final comp = PredictiveDomainEngine.decompose('101mostbet.com');
      expect(comp, isNotNull);
      expect(comp!.baseName, equals('mostbet'));
      expect(comp.currentNumber, equals(101));
      expect(comp.position, equals(DomainNumberPosition.prefix));

      expect(comp.buildDomain(102), equals('102mostbet.com'));
      expect(comp.buildDomain(103), equals('103mostbet.com'));
    });

    test('Correctly preserves zero-padding in numbers', () {
      final comp = PredictiveDomainEngine.decompose('vegasbahis08.com');
      expect(comp, isNotNull);
      expect(comp!.currentNumber, equals(8));
      expect(comp.hasLeadingZero, isTrue);

      expect(comp.buildDomain(9), equals('vegasbahis09.com'));
      expect(comp.buildDomain(10), equals('vegasbahis10.com'));
    });

    test('Returns null for domains without sequential numeric suffixes or prefixes', () {
      expect(PredictiveDomainEngine.decompose('google.com'), isNull);
      expect(PredictiveDomainEngine.decompose('apple.com'), isNull);
      expect(PredictiveDomainEngine.decompose('wikipedia.org'), isNull);
    });

    test('Derives forward sequence accurately for global operators', () {
      final res = PredictiveDomainEngine.deriveSequence('roobet22.com', forwardCount: 4, backwardCount: 1);
      expect(res, isNotNull);
      expect(res!.predictedDomains, contains('roobet21.com'));
      expect(res.predictedDomains, contains('roobet23.com'));
      expect(res.predictedDomains, contains('roobet24.com'));
      expect(res.predictedDomains, contains('roobet25.com'));
      expect(res.predictedDomains, contains('roobet26.com'));
      expect(res.predictedDomains, isNot(contains('roobet22.com')));
    });

    test('Derives sequence across worldwide alternative mirror TLDs', () {
      final res = PredictiveDomainEngine.deriveSequence(
        'cratos100.com',
        forwardCount: 2,
        backwardCount: 0,
        includeCrossTlds: true,
      );
      expect(res, isNotNull);
      expect(res!.predictedDomains, contains('cratos101.com'));
      expect(res.predictedDomains, contains('cratos101.xyz'));
      expect(res.predictedDomains, contains('cratos101.net'));
      expect(res.predictedDomains, contains('cratos101.io'));
      expect(res.predictedDomains, contains('cratos102.club'));
    });

    test('Predictive matching recognizes global crypto, Asian and offshore gambling brands', () {
      // Global Crypto Casinos
      expect(PredictiveDomainEngine.isPredictiveMatch('stake-99.games', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('roobet888.com', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('bcgame12.com', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('duelbits05.net', []), isTrue);

      // Global Sportsbooks & Asian Mirrors
      expect(PredictiveDomainEngine.isPredictiveMatch('101mostbet.com', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('parimatch99.xyz', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('dafabet88.com', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('188bet01.com', []), isTrue);

      // Americas / Offshore
      expect(PredictiveDomainEngine.isPredictiveMatch('bovada22.lv', []), isTrue);
      expect(PredictiveDomainEngine.isPredictiveMatch('betonline55.ag', []), isTrue);

      // Safe global domains must not match
      expect(PredictiveDomainEngine.isPredictiveMatch('medium.com', []), isFalse);
      expect(PredictiveDomainEngine.isPredictiveMatch('bbc.com', []), isFalse);
      expect(PredictiveDomainEngine.isPredictiveMatch('github.com', []), isFalse);
    });

    test('Detects worldwide mirror affixes (e.g. stake-mirror, login-roobet)', () {
      expect(PredictiveDomainEngine.isGlobalMirrorAffixMatch('stake-mirror.com'), isTrue);
      expect(PredictiveDomainEngine.isGlobalMirrorAffixMatch('login-roobet.org'), isTrue);
      expect(PredictiveDomainEngine.isGlobalMirrorAffixMatch('1xbet-access.xyz'), isTrue);
      expect(PredictiveDomainEngine.isGlobalMirrorAffixMatch('google-mirror.com'), isFalse);
    });

    test('Supports internationalized explanations (English vs Turkish)', () {
      final reasonTr = PredictiveDomainEngine.getPredictiveBlockReason('stake-99.com', [], isTr: true);
      expect(reasonTr, contains('Global bahis operatörü'));

      final reasonEn = PredictiveDomainEngine.getPredictiveBlockReason('stake-99.com', [], isTr: false);
      expect(reasonEn, contains('Proactive AI Shield'));
      expect(reasonEn, contains('stake'));
    });
  });

  group('AppState Predictive Check & Silent Push Integration', () {
    test('AppState.checkDomain blocks unseeded dynamic mirror via Predictive Engine in English & Turkish', () {
      final appState = AppState();

      // Brand new mirror domain that is not seeded in database
      final result = appState.checkDomain('stake-999.com');
      expect(result.isBlocked, isTrue);
      expect(
        result.matchedCategory,
        anyOf(
          equals('Prediktif Sayısal Ayna (DGA)'),
          equals('Predictive Dynamic Mirror (DGA)'),
        ),
      );

      appState.dispose();
    });

    test('FirebaseService.handleSilentPushSync processes push data payload and notifies listener', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bool listenerCalled = false;
      List<String> receivedDomains = [];

      FirebaseService.onSilentPushFilterUpdated = (domains) {
        listenerCalled = true;
        receivedDomains = domains;
      };

      final payload = {
        'action': 'sync_blocked_sites',
        'domains': ['stake-500.com', 'roobet700.xyz'],
      };

      await FirebaseService.handleSilentPushSync(payload);

      expect(listenerCalled, isTrue);
      expect(receivedDomains, contains('stake-500.com'));
      // Predictive expansion should automatically include upcoming sequence variations!
      expect(receivedDomains, contains('stake-501.com'));
      expect(receivedDomains, contains('roobet701.xyz'));

      FirebaseService.onSilentPushFilterUpdated = null;
    });
  });
}
