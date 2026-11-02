import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_strings.dart';
import '../../providers/app_state.dart';
import '../../services/purchase_service.dart';
import '../../theme/app_colors.dart';

class VipMembershipDetailsScreen extends StatelessWidget {
  final AppState appState;

  const VipMembershipDetailsScreen({
    super.key,
    required this.appState,
  });

  AppStrings get s => appState.strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isAnnual = appState.activePlan == 'annual';
    final planTitle = isAnnual ? s.profilePlanAnnual : s.profilePlanMonthly;
    final isInTrial = appState.isInTrial;
    final trialDaysRemaining = appState.trialDaysRemaining;
    final isApproved = appState.nativeAuthStatus == 'approved';

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colors.surfaceCanvas,
          appBar: AppBar(
            backgroundColor: colors.surfaceCanvas,
            elevation: 0,
            leading: IconButton(
              icon: Icon(CupertinoIcons.xmark, color: colors.textPrimary, size: 20),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text(
              s.vipDetailsSheetTitle,
              style: GoogleFonts.outfit(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _restorePurchases(context),
                child: Text(
                  s.vipDetailsRestorePurchases,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFF59E0B),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HERO VIP HEADER CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors.isDark
                                ? [const Color(0xFF1F293D), const Color(0xFF111827)]
                                : [const Color(0xFFFFFBEB), const Color(0xFFFEF3C7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withValues(alpha: colors.isDark ? 0.4 : 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: colors.isDark ? 0.15 : 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 30),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              s.vipDetailsSheetTitle,
                              style: GoogleFonts.outfit(
                                color: colors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.vipDetailsSheetSubtitle,
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 2. ACTIVE PLAN CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                          boxShadow: [
                            BoxShadow(
                              color: colors.cardShadow,
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676).withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF00E676), size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        planTitle,
                                        style: GoogleFonts.outfit(
                                          color: colors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isInTrial
                                            ? s.vipDetailsStatusTrial
                                            : s.vipDetailsStatusActive,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF00B359),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isInTrial ? const Color(0xFF00E676) : const Color(0xFFF59E0B),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isInTrial
                                        ? s.profileTrialBadge(trialDaysRemaining)
                                        : s.profileActiveBadge,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isInTrial ? const Color(0xFF070B14) : Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: colors.separator, height: 1),
                            const SizedBox(height: 12),
                            Text(
                              isInTrial
                                  ? s.profileTrialStatus(trialDaysRemaining, planTitle)
                                  : s.profileActiveStatus(planTitle),
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 3. INCLUDED FEATURES SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          s.profileSecPrivileges,
                          style: GoogleFonts.plusJakartaSans(
                            color: colors.textTertiary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            _buildFeatureRow(context, s.vipDetailsFeature1, CupertinoIcons.shield_fill, const Color(0xFF6366F1)),
                            _buildDivider(context),
                            _buildFeatureRow(context, s.vipDetailsFeature2, CupertinoIcons.bolt_horizontal_fill, const Color(0xFFF59E0B)),
                            _buildDivider(context),
                            _buildFeatureRow(context, s.vipDetailsFeature3, CupertinoIcons.device_phone_portrait, const Color(0xFF10B981)),
                            _buildDivider(context),
                            _buildFeatureRow(context, s.vipDetailsFeature4, CupertinoIcons.lock_shield_fill, const Color(0xFFEF4444)),
                            _buildDivider(context),
                            _buildFeatureRow(context, s.vipDetailsFeature5, CupertinoIcons.book_fill, const Color(0xFF8B5CF6)),
                            _buildDivider(context),
                            _buildFeatureRow(context, s.vipDetailsFeature6, CupertinoIcons.graph_square_fill, const Color(0xFF00E676)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. SECURITY & SYSTEM STATUS SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          s.vipDetailsSecStatusTitle,
                          style: GoogleFonts.plusJakartaSans(
                            color: colors.textTertiary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            _buildStatusRow(
                              context: context,
                              icon: isApproved ? CupertinoIcons.checkmark_shield_fill : CupertinoIcons.shield_slash_fill,
                              iconColor: isApproved ? const Color(0xFF00E676) : const Color(0xFFF59E0B),
                              title: s.profileTileScreenTime,
                              subtitle: isApproved ? s.profileScreenTimeApproved : s.profileScreenTimePending,
                              isOk: isApproved,
                            ),
                            _buildDivider(context),
                            _buildStatusRow(
                              context: context,
                              icon: CupertinoIcons.cloud_fill,
                              iconColor: const Color(0xFF6366F1),
                              title: s.isTr ? 'Bulut Veritabanı Senkronizasyonu' : 'Cloud Database Sync',
                              subtitle: s.isTr ? 'Firestore canlı ayna filtresi aktif ve bağlı' : 'Firestore real-time mirror filter connected',
                              isOk: true,
                            ),
                            _buildDivider(context),
                            _buildStatusRow(
                              context: context,
                              icon: CupertinoIcons.lock_fill,
                              iconColor: const Color(0xFF10B981),
                              title: s.isTr ? 'Bypass & Silme Koruması' : 'Bypass & Removal Protection',
                              subtitle: s.isTr ? 'Kalkan müdahalesine karşı anti-bypass kilitli' : 'Anti-bypass locked against shield tampering',
                              isOk: appState.antiBypassEnabled,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. BOTTOM FIXED ACTION BAR
              Container(
                padding: EdgeInsets.fromLTRB(18, 12, 18, MediaQuery.of(context).padding.bottom + 12),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  border: Border(top: BorderSide(color: colors.border)),
                  boxShadow: [
                    BoxShadow(
                      color: colors.cardShadow,
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => _openStoreSubscription(context),
                        child: Text(
                          s.vipDetailsManageStore,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(BuildContext context, String title, IconData icon, Color iconColor) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF00E676), size: 16),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isOk,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (isOk ? const Color(0xFF00E676) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isOk ? (s.isTr ? 'Aktif' : 'Active') : (s.isTr ? 'Bekliyor' : 'Pending'),
              style: GoogleFonts.plusJakartaSans(
                color: isOk ? const Color(0xFF00B359) : const Color(0xFFD97706),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colors = context.colors;
    return Divider(color: colors.separator, height: 1);
  }

  Future<void> _restorePurchases(BuildContext context) async {
    HapticFeedback.lightImpact();
    try {
      final result = await PurchaseService.instance.restorePurchases();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.hasActiveSubscription ? s.vipDetailsRestoredSuccess : (s.isTr ? 'Satın alımlar güncellendi.' : 'Purchases updated.'),
            ),
            backgroundColor: const Color(0xFF00E676),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.isTr ? 'Geri yükleme sırasında bir hata oluştu.' : 'Error restoring purchases.'),
          ),
        );
      }
    }
  }

  Future<void> _openStoreSubscription(BuildContext context) async {
    HapticFeedback.lightImpact();
    const url = 'https://apps.apple.com/account/subscriptions';
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }
}
