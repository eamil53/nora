import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/blocker_category.dart';
import 'package:nora/providers/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Domain Blocker & Legal Iddaa Category Tests', () {
    test('Default categories should contain legal_betting category', () {
      final categories = BlockerCategory.getDefaultCategories();
      final legalCategory = categories.firstWhere((c) => c.id == 'legal_betting');

      expect(legalCategory, isNotNull);
      expect(legalCategory.title, contains('Yasal İddaa Siteleri'));
      expect(legalCategory.sampleDomains, contains('nesine.com'));
      expect(legalCategory.sampleDomains, contains('misli.com'));
      expect(legalCategory.sampleDomains, contains('bilyoner.com'));
      expect(legalCategory.sampleDomains, contains('tuttur.com'));
      expect(legalCategory.sampleDomains, contains('oley.com'));
      expect(legalCategory.sampleDomains, contains('birebin.com'));
      expect(legalCategory.sampleDomains, contains('iddaa.com'));
      expect(legalCategory.sampleBundleIds, contains('com.dms.nesine'));
      expect(legalCategory.sampleBundleIds, contains('com.misli.iphone'));
      expect(legalCategory.sampleBundleIds, contains('com.bilyoner.iphone'));
      expect(legalCategory.sampleBundleIds, contains('com.tuttur.iphone'));
    });

    test('checkDomain should block Turkish legal iddaa sites', () {
      final appState = AppState();

      final legalDomains = [
        'nesine.com',
        'https://www.misli.com/canli-iddaa',
        'bilyoner.com',
        'tuttur.com',
        'oley.com',
        'birebin.com',
        'iddaa.com',
      ];

      for (final domain in legalDomains) {
        final result = appState.checkDomain(domain);
        expect(result.isBlocked, isTrue, reason: '$domain should be blocked');
      }
    });

    test('checkDomain should allow safe non-gambling sites', () {
      final appState = AppState();

      final safeDomains = [
        'google.com',
        'wikipedia.org',
        'github.com',
        'flutter.dev',
      ];

      for (final domain in safeDomains) {
        final result = appState.checkDomain(domain);
        expect(result.isBlocked, isFalse, reason: '$domain should not be blocked');
      }
    });

    test('checkDomain should block dynamic mirror gambling domains (e.g. 1-king-837.club)', () {
      final appState = AppState();

      final mirrorDomains = [
        '1-king-837.club',
        'meritking837.com',
        'bets10-912.xyz',
        'jojobet-452.site',
        'cratos-385.top',
        'holiganbet999.vip',
      ];

      for (final domain in mirrorDomains) {
        final result = appState.checkDomain(domain);
        expect(result.isBlocked, isTrue, reason: '$domain should be blocked by dynamic mirror engine');
      }
    });

    test('addCustomDomain and server sync persistance should update checkDomain', () async {
      final appState = AppState();
      await appState.addCustomDomain('new-server-blocked-site.com');

      final result = appState.checkDomain('new-server-blocked-site.com');
      expect(result.isBlocked, isTrue);
    });
  });
}
