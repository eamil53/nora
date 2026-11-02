import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_strings.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import 'vip_membership_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onOpenPaywall;

  const ProfileScreen({
    super.key,
    required this.appState,
    required this.onOpenPaywall,
  });

  AppStrings get s => appState.strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final profile = appState.userProfile;
        final daysClean = profile.calculateDaysClean();
        final savedMoney = profile.calculateSavedMoney();
        final currency = profile.currencySymbol;

        return Scaffold(
          backgroundColor: colors.surfaceCanvas,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 20,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF00E676)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(CupertinoIcons.person_crop_circle_fill, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.profileHeaderTitle,
                    style: GoogleFonts.outfit(
                      color: colors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO PROFILE CARD WITH STATS PILL
                _buildHeroProfileCard(context, profile, daysClean, savedMoney, currency),

                const SizedBox(height: 16),

                // 2. VIP MEMBERSHIP CARD
                _buildSubscriptionCard(context),

                const SizedBox(height: 22),

                // 3. SECTION: KORUMA & GÜVENLİK DÜZEYİ
                _buildSectionTitle(context, s.profileSecProtection, CupertinoIcons.shield_lefthalf_fill),
                const SizedBox(height: 8),
                _buildProtectionSection(context),

                const SizedBox(height: 22),

                // 4. SECTION: İRADE & SAYAÇ YÖNETİMİ
                _buildSectionTitle(context, s.profileSecJourney, CupertinoIcons.flame_fill),
                const SizedBox(height: 8),
                _buildJourneySection(context),

                const SizedBox(height: 22),

                // 5. SECTION: NORA & AYRICALIKLAR
                _buildSectionTitle(context, s.profileSecPrivileges, CupertinoIcons.sparkles),
                const SizedBox(height: 8),
                _buildAppSection(context),

                const SizedBox(height: 22),

                // 6. SECTION: TEHLİKELİ BÖLGE
                _buildSectionTitle(context, s.profileSecDanger, CupertinoIcons.exclamationmark_triangle_fill, isDestructive: true),
                const SizedBox(height: 8),
                _buildDangerSection(context),

                const SizedBox(height: 32),

                // 7. FOOTER
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.surfaceCardAlt,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.lock_shield_fill, color: Color(0xFF00E676), size: 12),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                s.profileFooterTech,
                                style: GoogleFonts.plusJakartaSans(
                                  color: colors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.profileFooterPrivacy,
                        style: GoogleFonts.plusJakartaSans(
                          color: colors.textTertiary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- SECTION TITLE ---
  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, {bool isDestructive = false}) {
    final colors = context.colors;
    final color = isDestructive ? const Color(0xFFEF4444) : colors.textTertiary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: color,
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
    );
  }

  // --- HERO PROFILE CARD ---
  Widget _buildHeroProfileCard(BuildContext context, dynamic profile, int daysClean, double savedMoney, String currency) {
    final colors = context.colors;
    final formattedSaved = savedMoney >= 1000 ? savedMoney.toStringAsFixed(0) : savedMoney.toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Glowing Halo Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surfaceCard,
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.person_solid,
                        color: Color(0xFF00E676),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.profileWarrior,
                            style: GoogleFonts.outfit(
                              color: colors.textPrimary,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            s.profileActiveStreak,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF00B359),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.mainMotivation.toString().isNotEmpty
                          ? '“${profile.mainMotivation}”'
                          : '“${s.profileDefaultMotivation}”',
                      style: GoogleFonts.plusJakartaSans(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: colors.separator, height: 1),
          const SizedBox(height: 14),

          // Mini Stats Pills
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.calendar, color: Color(0xFF00E676), size: 14),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.cleanDaysCount(daysClean),
                              style: GoogleFonts.outfit(
                                color: colors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              s.profileDaysCleanPill,
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.money_dollar_circle_fill, color: Color(0xFFF59E0B), size: 14),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currency$formattedSaved',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFD97706),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              s.profileProtectedPill,
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- VIP SUBSCRIPTION CARD ---
  Widget _buildSubscriptionCard(BuildContext context) {
    final colors = context.colors;
    final isAnnual = appState.activePlan == 'annual';
    final planTitle = isAnnual ? s.profilePlanAnnual : s.profilePlanMonthly;
    final isInTrial = appState.isInTrial;
    final trialDaysRemaining = appState.trialDaysRemaining;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (appState.isSubscribed) {
          _openVipDetailsScreen(context);
        } else {
          onOpenPaywall();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.isDark ? const Color(0xFF161E2E) : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: colors.isDark ? 0.4 : 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: colors.isDark ? 0.1 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: const Icon(CupertinoIcons.sparkles, color: Color(0xFFF59E0B), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          s.profileVipTitle,
                          style: GoogleFonts.outfit(
                            color: colors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isInTrial ? const Color(0xFF00E676) : const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isInTrial
                              ? s.profileTrialBadge(trialDaysRemaining)
                              : s.profileActiveBadge,
                          style: GoogleFonts.plusJakartaSans(
                            color: isInTrial ? const Color(0xFF070B14) : Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isInTrial
                        ? s.profileTrialStatus(trialDaysRemaining, planTitle)
                        : s.profileActiveStatus(planTitle),
                    style: GoogleFonts.plusJakartaSans(
                      color: colors.textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                s.profileManageBtn,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECTION: PROTECTION ---
  Widget _buildProtectionSection(BuildContext context) {
    final isApproved = appState.nativeAuthStatus == 'approved';

    return _buildGroupCard(context, [
      _buildSettingTile(
        context: context,
        icon: isApproved ? CupertinoIcons.checkmark_shield_fill : CupertinoIcons.shield_slash_fill,
        iconColor: isApproved ? const Color(0xFF00E676) : const Color(0xFFF59E0B),
        title: s.profileTileScreenTime,
        subtitle: isApproved
            ? s.profileScreenTimeApproved
            : s.profileScreenTimePending,
        trailing: isApproved
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF00E676), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      s.profileStatusEnabled,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF00B359),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  appState.requestNativePermissions();
                },
                child: Text(
                  s.profileStatusGrant,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
              ),
      ),
      _buildDivider(context),
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.lock_shield_fill,
        iconColor: const Color(0xFF06B6D4),
        title: s.profileTileVpn,
        subtitle: appState.isBypassThreatActive
            ? s.profileVpnActive
            : s.profileVpnIdle,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.3)),
          ),
          child: Text(
            s.profileStatusActive,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF0891B2),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ]);
  }

  // --- SECTION: JOURNEY & TRACKING ---
  Widget _buildJourneySection(BuildContext context) {
    final colors = context.colors;
    return _buildGroupCard(context, [
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.arrow_counterclockwise_circle_fill,
        iconColor: const Color(0xFFF97316),
        title: s.profileTileResetStreak,
        subtitle: s.profileTileResetStreakSub,
        onTap: () {
          HapticFeedback.lightImpact();
          _showResetQuitDialog(context);
        },
        trailing: Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
      ),
    ]);
  }

  // --- SECTION: APP & MEMBERSHIP ---
  Widget _buildAppSection(BuildContext context) {
    final colors = context.colors;
    final themeLabel = switch (appState.themeMode) {
      ThemeMode.system => s.profileThemeAutoTitle,
      ThemeMode.light => s.profileThemeLightTitle,
      ThemeMode.dark => s.profileThemeDarkTitle,
    };
    final themeIcon = switch (appState.themeMode) {
      ThemeMode.system => CupertinoIcons.circle_righthalf_fill,
      ThemeMode.light => CupertinoIcons.sun_max_fill,
      ThemeMode.dark => CupertinoIcons.moon_stars_fill,
    };
    final themeColor = switch (appState.themeMode) {
      ThemeMode.system => const Color(0xFF6366F1),
      ThemeMode.light => const Color(0xFFF59E0B),
      ThemeMode.dark => const Color(0xFF8B5CF6),
    };

    return _buildGroupCard(context, [
      _buildSettingTile(
        context: context,
        icon: themeIcon,
        iconColor: themeColor,
        title: s.profileTileTheme,
        subtitle: themeLabel,
        onTap: () {
          HapticFeedback.lightImpact();
          _showThemeSelectionSheet(context);
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: themeColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                appState.themeMode == ThemeMode.system
                    ? s.profileThemePillAuto
                    : (appState.themeMode == ThemeMode.light ? s.profileThemePillLight : s.profileThemePillDark),
                style: GoogleFonts.plusJakartaSans(
                  color: themeColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
          ],
        ),
      ),
      _buildDivider(context),
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.globe,
        iconColor: const Color(0xFF00E676),
        title: s.languageTitle,
        subtitle: appState.languagePreference == 'system'
            ? s.languageSystem
            : (appState.languagePreference == 'tr' ? s.languageTr : s.languageEn),
        onTap: () {
          HapticFeedback.lightImpact();
          _showLanguageSelectionSheet(context);
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
              ),
              child: Text(
                appState.languagePreference == 'system'
                    ? (s.isTr ? 'Otomatik' : 'Auto')
                    : (appState.languagePreference == 'tr' ? 'TR' : 'EN'),
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF00E676),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
          ],
        ),
      ),
      _buildDivider(context),
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.bag_fill,
        iconColor: const Color(0xFF6366F1),
        title: s.profileTilePaywall,
        subtitle: appState.isSubscribed
            ? (appState.isInTrial
                ? s.profileTrialStatus(appState.trialDaysRemaining, appState.activePlan == 'annual' ? s.profilePlanAnnual : s.profilePlanMonthly)
                : s.profileActiveStatus(appState.activePlan == 'annual' ? s.profilePlanAnnual : s.profilePlanMonthly))
            : s.profileTilePaywallSub,
        onTap: () {
          HapticFeedback.lightImpact();
          if (appState.isSubscribed) {
            _openVipDetailsScreen(context);
          } else {
            onOpenPaywall();
          }
        },
        trailing: Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
      ),
      _buildDivider(context),
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.shield_fill,
        iconColor: const Color(0xFF10B981),
        title: s.privacyPolicy,
        subtitle: s.isTr ? '100% Cihaz İçi Gizlilik • Sıfır Veri Takibi' : '100% On-Device Privacy • Zero Tracking',
        onTap: () => _openUrl(AppStrings.privacyPolicyUrl),
        trailing: Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
      ),
      _buildDivider(context),
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.doc_text_fill,
        iconColor: const Color(0xFF3B82F6),
        title: s.termsOfUse,
        subtitle: s.isTr ? 'Kullanım Koşulları ve Lisans Sözleşmesi (EULA)' : 'End User License Agreement (EULA)',
        onTap: () => _openUrl(AppStrings.termsOfUseUrl),
        trailing: Icon(CupertinoIcons.chevron_right, color: colors.textTertiary, size: 15),
      ),
    ]);
  }

  // --- SECTION: DANGER ZONE ---
  Widget _buildDangerSection(BuildContext context) {
    return _buildGroupCard(context, [
      _buildSettingTile(
        context: context,
        icon: CupertinoIcons.trash_fill,
        iconColor: const Color(0xFFEF4444),
        title: s.profileTileResetApp,
        subtitle: s.profileTileResetAppSub,
        titleColor: const Color(0xFFEF4444),
        onTap: () {
          HapticFeedback.lightImpact();
          _showResetFullDialog(context);
        },
        trailing: const Icon(CupertinoIcons.chevron_right, color: Color(0xFFEF4444), size: 15),
      ),
    ]);
  }

  // --- REUSABLE GROUP CARD ---
  Widget _buildGroupCard(BuildContext context, List<Widget> children) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: context.colors.separator,
      height: 1,
      indent: 52,
      endIndent: 16,
    );
  }

  // --- REUSABLE SETTING TILE ---
  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: iconColor.withValues(alpha: 0.1),
      highlightColor: iconColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconColor.withValues(alpha: 0.25)),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: titleColor ?? colors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: colors.textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  // --- THEME SELECTION MODAL ---
  void _showThemeSelectionSheet(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  s.profileThemeSheetTitle,
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.profileThemeSheetSub,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption(
                  ctx: ctx,
                  title: s.profileThemeAutoTitle,
                  subtitle: s.profileThemeAutoSub,
                  icon: CupertinoIcons.circle_righthalf_fill,
                  iconColor: const Color(0xFF6366F1),
                  isSelected: appState.themeMode == ThemeMode.system,
                  onTap: () {
                    appState.setThemeMode(ThemeMode.system);
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  title: s.profileThemeLightTitle,
                  subtitle: s.profileThemeLightSub,
                  icon: CupertinoIcons.sun_max_fill,
                  iconColor: const Color(0xFFF59E0B),
                  isSelected: appState.themeMode == ThemeMode.light,
                  onTap: () {
                    appState.setThemeMode(ThemeMode.light);
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  title: s.profileThemeDarkTitle,
                  subtitle: s.profileThemeDarkSub,
                  icon: CupertinoIcons.moon_stars_fill,
                  iconColor: const Color(0xFF8B5CF6),
                  isSelected: appState.themeMode == ThemeMode.dark,
                  onTap: () {
                    appState.setThemeMode(ThemeMode.dark);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    final colors = context.colors;
    final s = appState.strings;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  s.languageTitle,
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.isTr ? 'Uygulamanın görüntüleneceği dili seçin' : 'Select your preferred app language',
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption(
                  ctx: ctx,
                  title: s.languageSystem,
                  subtitle: s.isTr ? 'Telefonunuzun sistem dilini takip eder' : 'Follows device system language',
                  icon: CupertinoIcons.device_phone_portrait,
                  iconColor: const Color(0xFF6366F1),
                  isSelected: appState.languagePreference == 'system',
                  onTap: () {
                    appState.setLanguage('system');
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  title: 'Türkçe',
                  subtitle: s.isTr ? 'Varsayılan Türkçe arayüz ve bildirimler' : 'Default Turkish interface & notifications',
                  icon: CupertinoIcons.globe,
                  iconColor: const Color(0xFF00E676),
                  isSelected: appState.languagePreference == 'tr',
                  onTap: () {
                    appState.setLanguage('tr');
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  title: 'English',
                  subtitle: s.isTr ? 'Global İngilizce arayüz ve bildirimler' : 'Global English interface & notifications',
                  icon: CupertinoIcons.globe,
                  iconColor: const Color(0xFF38BDF8),
                  isSelected: appState.languagePreference == 'en',
                  onTap: () {
                    appState.setLanguage('en');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext ctx,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = ctx.colors;
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? iconColor.withValues(alpha: 0.1) : colors.surfaceCardAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? iconColor : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(CupertinoIcons.checkmark_circle_fill, color: iconColor, size: 22)
            else
              Icon(CupertinoIcons.circle, color: colors.border, size: 22),
          ],
        ),
      ),
    );
  }

  // --- RESET QUIT DATE DIALOG (NATIVE IOS POPUP - REFINE STYLE) ---
  void _showResetQuitDialog(BuildContext context) {
    final colors = context.colors;
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: colors.isDark ? Brightness.dark : Brightness.light,
          primaryColor: const Color(0xFF00E676),
        ),
        child: CupertinoAlertDialog(
          title: Text(
            s.profileResetStreakDialogTitle,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              s.profileResetStreakDialogBody,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                s.profileDialogCancel,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                HapticFeedback.mediumImpact();
                appState.resetQuitDate();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: colors.isDark ? const Color(0xFF0F172A) : context.colors.textPrimary,
                    content: Row(
                      children: [
                        const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF00E676), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.profileResetStreakSnack,
                            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Text(
                s.profileResetStreakConfirm,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- RESET FULL APP DIALOG (NATIVE IOS POPUP - REFINE HESABI SİL BİREBİR AYNI) ---
  void _showResetFullDialog(BuildContext context) {
    final colors = context.colors;
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: colors.isDark ? Brightness.dark : Brightness.light,
          primaryColor: const Color(0xFF00E676),
        ),
        child: CupertinoAlertDialog(
          title: Text(
            s.profileResetAppDialogTitle,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              s.profileResetAppDialogBody,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                s.profileDialogCancel,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                HapticFeedback.heavyImpact();
                Navigator.pop(ctx);
                await appState.resetFullApp();
              },
              child: Text(
                s.profileResetAppConfirm,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- VIP MEMBERSHIP DETAILS SCREEN ---
  void _openVipDetailsScreen(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => VipMembershipDetailsScreen(appState: appState),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    HapticFeedback.lightImpact();
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching url: $e');
    }
  }
}
