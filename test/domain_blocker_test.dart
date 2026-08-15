import 'package:flutter_test/flutter_test.dart';
import 'package:nora/models/blocker_category.dart';
import 'package:nora/providers/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
  });
}
