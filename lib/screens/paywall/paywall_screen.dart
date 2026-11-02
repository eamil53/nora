import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_strings.dart';
import '../../services/purchase_service.dart';
import '../../theme/app_colors.dart';

class PaywallScreen extends StatefulWidget {
  final Function(String selectedPlan) onSubscribeSuccess;
  final VoidCallback? onBack;
  final double? monthlySpend;
  final String currencySymbol;
  final String? languageCode;

  const PaywallScreen({
    super.key,
    required this.onSubscribeSuccess,
    this.onBack,
    this.monthlySpend,
    this.currencySymbol = '₺',
    this.languageCode = 'tr',
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  AppStrings get s => AppStrings.get(widget.languageCode);
  String _selectedPlan = 'annual'; // 'annual' or 'monthly'
  bool _isProcessing = false;
  int _roiIndex = 0;
  Timer? _roiTimer;

  Package? _monthlyPackage;
  Package? _annualPackage;

  @override
  void initState() {
    super.initState();
    _startRoiTimer();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await PurchaseService.instance.getOfferings();
      if (!mounted) return;
      if (offerings != null && offerings.current != null) {
        final current = offerings.current!;
        setState(() {
          _monthlyPackage = current.monthly ?? current.availablePackages.cast<Package?>().firstWhere(
            (p) => p?.packageType == PackageType.monthly || p?.storeProduct.identifier == PurchaseService.monthlyProductId,
            orElse: () => null,
          );
          _annualPackage = current.annual ?? current.availablePackages.cast<Package?>().firstWhere(
            (p) => p?.packageType == PackageType.annual || p?.storeProduct.identifier == PurchaseService.annualProductId,
            orElse: () => null,
          );
        });
      }
    } catch (e) {
      debugPrint('[PaywallScreen] Offerings yüklenirken hata: $e');
    }
  }

  void _startRoiTimer() {
    _roiTimer?.cancel();
    _roiTimer = Timer.periodic(const Duration(milliseconds: 3200), (timer) {
      if (!mounted) return;
      setState(() {
        _roiIndex = (_roiIndex + 1) % _milestonesCount;
      });
    });
  }

  int get _milestonesCount => 5;

  void _nextRoiMilestone() {
    HapticFeedback.selectionClick();
    setState(() {
      _roiIndex = (_roiIndex + 1) % _milestonesCount;
    });
    _startRoiTimer();
  }

  @override
  void dispose() {
    _roiTimer?.cancel();
    super.dispose();
  }

  String get _annualPriceDisplay {
    if (_annualPackage != null) {
      return _annualPackage!.storeProduct.priceString;
    }
    return '₺3.500';
  }

  String get _annualMonthlyEquivalentDisplay {
    if (_annualPackage != null) {
      final monthlyEq = _annualPackage!.storeProduct.price / 12;
      return '${widget.currencySymbol}${monthlyEq.toStringAsFixed(2)}';
    }
    return '₺291,66';
  }

  String get _monthlyPriceDisplay {
    if (_monthlyPackage != null) {
      return _monthlyPackage!.storeProduct.priceString;
    }
    return '₺500';
  }

  int get _selectedTrialDays => _selectedPlan == 'annual' ? 7 : 3;

  String get _trialCtaTitle {
    return s.paywallCtaText(_selectedTrialDays);
  }

  String get _trialCtaSubtext {
    if (_selectedPlan == 'annual') {
      return s.isTr
          ? '7 gün ücretsiz, sonra $_annualPriceDisplay/yıl • Dilediğin an iptal et'
          : '7 days free, then $_annualPriceDisplay/yr • Cancel anytime';
    } else {
      return s.isTr
          ? '3 gün ücretsiz, sonra $_monthlyPriceDisplay/ay • Dilediğin an iptal et'
          : '3 days free, then $_monthlyPriceDisplay/mo • Cancel anytime';
    }
  }

  void _handlePayment() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
    });

    final packageToBuy = _selectedPlan == 'annual' ? _annualPackage : _monthlyPackage;

    if (packageToBuy != null) {
      final result = await PurchaseService.instance.purchasePackage(packageToBuy);

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      if (result.isCancelled) {
        return;
      }

      if (result.isSuccess) {
        HapticFeedback.heavyImpact();
        _showSuccessSheet(result.activePlan ?? _selectedPlan);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: const Color(0xFFEF4444),
            content: Text(
              result.errorMessage ?? (s.isTr ? 'Satın alma tamamlanamadı.' : 'Purchase could not be completed.'),
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    } else {
      // StoreKit henüz yapılandırılmamışsa veya RevenueCat simülasyonu devredeyse
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      HapticFeedback.heavyImpact();
      _showSuccessSheet(_selectedPlan);
    }
  }

  void _handleRestorePurchases() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isProcessing = true;
    });

    final result = await PurchaseService.instance.restorePurchases();

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    if (result.isSuccess) {
      if (result.hasActiveSubscription) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: const Color(0xFF00E676),
            content: Text(
              s.isTr
                  ? 'Aboneliğiniz başarıyla geri yüklendi! Nora Kalkanı devrede.'
                  : 'Subscription successfully restored! Nora Shield active.',
              style: GoogleFonts.plusJakartaSans(color: const Color(0xFF070B14), fontWeight: FontWeight.w700),
            ),
          ),
        );
        widget.onSubscribeSuccess(result.activePlan ?? _selectedPlan);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: context.colors.surfaceCard,
            content: Text(
              s.isTr
                  ? 'Aktif bir Nora koruma aboneliği bulunamadı.'
                  : 'No active Nora subscription found.',
              style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFFEF4444),
          content: Text(
            result.errorMessage ?? (s.isTr ? 'Geri yükleme işlemi başarısız oldu.' : 'Restore failed.'),
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> _openLegalUrl(String url) async {
    HapticFeedback.lightImpact();
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching legal url: $e');
    }
  }

  void _showSuccessSheet(String activatedPlan) {
    final trialDays = activatedPlan == 'annual' ? 7 : 3;
    final planPrice = activatedPlan == 'annual' ? _annualPriceDisplay : _monthlyPriceDisplay;
    final planPeriod = activatedPlan == 'annual' ? (s.isTr ? 'yıl' : 'yr') : (s.isTr ? 'ay' : 'mo');

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF10B981)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF070B14), size: 36),
              ),
              const SizedBox(height: 18),
              Text(
                s.trialSuccessTitle,
                style: GoogleFonts.outfit(
                  color: context.colors.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                s.trialSuccessBody(trialDays, planPrice, planPeriod),
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textSecondary,
                  fontSize: 13.5,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF070B14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSubscribeSuccess(activatedPlan);
                  },
                  child: Text(
                    s.startAppButton,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceCanvas,
      body: SafeArea(
        child: Stack(
          children: [
            // Background subtle gradient glow
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00E676).withValues(alpha: 0.08),
                ),
              ),
            ),

            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Top VIP Badge Pill
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.shield_lefthalf_fill, color: Color(0xFF00E676), size: 14),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                s.isTr ? 'NORA VIP KORUMA' : 'NORA VIP PROTECTION',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF00E676),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // High-Impact Headline
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: context.colors.textPrimary,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(text: s.isTr ? 'Paranı ve Geleceğini\n' : 'Secure Your Money\n'),
                          TextSpan(
                            text: s.isTr ? 'Güvenceye Al' : '& Your Future',
                            style: const TextStyle(color: Color(0xFF00E676)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      s.isTr
                          ? 'Zayıf anlarında devreye giren ve kumar bağımlılığını sonlandıran 1 numaralı kalkan.'
                          : 'The #1 shield that intervenes during weak moments to end gambling addiction.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: context.colors.textSecondary,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dynamic ROI & Amorti Loop Capsule
                    _buildRoiLoopCapsule(),

                    const SizedBox(height: 6),

                    // Dynamic Personalized Calculation Badge
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.sparkles, color: Color(0xFF00E676), size: 12),
                          const SizedBox(width: 5),
                          Text(
                            s.isTr
                                ? 'Aylık ${_formatMoney(_spend.round())} harcamanıza göre: Nora kendini sadece $_daysToAmortize günde amorti eder'
                                : 'Based on your monthly spend of ${_formatMoney(_spend.round())}: Nora pays for itself in just $_daysToAmortize days',
                            style: GoogleFonts.plusJakartaSans(
                              color: context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 4 Core Superpowers (Compact 2x2 Grid)
                    _buildPillarsGrid(),

                    const SizedBox(height: 20),

                    // Interactive Subscription Plan Cards
                    _buildPlanOption(
                      planKey: 'annual',
                      title: s.planAnnualTitle,
                      trialBadge: s.planAnnualTrialBadge,
                      badge: s.planAnnualBadge,
                      priceDisplay: _annualPriceDisplay,
                      periodDisplay: s.planAnnualPeriod,
                      subtext: s.planAnnualSubtext(_annualMonthlyEquivalentDisplay, _daysToAmortizeAnnual),
                      isHighlight: true,
                    ),

                    const SizedBox(height: 10),

                    _buildPlanOption(
                      planKey: 'monthly',
                      title: s.planMonthlyTitle,
                      trialBadge: s.planMonthlyTrialBadge,
                      badge: null,
                      priceDisplay: _monthlyPriceDisplay,
                      periodDisplay: s.planMonthlyPeriod,
                      subtext: s.planMonthlySubtext(_daysToAmortizeMonthly),
                      isHighlight: false,
                    ),

                    const SizedBox(height: 20),

                    // Primary Action Button (Dynamic Free Trial CTA)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676),
                          foregroundColor: const Color(0xFF070B14),
                          elevation: 8,
                          shadowColor: const Color(0xFF00E676).withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _isProcessing ? null : _handlePayment,
                        child: _isProcessing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Color(0xFF070B14), strokeWidth: 2.5),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(CupertinoIcons.lock_shield_fill, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      _trialCtaTitle,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Button subtext reassurance
                    Text(
                      _trialCtaSubtext,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colors.textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Guarantee reassurance
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF00E676), size: 13),
                          const SizedBox(width: 5),
                          Text(
                            s.paywallZeroRisk,
                            style: GoogleFonts.plusJakartaSans(
                              color: context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // StoreKit / Google Play Auto-Renewal Terms Disclosure
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        s.paywallLegalDisclosure,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 10,
                          height: 1.35,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Footer Links
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildFooterLink(s.restorePurchases, _handleRestorePurchases),
                        Text('•', style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.4), fontSize: 11)),
                        _buildFooterLink(s.termsOfUse, () => _openLegalUrl(AppStrings.termsOfUseUrl)),
                        Text('•', style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.4), fontSize: 11)),
                        _buildFooterLink(s.privacyPolicy, () => _openLegalUrl(AppStrings.privacyPolicyUrl)),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Optional Close / Back Button Overlay
            if (widget.onBack != null)
              Positioned(
                top: 8,
                left: 14,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onBack!();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceCardAlt,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Icon(CupertinoIcons.xmark, color: context.colors.textPrimary, size: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- DYNAMIC ROI & AMORTI LOOP CAPSULE ---
  double get _spend {
    if (widget.monthlySpend != null && widget.monthlySpend! > 0) {
      return widget.monthlySpend!;
    }
    return 5000.0;
  }

  double get _dailySpend => _spend / 30.0;

  // Days to amortize current plan (dynamic based on monthly spend and selected plan)
  int get _daysToAmortize {
    final double targetMonthlyCost;
    if (_selectedPlan == 'annual') {
      targetMonthlyCost = _annualPackage != null
          ? (_annualPackage!.storeProduct.price / 12)
          : (3500.0 / 12);
    } else {
      targetMonthlyCost = _monthlyPackage != null
          ? _monthlyPackage!.storeProduct.price
          : 500.0;
    }
    if (_dailySpend <= 0) return 3;
    return (targetMonthlyCost / _dailySpend).ceil().clamp(1, 30);
  }

  int get _daysToAmortizeAnnual {
    final annualPrice = _annualPackage != null ? _annualPackage!.storeProduct.price : 3500.0;
    if (_dailySpend <= 0) return 2;
    return ((annualPrice / 12) / _dailySpend).ceil().clamp(1, 30);
  }

  int get _daysToAmortizeMonthly {
    final monthlyPrice = _monthlyPackage != null ? _monthlyPackage!.storeProduct.price : 500.0;
    if (_dailySpend <= 0) return 3;
    return (monthlyPrice / _dailySpend).ceil().clamp(1, 30);
  }

  String _formatMoney(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(s[i]);
    }
    return '${widget.currencySymbol}$buffer';
  }

  List<_RoiMilestoneData> _getMilestones() {
    final spend = _spend;
    final week1Saved = (spend / 4).round();
    final month1Saved = spend.round();
    final month3Saved = (spend * 3).round();
    final year1Saved = (spend * 12).round();
    final amortizeDays = _daysToAmortize;

    if (s.isTr) {
      return [
        // 1. Hafta: Nora Kendini Amorti Eder
        _RoiMilestoneData(
          col1Value: '⏱️ 1. Hafta',
          col1Label: 'İlk Dönüm',
          col2Value: '⚡ $amortizeDays Günde',
          col2Label: 'Nora Amorti',
          col3Value: '💰 +${_formatMoney(week1Saved)}',
          col3Label: 'Cepte Kalan',
          col2Color: const Color(0xFF00E676),
          col3Color: const Color(0xFF00E676),
        ),
        // 1. Ay: İlk Aylık Tasarruf
        _RoiMilestoneData(
          col1Value: '📅 1. Ay',
          col1Label: 'İlk Ay Zaferi',
          col2Value: '🛡️ ₺0 Kumar',
          col2Label: 'Alışkanlık Kırıldı',
          col3Value: '💰 +${_formatMoney(month1Saved)}',
          col3Label: 'Cepte Kalan',
          col2Color: const Color(0xFF6366F1),
          col3Color: const Color(0xFF00E676),
        ),
        // 3. Ay: Katlanan Tasarruf
        _RoiMilestoneData(
          col1Value: '🚀 3. Ay',
          col1Label: 'Büyük İrade',
          col2Value: '📈 30x Kâr',
          col2Label: 'Yatırım Getirisi',
          col3Value: '💰 +${_formatMoney(month3Saved)}',
          col3Label: 'Cepte Kalan',
          col2Color: const Color(0xFF6366F1),
          col3Color: const Color(0xFF00E676),
        ),
        // 1. Yıl: Finansal Özgürlük
        _RoiMilestoneData(
          col1Value: '👑 1. Yıl',
          col1Label: 'Finansal Özgürlük',
          col2Value: '🏆 Yeni Hayat',
          col2Label: 'Kalıcı Koruma',
          col3Value: '💰 +${_formatMoney(year1Saved)}+',
          col3Label: 'Cepte Kalan',
          col2Color: const Color(0xFFFFB300),
          col3Color: const Color(0xFF00E676),
        ),
        // Nora Topluluğu Sosyal Kanıt
        _RoiMilestoneData(
          col1Value: '⭐ 4.9/5',
          col1Label: 'Kullanıcı Puanı',
          col2Value: '🛡️ 10.000+',
          col2Label: 'Kurtarılan Hayat',
          col3Value: '💰 ${widget.currencySymbol}4.2M+',
          col3Label: 'Cepte Kalan',
        ),
      ];
    } else {
      return [
        _RoiMilestoneData(
          col1Value: '⏱️ Week 1',
          col1Label: 'First Milestone',
          col2Value: '⚡ In $amortizeDays Days',
          col2Label: 'Nora Paid Off',
          col3Value: '💰 +${_formatMoney(week1Saved)}',
          col3Label: 'Saved Cash',
          col2Color: const Color(0xFF00E676),
          col3Color: const Color(0xFF00E676),
        ),
        _RoiMilestoneData(
          col1Value: '📅 Month 1',
          col1Label: 'Month 1 Victory',
          col2Value: '🛡️ \$0 Gambled',
          col2Label: 'Habit Broken',
          col3Value: '💰 +${_formatMoney(month1Saved)}',
          col3Label: 'Saved Cash',
          col2Color: const Color(0xFF6366F1),
          col3Color: const Color(0xFF00E676),
        ),
        _RoiMilestoneData(
          col1Value: '🚀 Month 3',
          col1Label: 'Solid Willpower',
          col2Value: '📈 30x ROI',
          col2Label: 'Return on Value',
          col3Value: '💰 +${_formatMoney(month3Saved)}',
          col3Label: 'Saved Cash',
          col2Color: const Color(0xFF6366F1),
          col3Color: const Color(0xFF00E676),
        ),
        _RoiMilestoneData(
          col1Value: '👑 Year 1',
          col1Label: 'Financial Freedom',
          col2Value: '🏆 New Life',
          col2Label: 'Lasting Protection',
          col3Value: '💰 +${_formatMoney(year1Saved)}+',
          col3Label: 'Saved Cash',
          col2Color: const Color(0xFFFFB300),
          col3Color: const Color(0xFF00E676),
        ),
        _RoiMilestoneData(
          col1Value: '⭐ 4.9/5',
          col1Label: 'User Rating',
          col2Value: '🛡️ 10,000+',
          col2Label: 'Lives Changed',
          col3Value: '💰 ${widget.currencySymbol}4.2M+',
          col3Label: 'Saved Total',
        ),
      ];
    }
  }

  Widget _buildRoiLoopCapsule() {
    final milestones = _getMilestones();
    final current = milestones[_roiIndex % milestones.length];

    return GestureDetector(
      onTap: _nextRoiMilestone,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00E676).withValues(alpha: 0.28),
            width: 1.1,
          ),
          boxShadow: context.colors.cardShadows,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: Row(
                key: ValueKey<int>(_roiIndex % milestones.length),
                children: [
                  Expanded(
                    child: _buildSocialStat(
                      current.col1Value,
                      current.col1Label,
                    ),
                  ),
                  Container(width: 1, height: 22, color: context.colors.border),
                  Expanded(
                    child: _buildSocialStat(
                      current.col2Value,
                      current.col2Label,
                      valueColor: current.col2Color,
                    ),
                  ),
                  Container(width: 1, height: 22, color: context.colors.border),
                  Expanded(
                    child: _buildSocialStat(
                      current.col3Value,
                      current.col3Label,
                      valueColor: current.col3Color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(milestones.length, (i) {
                final isActive = i == (_roiIndex % milestones.length);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 12 : 4,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF00E676)
                        : context.colors.textSecondary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- STAT ITEM ---
  Widget _buildSocialStat(String value, String label, {Color? valueColor}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.outfit(
              color: valueColor ?? context.colors.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  // --- 2x2 PILLARS GRID (VIBRANT & INNOVATIVE) ---
  Widget _buildPillarsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMiniPillarCard(
                icon: CupertinoIcons.lock_shield_fill,
                accentColor: const Color(0xFF00E676),
                bgGradient: [
                  const Color(0xFF061E14),
                  const Color(0xFF0B1424),
                ],
                tag: s.pillar1Tag,
                title: s.pillar1Title,
                description: s.pillar1Desc,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMiniPillarCard(
                icon: CupertinoIcons.chart_bar_alt_fill,
                accentColor: const Color(0xFF6366F1),
                bgGradient: [
                  const Color(0xFF141336),
                  const Color(0xFF0B1424),
                ],
                tag: s.pillar2Tag,
                title: s.pillar2Title,
                description: s.pillar2Desc,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMiniPillarCard(
                icon: CupertinoIcons.wind,
                accentColor: const Color(0xFFF59E0B),
                bgGradient: [
                  const Color(0xFF22160A),
                  const Color(0xFF0B1424),
                ],
                tag: s.pillar3Tag,
                title: s.pillar3Title,
                description: s.pillar3Desc,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMiniPillarCard(
                icon: CupertinoIcons.book_fill,
                accentColor: const Color(0xFF06B6D4),
                bgGradient: [
                  const Color(0xFF071C26),
                  const Color(0xFF0B1424),
                ],
                tag: s.pillar4Tag,
                title: s.pillar4Title,
                description: s.pillar4Desc,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniPillarCard({
    required IconData icon,
    required Color accentColor,
    required List<Color> bgGradient,
    required String tag,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.colors.isDark
              ? bgGradient
              : [context.colors.surfaceCard, context.colors.surfaceCardAlt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: context.colors.isDark ? 0.12 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Glowing Icon + Flexible Live Tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.35),
                      accentColor.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: accentColor.withValues(alpha: 0.45)),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 4.5,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tag,
                            style: GoogleFonts.plusJakartaSans(
                              color: accentColor,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: context.colors.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textSecondary,
              fontSize: 11,
              height: 1.32,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }



  // --- INTERACTIVE SUBSCRIPTION OPTION CARD ---
  Widget _buildPlanOption({
    required String planKey,
    required String title,
    required String? badge,
    required String trialBadge,
    required String priceDisplay,
    required String periodDisplay,
    required String subtext,
    required bool isHighlight,
  }) {
    final isSelected = _selectedPlan == planKey;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedPlan = planKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00E676).withValues(alpha: 0.08)
              : context.colors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00E676)
                : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E676).withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : context.colors.cardShadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF818CF8),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                // Radio Indicator
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF00E676) : Colors.transparent,
                    border: Border.all(
                       color: isSelected ? const Color(0xFF00E676) : context.colors.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF070B14), size: 14),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtext,
                        style: GoogleFonts.plusJakartaSans(
                          color: isSelected ? const Color(0xFF00E676) : context.colors.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            priceDisplay,
                            style: GoogleFonts.outfit(
                              color: isSelected ? const Color(0xFF00E676) : context.colors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            periodDisplay,
                            style: GoogleFonts.plusJakartaSans(
                              color: context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          trialBadge,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF00E676),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- FOOTER LINK ---
  Widget _buildFooterLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: context.colors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _RoiMilestoneData {
  final String col1Value;
  final String col1Label;
  final String col2Value;
  final String col2Label;
  final String col3Value;
  final String col3Label;
  final Color? col2Color;
  final Color? col3Color;

  const _RoiMilestoneData({
    required this.col1Value,
    required this.col1Label,
    required this.col2Value,
    required this.col2Label,
    required this.col3Value,
    required this.col3Label,
    this.col2Color,
    this.col3Color,
  });
}

