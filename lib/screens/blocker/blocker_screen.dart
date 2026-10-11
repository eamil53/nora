import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_strings.dart';
import '../../models/blocker_category.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';

class BlockerScreen extends StatefulWidget {
  final AppState appState;

  const BlockerScreen({super.key, required this.appState});

  @override
  State<BlockerScreen> createState() => _BlockerScreenState();
}

class _BlockerScreenState extends State<BlockerScreen> {
  AppStrings get s => widget.appState.strings;
  final TextEditingController _customDomainController = TextEditingController();
  bool _isAddingDomain = false;

  @override
  void dispose() {
    _customDomainController.dispose();
    super.dispose();
  }

  Future<void> _handleSiteEklePressed() async {
    final s = widget.appState.strings;
    HapticFeedback.lightImpact();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final res = await widget.appState.presentAddCustomDomainSheet();
        if (res != null && mounted) {
          final domain = res['domain'] ?? '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: const Color(0xFF0F172A),
              content: Row(
                children: [
                  const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF00E676), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.siteAddedSuccess(domain),
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // If native code is not yet loaded, fallback gracefully to inline input
        if (mounted) {
          setState(() => _isAddingDomain = !_isAddingDomain);
        }
      }
    } else {
      setState(() => _isAddingDomain = !_isAddingDomain);
    }
  }

