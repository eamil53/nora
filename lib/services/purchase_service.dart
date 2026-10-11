import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Sonuç durumlarını içeren model sınıfları
class NoraPurchaseResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;
  final CustomerInfo? customerInfo;
  final String? activePlan;
  final bool isTrial;

  NoraPurchaseResult({
    required this.isSuccess,
    this.isCancelled = false,
    this.errorMessage,
    this.customerInfo,
    this.activePlan,
    this.isTrial = false,
  });
}

class RestoreResult {
  final bool isSuccess;
  final bool hasActiveSubscription;
  final String? errorMessage;
  final CustomerInfo? customerInfo;
  final String? activePlan;
  final bool isTrial;

  RestoreResult({
    required this.isSuccess,
    required this.hasActiveSubscription,
    this.errorMessage,
    this.customerInfo,
    this.activePlan,
    this.isTrial = false,
  });
}

/// RevenueCat Entegrasyon Servisi
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  // --- REVENUECAT YAPILANDIRMA SABİTLERİ ---
  /// Apple App Store için RevenueCat Public SDK API Anahtarı
  static const String appleApiKey = 'appl_cQRskdGMbffUsSOgdZfPUlLsXAV';

  /// Google Play için API Anahtarı (Gerektiğinde kullanım için)
  static const String googleApiKey = 'goog_pXzFwHnmzVbXQxLKJmNoPqRstUv';

  /// RevenueCat Entitlement ID (Kullanıcının premium kilidini açan yetki kimliği)
  static const String entitlementId = 'premium';

  /// RevenueCat & App Store Ürün Kimlikleri (Product IDs)
  static const String monthlyProductId = 'nora_monthly_protection';
  static const String annualProductId = 'nora_annual_protection';

  bool _isConfigured = false;
  bool get isConfigured => _isConfigured;

  /// SDK'yı başlatır
  Future<void> initialize() async {
    if (_isConfigured) return;

    if (kIsWeb) {
      debugPrint('[PurchaseService] Web platformunda RevenueCat in-app purchase desteklenmemektedir.');
      return;
    }

    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      PurchasesConfiguration? configuration;

      if (Platform.isIOS || Platform.isMacOS) {
        configuration = PurchasesConfiguration(appleApiKey);
      } else if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(googleApiKey);
      }

      if (configuration != null) {
        await Purchases.configure(configuration);
        _isConfigured = true;
        debugPrint('[PurchaseService] RevenueCat başarıyla başlatıldı.');
      }
    } catch (e) {
      debugPrint('[PurchaseService] Başlatma sırasında hata: $e');
    }
  }

  /// Aktif müşteri abonelik bilgisini döner
  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_isConfigured) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('[PurchaseService] getCustomerInfo hatası: $e');
      return null;
    }
  }

  /// Belirtilen CustomerInfo içinde 'premium' hakkının aktif olup olmadığını kontrol eder
  bool isEntitled(CustomerInfo? customerInfo) {
    if (customerInfo == null) return false;
    final entitlement = customerInfo.entitlements.all[entitlementId];
    return entitlement != null && entitlement.isActive;
  }

  /// Belirtilen CustomerInfo içinde 'premium' hakkının deneme sürecinde olup olmadığını döner
  bool isTrial(CustomerInfo? customerInfo) {
    if (customerInfo == null) return false;
    final entitlement = customerInfo.entitlements.all[entitlementId];
    return entitlement != null && entitlement.isActive && entitlement.periodType == PeriodType.trial;
  }

  /// Deneme veya abonelik bitiş tarihini döner
  DateTime? getExpirationDate(CustomerInfo? customerInfo) {
    if (customerInfo == null) return null;
    final entitlement = customerInfo.entitlements.all[entitlementId];
    if (entitlement == null || entitlement.expirationDate == null) return null;
    return DateTime.tryParse(entitlement.expirationDate!);
  }

  /// Aktif olan plan türünü tespit eder ('monthly' veya 'annual')
  String? getActivePlan(CustomerInfo? customerInfo) {
    if (customerInfo == null) return null;
    final entitlement = customerInfo.entitlements.all[entitlementId];
    if (entitlement == null || !entitlement.isActive) return null;

    final productId = entitlement.productIdentifier;
    if (productId.contains('monthly') || productId == monthlyProductId) {
      return 'monthly';
    } else if (productId.contains('annual') || productId.contains('yearly') || productId == annualProductId) {
      return 'annual';
    }
    return 'annual'; // varsayılan
  }

  /// RevenueCat Offerings (teklifler ve paketler) listesini çeker
  Future<Offerings?> getOfferings() async {
    if (!_isConfigured) return null;
    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      debugPrint('[PurchaseService] getOfferings hatası: $e');
      return null;
    }
  }

  /// Kullanıcı ID'sini RevenueCat ile eşleştirir (örneğin Firebase UID)
  Future<CustomerInfo?> logIn(String appUserId) async {
    if (!_isConfigured) return null;
    try {
      final logInResult = await Purchases.logIn(appUserId);
      return logInResult.customerInfo;
    } catch (e) {
      debugPrint('[PurchaseService] logIn hatası: $e');
      return null;
    }
  }

  /// Kullanıcı oturumunu sonlandırır (anonim RevenueCat kullanıcısına döner)
  Future<CustomerInfo?> logOut() async {
    if (!_isConfigured) return null;
    try {
      return await Purchases.logOut();
    } catch (e) {
      debugPrint('[PurchaseService] logOut hatası: $e');
      return null;
    }
  }

  /// Paket satın alma işlemini yürütür
  Future<NoraPurchaseResult> purchasePackage(Package package) async {
    if (!_isConfigured) {
      return NoraPurchaseResult(
        isSuccess: false,
        errorMessage: 'RevenueCat servisi henüz hazır değil. Lütfen internet bağlantınızı kontrol edin.',
      );
    }

    try {
      final rcResult = await Purchases.purchase(PurchaseParams.package(package));
      final customerInfo = rcResult.customerInfo;
      final isPremium = isEntitled(customerInfo);
      final plan = getActivePlan(customerInfo);
      final inTrial = isTrial(customerInfo);

      return NoraPurchaseResult(
        isSuccess: isPremium,
        customerInfo: customerInfo,
        activePlan: plan,
        isTrial: inTrial,
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('[PurchaseService] Satın alma kullanıcı tarafından iptal edildi.');
        return NoraPurchaseResult(isSuccess: false, isCancelled: true);
      }
      debugPrint('[PurchaseService] Satın alma PlatformException: ${e.message} (kod: $errorCode)');
      return NoraPurchaseResult(
        isSuccess: false,
        errorMessage: _mapErrorMessage(errorCode, e.message),
      );
    } catch (e) {
      debugPrint('[PurchaseService] Beklenmeyen satın alma hatası: $e');
      return NoraPurchaseResult(
        isSuccess: false,
        errorMessage: 'Satın alma tamamlanamadı. Lütfen daha sonra tekrar deneyin.',
      );
    }
  }

  /// Satın almaları geri yükler (Restore Purchases)
  Future<RestoreResult> restorePurchases() async {
    if (!_isConfigured) {
      return RestoreResult(
        isSuccess: false,
        hasActiveSubscription: false,
        errorMessage: 'RevenueCat servisi henüz hazır değil.',
      );
    }

    try {
      final restoredInfo = await Purchases.restorePurchases();
      final isPremium = isEntitled(restoredInfo);
      final plan = getActivePlan(restoredInfo);
      final inTrial = isTrial(restoredInfo);

      return RestoreResult(
        isSuccess: true,
        hasActiveSubscription: isPremium,
        customerInfo: restoredInfo,
        activePlan: plan,
        isTrial: inTrial,
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      debugPrint('[PurchaseService] Restore PlatformException: ${e.message} (kod: $errorCode)');
      return RestoreResult(
        isSuccess: false,
        hasActiveSubscription: false,
        errorMessage: _mapErrorMessage(errorCode, e.message),
      );
    } catch (e) {
      debugPrint('[PurchaseService] Beklenmeyen restore hatası: $e');
      return RestoreResult(
        isSuccess: false,
        hasActiveSubscription: false,
        errorMessage: 'Geri yükleme sırasında bir hata oluştu.',
      );
    }
  }

  /// Müşteri durumu değişikliklerini dinler (abonelik yenilendiğinde, iptal edildiğinde vb.)
  void addCustomerInfoUpdateListener(Function(CustomerInfo customerInfo) listener) {
    if (!_isConfigured) return;
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  /// RevenueCat hata kodlarını kullanıcı dostu Türkçe mesajlara dönüştürür
  String _mapErrorMessage(PurchasesErrorCode errorCode, String? originalMessage) {
    switch (errorCode) {
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Bu cihazda satın alma işlemi kısıtlanmış veya izin verilmiyor.';
      case PurchasesErrorCode.paymentPendingError:
        return 'Ödeme onay bekliyor. Onaylandığında korumanız otomatik aktif edilecektir.';
      case PurchasesErrorCode.invalidCredentialsError:
        return 'Mağaza kimlik doğrulama hatası. Lütfen App Store hesabınıza giriş yaptığınızdan emin olun.';
      case PurchasesErrorCode.networkError:
        return 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';
      case PurchasesErrorCode.storeProblemError:
        return 'App Store sunucularına erişilemiyor. Lütfen biraz sonra tekrar deneyin.';
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return 'Seçilen paket şu anda App Store üzerinde satışta değil.';
      default:
        return originalMessage ?? 'İşlem tamamlanamadı. Lütfen daha sonra tekrar deneyin.';
    }
  }
}
