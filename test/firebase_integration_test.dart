import 'package:flutter_test/flutter_test.dart';
import 'package:nora/firebase_options.dart';
import 'package:nora/services/firebase_service.dart';

void main() {
  group('Firebase Integration Configuration Tests', () {
    test('DefaultFirebaseOptions ios configuration matches GoogleService-Info.plist', () {
      final iosOptions = DefaultFirebaseOptions.ios;

      expect(iosOptions.apiKey, 'AIzaSyDCCdEYMItkEENsa7PUyZFZVyuvMi1cGgU');
      expect(iosOptions.appId, '1:249877567379:ios:0fc3fcf06dc2f881a9ba66');
      expect(iosOptions.messagingSenderId, '249877567379');
      expect(iosOptions.projectId, 'nora-manager');
      expect(iosOptions.storageBucket, 'nora-manager.firebasestorage.app');
      expect(iosOptions.iosBundleId, 'com.kumaribirak.nora');
    });

    test('FirebaseService provides static accessors and graceful initialization', () async {
      expect(FirebaseService.isInitialized, isFalse);

      // On non-iOS testing environment, initialize() runs gracefully without throwing
      await FirebaseService.initialize();

      // Verify methods do not throw even before native connection
      await FirebaseService.requestNotificationPermissions();
      expect(FirebaseService.hasRequestedPermission, isTrue);
      await FirebaseService.logEvent(name: 'test_event');
      await FirebaseService.setUserId('user_123');
      await FirebaseService.logScreenView(screenName: 'Dashboard');
      await FirebaseService.triggerInAppMessage('test_campaign_trigger');
      await FirebaseService.log('Test log message');
    });
  });
}