  void _addCustomDomain() {
    final s = widget.appState.strings;
    final text = _customDomainController.text.trim();
    if (text.isNotEmpty) {
      HapticFeedback.mediumImpact();
      widget.appState.addCustomDomain(text);
      _customDomainController.clear();
      FocusScope.of(context).unfocus();
      setState(() => _isAddingDomain = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFF0F172A),
          content: Row(
            children: [
              const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF00E676), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.siteAddedSuccess(text),
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final state = widget.appState;
        final s = state.strings;
        final totalBlockedDomains = state.categories.fold<int>(0, (sum, cat) => sum + cat.blockedCount) +
            state.customBlockedDomains.length;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: context.colors.surfaceCanvas,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(CupertinoIcons.shield_lefthalf_fill, color: Color(0xFF00E676), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.shieldHub,
                      style: GoogleFonts.outfit(
                        color: context.colors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      s.appleWebKitProtection,
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colors.surfaceCardAlt,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(CupertinoIcons.info, color: context.colors.textSecondary, size: 16),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                _showInfoDialog(context);
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Stack(
          children: [
            // Ambient light glows
            Positioned(
              top: -50,
              right: -50,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00E676).withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: -60,
              child: IgnorePointer(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6366F1).withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Threat alerts if active
                    if (state.isBypassThreatActive) ...[
                      _buildBypassThreatBanner(state)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.1, end: 0),
                      const SizedBox(height: 16),
                    ],

                    if (state.nativeAuthStatus != 'approved') ...[
                      _buildPermissionBanner(state)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.1, end: 0),
                      const SizedBox(height: 16),
                    ],

                    // 1. HERO MASTER SHIELD RADAR CARD
                    _buildMasterShieldCard(state, totalBlockedDomains)
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.97, 0.97), curve: Curves.easeOutCubic),

                    const SizedBox(height: 20),

                    // 2. QUICK SHIELD ACTION MODULES (2x2 GRID)
                    Text(
                      s.shieldModules,
                      style: GoogleFonts.outfit(
                        color: context.colors.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildModulesGrid(state)
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 150.ms)
                        .slideY(begin: 0.05, end: 0),

                    const SizedBox(height: 24),

                    // 3. SPECIAL CUSTOM BLOCKLIST SECTION
                    _buildCustomBlocklistSection(state)
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 250.ms)
                        .slideY(begin: 0.05, end: 0),

                    const SizedBox(height: 24),

                    // 4. CATEGORY FILTERS ACCORDION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            s.blockedCategories,
                            style: GoogleFonts.outfit(
                              color: context.colors.textTertiary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF00E676).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            s.allLocked,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF00E676),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ...state.categories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cat = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCategoryCard(cat, s.isTr)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: (300 + index * 60).ms)
                            .slideY(begin: 0.05, end: 0),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  // --- 1. HERO MASTER SHIELD RADAR CARD ---
  Widget _buildMasterShieldCard(AppState state, int totalBlockedDomains) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF052A20),
            Color(0xFF081F19),
            Color(0xFF0A1220),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00E676).withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withValues(alpha: 0.12),
            blurRadius: 36,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Ambient radar glow
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00E676).withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Pulsing radar shield icon
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00E676).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676).withValues(alpha: 0.25),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.shield_fill,
                          color: Color(0xFF00E676),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF00E676),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    s.protectionActiveStrict,
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF00E676),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.filtersCount(totalBlockedDomains),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.protectionSubtext,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 3 Status Badges
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatusIndicator(
                            label: 'WebKit',
                            status: s.statusWebKit,
                            isPositive: true,
                            icon: CupertinoIcons.lock_fill,
                          ),
                        ),
                        Container(width: 1, height: 20, color: Colors.white12),
                        Expanded(
                          child: _buildStatusIndicator(
                            label: 'Screen Time',
                            status: state.nativeAuthStatus == 'approved'
                                ? (s.isTr ? 'Yetkili' : 'Authorized')
                                : (s.isTr ? 'İzin Bekliyor' : 'Pending'),
                            isPositive: state.nativeAuthStatus == 'approved',
                            icon: CupertinoIcons.device_phone_portrait,
                          ),
                        ),
                        Container(width: 1, height: 20, color: Colors.white12),
                        Expanded(
                          child: _buildStatusIndicator(
                            label: 'Anti-Bypass',
                            status: state.isBypassThreatActive
                                ? (s.isTr ? 'Tehdit Var' : 'Threat')
                                : (s.isTr ? 'Güvende' : 'Secured'),
                            isPositive: !state.isBypassThreatActive,
                            icon: CupertinoIcons.checkmark_shield_fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required String label,
    required String status,
    required bool isPositive,
    required IconData icon,
  }) {
    final color = isPositive ? const Color(0xFF00E676) : const Color(0xFFF59E0B);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white54,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                status,
                style: GoogleFonts.plusJakartaSans(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 2. QUICK SHIELD ACTION MODULES (2x2 GRID) ---
  Widget _buildModulesGrid(AppState state) {
    final s = state.strings;
    return Row(
      children: [
        // Card 1: App Shielding
        Expanded(
          child: _buildActionTile(
            title: s.isTr ? 'Mobil Uygulamalar' : 'Mobile Apps',
            subtitle: state.hasShieldedApps
                ? (s.isTr ? '${state.shieldedAppsCount} Uygulama Kilitli' : '${state.shieldedAppsCount} Apps Locked')
                : (s.isTr ? 'Kumar Uygulamalarını Kilitle' : 'Lock Gambling Apps'),
            badgeText: state.hasShieldedApps ? (s.isTr ? 'Düzenle' : 'Edit') : (s.isTr ? 'Seç' : 'Select'),
            icon: CupertinoIcons.app_badge_fill,
            iconColor: const Color(0xFF818CF8),
            backgroundColor: const Color(0xFF131835),
            borderColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
            onTap: () {
              HapticFeedback.selectionClick();
              state.selectAppsToBlock();
            },
          ),
        ),
        const SizedBox(width: 12),
        // Card 2: VPN & Anti Bypass
        Expanded(
          child: _buildActionTile(
            title: s.moduleAntiBypassTitle,
            subtitle: state.antiBypassEnabled
                ? (s.isTr ? 'VPN / Silme Kilitli' : 'VPN / Removal Locked')
                : (s.isTr ? 'Kalkan Pasif' : 'Shield Inactive'),
            badgeText: state.antiBypassEnabled ? (s.isTr ? 'Devrede' : 'Active') : (s.isTr ? 'Aç' : 'Enable'),
            icon: CupertinoIcons.lock_shield_fill,
            iconColor: state.antiBypassEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
            backgroundColor: const Color(0xFF0E1A1E),
            borderColor: const Color(0xFF14B8A6).withValues(alpha: 0.3),
            onTap: () {
              HapticFeedback.selectionClick();
              state.toggleAntiBypass(!state.antiBypassEnabled);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.isDark ? backgroundColor : colors.surfaceCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colors.isDark ? borderColor : colors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.plusJakartaSans(
                      color: colors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. SPECIAL CUSTOM BLOCKLIST SECTION ---
  Widget _buildCustomBlocklistSection(AppState state) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(26),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.list_bullet_below_rectangle, color: Color(0xFFF59E0B), size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.customBlocklist,
                        style: GoogleFonts.outfit(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _handleSiteEklePressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isAddingDomain
                        ? colors.surfaceCardAlt
                        : const Color(0xFF00E676).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isAddingDomain ? colors.border : const Color(0xFF00E676).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isAddingDomain ? CupertinoIcons.minus : CupertinoIcons.add,
                        color: _isAddingDomain ? colors.textSecondary : const Color(0xFF00E676),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isAddingDomain ? s.close : s.addDomainButton,
                        style: GoogleFonts.plusJakartaSans(
                          color: _isAddingDomain ? colors.textSecondary : const Color(0xFF00E676),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.customBlocklistSub,
            style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 12),
          ),

          // Input field if open
          if (_isAddingDomain) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceCardAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border),
                    ),
                    child: TextField(
                      controller: _customDomainController,
                      style: GoogleFonts.plusJakartaSans(color: colors.textPrimary, fontSize: 13),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addCustomDomain(),
                      decoration: InputDecoration(
                        hintText: s.addDomainHint,
                        hintStyle: GoogleFonts.plusJakartaSans(color: colors.textTertiary, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF070B14),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: _addCustomDomain,
                  child: Text(
                    s.isTr ? 'Ekle' : 'Add',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],

          if (state.customBlockedDomains.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.customBlockedDomains.map((domain) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.shield_slash, color: Color(0xFF00E676), size: 12),
                      const SizedBox(width: 6),
                      Text(
                        domain,
                        style: GoogleFonts.plusJakartaSans(
                          color: colors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          state.removeCustomDomain(domain);
                        },
                        child: Icon(CupertinoIcons.clear_circled_solid, color: colors.textTertiary, size: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // --- 4. CATEGORY CARD ---
  Widget _buildCategoryCard(dynamic cat, bool isTr) {
    final color = _getCategoryColor(cat.id);
    final title = cat is BlockerCategory ? cat.getTitle(isTr) : cat.title as String;
    final description = cat is BlockerCategory ? cat.getDescription(isTr) : cat.description as String;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(_getCategoryIcon(cat.id), color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: title,
                    style: GoogleFonts.outfit(
                      color: context.colors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: ' • ${cat.blockedCount} ${isTr ? 'Site' : 'Sites'}',
                        style: GoogleFonts.plusJakartaSans(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textSecondary,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF00E676), size: 12),
                const SizedBox(width: 4),
                Text(
                  isTr ? 'Kilitli' : 'Locked',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF00E676),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBypassThreatBanner(AppState state) {
    final colors = context.colors;
    final isTr = s.isTr;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.exclamationmark_shield_fill, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTr ? '🚨 VPN / Proxy Algılandı!' : '🚨 VPN / Proxy Detected!',
                  style: GoogleFonts.outfit(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14.5),
                ),
                const SizedBox(height: 3),
                Text(
                  isTr
                      ? 'Engellemeleri aşmaya yönelik aktif VPN tespit edildi (${state.vpnInterface.isNotEmpty ? state.vpnInterface : "Tünel"}). Kalkanın çalışması için kapatın.'
                      : 'Active VPN detected attempting to bypass blocks (${state.vpnInterface.isNotEmpty ? state.vpnInterface : "Tunnel"}). Disable VPN for the shield to function.',
                  style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final uri = Uri.parse('app-settings:');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Text(isTr ? 'Kapat' : 'Disable', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionBanner(AppState state) {
    final colors = context.colors;
    final s = state.strings;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.blockerPermissionTitle,
                  style: GoogleFonts.outfit(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  s.blockerPermissionDesc,
                  style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF070B14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => state.requestNativePermissions(),
            child: Text(s.blockerPermissionBtn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String id) {
    switch (id) {
      case 'legal_betting':
        return CupertinoIcons.sportscourt_fill;
      case 'illegal_betting':
        return CupertinoIcons.exclamationmark_shield_fill;
      case 'casino_slots':
        return CupertinoIcons.suit_spade_fill;
      case 'high_risk_forex':
        return CupertinoIcons.chart_bar_alt_fill;
      default:
        return CupertinoIcons.slash_circle_fill;
    }
  }

  Color _getCategoryColor(String id) {
    switch (id) {
      case 'legal_betting':
        return const Color(0xFF38BDF8);
      case 'illegal_betting':
        return const Color(0xFFEF4444);
      case 'casino_slots':
        return const Color(0xFFF59E0B);
      case 'high_risk_forex':
        return const Color(0xFF818CF8);
      default:
        return const Color(0xFF10B981);
    }
  }

  void _showInfoDialog(BuildContext context) {
    final colors = context.colors;
    final s = widget.appState.strings;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E676), width: 1.5),
              ),
              child: const Icon(CupertinoIcons.shield_lefthalf_fill, color: Color(0xFF00E676), size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              s.blockerHowItWorksTitle,
              style: GoogleFonts.outfit(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              s.blockerHowItWorksBody,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(CupertinoIcons.cloud_upload, size: 18),
                label: Text(
                  'Varsayılan Siteleri Firestore\'a Aktar',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await widget.appState.seedBlockedSitesToFirestore(force: true);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: const Color(0xFF0F172A),
                        content: Row(
                          children: [
                            const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF00E676), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Dahili siteler Firestore veritabanına aktarıldı!',
                                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: const Color(0xFF070B14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(s.understood, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
