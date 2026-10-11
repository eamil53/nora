import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/app_state.dart';
import '../blocker/blocker_screen.dart';
import '../sos/urge_surfing_screen.dart';
import '../journal/journal_screen.dart';
import '../profile/profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'widgets/unified_vault_hero_card.dart';
import 'widgets/recovery_progress_chart.dart';
import 'widgets/daily_quote_card.dart';
import 'widgets/milestone_badges_view.dart';

bool get isCupertino => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

class MainDashboard extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOpenPaywall;

  const MainDashboard({
    super.key,
    required this.appState,
    required this.onOpenPaywall,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  Timer? _liveTicker;
  bool _hasPromptedPermission = false;

  @override
  void initState() {
    super.initState();
    // Live update money saved every second
    _liveTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    _checkAndPromptPermission();
  }

  void _checkAndPromptPermission() {
    if (_hasPromptedPermission) return;
    _hasPromptedPermission = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (widget.appState.nativeAuthStatus != 'approved') {
        await widget.appState.requestNativePermissions();
        if (!mounted) return;
        if (widget.appState.nativeAuthStatus != 'approved') {
          _showPermissionWarningModal();
        }
      }
    });
  }

  void _showPermissionWarningModal() {
    final s = widget.appState.strings;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: context.colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final colors = context.colors;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: Color(0xFFF59E0B), size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                s.isTr ? 'Ekran Süresi İzni Verilmedi!' : 'Screen Time Permission Required!',
                style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                s.isTr
                    ? 'Kumar sitelerini engelleyebilmek için Apple Ekran Süresi izni şarttır.'
                    : 'Screen Time permission is required to enforce device-level blocking.',
                style: TextStyle(color: colors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: const Color(0xFF0B1120),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.verified_user_rounded),
                  label: Text(s.isTr ? 'Şimdi İzin Ver' : 'Grant Permission Now', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    Navigator.pop(context);
                    await widget.appState.requestNativePermissions();
                    if (mounted && widget.appState.nativeAuthStatus != 'approved') {
                      _showPermissionWarningModal();
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(s.isTr ? 'Anladım, Riskleri Kabul Ediyorum' : 'I Understand the Risks', style: const TextStyle(color: Colors.white38, fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _liveTicker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;

    final List<Widget> pages = [
      _buildHomeDashboard(state),
      BlockerScreen(appState: state),
      UrgeSurfingScreen(appState: state),
      JournalScreen(appState: state),
      ProfileScreen(appState: state, onOpenPaywall: widget.onOpenPaywall),
    ];

    return Scaffold(
      backgroundColor: context.colors.surfaceCanvas,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          if (state.isBypassThreatActive)
            _buildVpnLockdownOverlay(state),
        ],
      ),
      bottomNavigationBar: state.isBypassThreatActive
          ? null
          : (isCupertino ? _buildGlassBar(context) : _buildBar(context)),
    );
  }

  Widget _buildVpnLockdownOverlay(AppState state) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF070B14).withValues(alpha: 0.96),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEF4444), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.lock_shield_fill,
                      color: Color(0xFFEF4444),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'VPN / Vekil Sunucu Algılandı!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      state.strings.isTr
                          ? '🚨 Erişim Güvenlik Nedeniyle Kilitlendi'
                          : '🚨 Access Locked for Protection',
                      style: const TextStyle(
                        color: Color(0xFFFCA5A5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    state.strings.isTr
                        ? 'Nora Güvenlik Protokolü Devrede.\n\nKumar engellemesini aşmaya yönelik bir VPN bağlantısı tespit edildi. Kriz anlarında engellemeleri atlatmanızı önlemek amacıyla Nora tamamen kilitlenmiştir.\n\nUygulamayı kullanmaya devam edebilmek için lütfen Ayarlar\'dan VPN bağlantısını kapatın.'
                        : 'Nora Security Protocol Active.\n\nA VPN connection was detected attempting to bypass the gambling blocker. To protect you during urge spikes, Nora is locked.\n\nPlease disable VPN in Settings to continue.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.settings_suggest_rounded, size: 22),
                      label: Text(
                        state.strings.isTr ? 'Ayarlar\'dan VPN\'i Kapat' : 'Disable VPN in Settings',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        final uri = Uri.parse('app-settings:');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton.icon(
                    onPressed: () => state.checkVpnStatus(),
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white54, size: 18),
                    label: Text(
                      state.strings.isTr ? 'Bağlantıyı Yeniden Kontrol Et' : 'Recheck Connection',
                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.strings.isTr
                        ? '✅ VPN kapatıldığı anda kilit otomatik olarak kalkacaktır.'
                        : '✅ Lock will automatically release once VPN is disabled.',
                    style: const TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBar(BuildContext context) {
    final s = widget.appState.strings;
    return GlassTabBar.bottom(
      tabs: [
        GlassTab(
          icon: const Icon(CupertinoIcons.house, size: 20),
          activeIcon: const Icon(CupertinoIcons.house_fill, size: 20),
          label: s.isTr ? 'Ana Sayfa' : 'Home',
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.shield, size: 20),
          activeIcon: const Icon(CupertinoIcons.shield_fill, size: 20),
          label: s.isTr ? 'Engelleme' : 'Shield',
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.bolt, size: 20),
          activeIcon: const Icon(CupertinoIcons.bolt_fill, size: 20),
          label: s.isTr ? 'Kriz SOS' : 'SOS Urge',
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.book, size: 20),
          activeIcon: const Icon(CupertinoIcons.book_fill, size: 20),
          label: s.isTr ? 'Günlük' : 'Journal',
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.person, size: 20),
          activeIcon: const Icon(CupertinoIcons.person_fill, size: 20),
          label: s.isTr ? 'Profil' : 'Profile',
        ),
      ],
      selectedIndex: _currentIndex,
      onTabSelected: (tab) => setState(() => _currentIndex = tab),
      selectedIconColor: const Color(0xFF00E676),
      selectedLabelColor: const Color(0xFF00E676),
      unselectedIconColor: context.colors.bottomBarUnselected,
      unselectedLabelColor: context.colors.bottomBarUnselected,
      indicatorColor: const Color(0xFF00E676).withValues(alpha: 0.15),
      settings: LiquidGlassSettings(
        glassColor: context.colors.isDark ? const Color(0xEB000000) : const Color(0xEBF8FAFC),
        blur: 24,
      ),
      iconSize: 20,
      barHeight: 64,
    );
  }

  Widget _buildBar(BuildContext context) {
    final s = widget.appState.strings;
    final items = [
      (
        icon: CupertinoIcons.house,
        activeIcon: CupertinoIcons.house_fill,
        label: s.isTr ? 'Ana Sayfa' : 'Home',
        tab: 0,
      ),
      (
        icon: CupertinoIcons.shield,
        activeIcon: CupertinoIcons.shield_fill,
        label: s.isTr ? 'Engelleme' : 'Shield',
        tab: 1,
      ),
      (
        icon: CupertinoIcons.bolt,
        activeIcon: CupertinoIcons.bolt_fill,
        label: s.isTr ? 'Kriz SOS' : 'SOS Urge',
        tab: 2,
      ),
      (
        icon: CupertinoIcons.book,
        activeIcon: CupertinoIcons.book_fill,
        label: s.isTr ? 'Günlük' : 'Journal',
        tab: 3,
      ),
      (
        icon: CupertinoIcons.person,
        activeIcon: CupertinoIcons.person_fill,
        label: s.isTr ? 'Profil' : 'Profile',
        tab: 4,
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.paddingOf(context).bottom > 0 ? 8 : 16,
      ),
      child: _FrostedBarSurface(
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _currentIndex = item.tab),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _currentIndex == item.tab ? item.activeIcon : item.icon,
                            size: 20,
                            color: _currentIndex == item.tab
                                ? const Color(0xFF00E676)
                                : context.colors.bottomBarUnselected,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: _currentIndex == item.tab
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _currentIndex == item.tab
                                  ? const Color(0xFF00E676)
                                  : context.colors.bottomBarUnselected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(AppState state) {
    final profile = state.userProfile;
    final daysClean = profile.calculateDaysClean();

    return Stack(
      children: [
        // Ambient background glow meshes
        Positioned(
          top: -60,
          right: -60,
          child: IgnorePointer(
            child: Container(
              width: 240,
              height: 240,
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
          top: 350,
          left: -80,
          child: IgnorePointer(
            child: Container(
              width: 260,
              height: 260,
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isBypassThreatActive) ...[
                  _buildBypassThreatBanner(state)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0),
                  const SizedBox(height: 16),
                ],

                // Top Luxury Header Bar
                _buildTopHeader(state, daysClean)
                    .animate()
                    .fadeIn(duration: 450.ms)
                    .slideY(begin: -0.05, end: 0),

                const SizedBox(height: 18),

                // Unified Sovereign Vault & Clean Streak Masterpiece Card
                UnifiedVaultHeroCard(
                  profile: profile,
                  languageCode: state.languageCode,
                  onStreakTap: () => setState(() => _currentIndex = 3), // open journal
                ).animate()
                 .fadeIn(duration: 500.ms, delay: 100.ms)
                 .scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), curve: Curves.easeOutCubic),

                const SizedBox(height: 16),

                // Quick SOS Emergency Callout Banner
                _buildEmergencySosBanner()
                    .animate()
                    .fadeIn(duration: 450.ms, delay: 200.ms)
                    .slideY(begin: 0.05, end: 0),

                const SizedBox(height: 16),

                // Daily Victory Check-In Action
                _buildDailyCheckInBanner(daysClean)
                    .animate()
                    .fadeIn(duration: 450.ms, delay: 300.ms),

                const SizedBox(height: 20),

                // Dopamine Neuro-Recovery Curve (fl_chart)
                RecoveryProgressChart(
                  daysClean: daysClean,
                  languageCode: state.languageCode,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 340.ms)
                    .slideY(begin: 0.05, end: 0),

                const SizedBox(height: 20),

                // Daily Stoic / Mindset Quote Card
                DailyQuoteCard(languageCode: state.languageCode)
                    .animate()
                    .fadeIn(duration: 450.ms, delay: 400.ms),

                const SizedBox(height: 24),

                // Milestone Badges Showcase
                MilestoneBadgesView(
                  daysClean: daysClean,
                  languageCode: state.languageCode,
                )
                    .animate()
                    .fadeIn(duration: 450.ms, delay: 460.ms),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader(AppState state, int daysClean) {
    final colors = context.colors;
    final s = state.strings;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.welcomeUpper,
              style: GoogleFonts.outfit(
                color: colors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              s.daysCleanVictory(daysClean),
              style: GoogleFonts.outfit(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),

        // Live Shield Badge
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _currentIndex = 1); // Go to blocker
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: state.isBlockerEnabled
                  ? const Color(0xFF00E676).withValues(alpha: 0.12)
                  : const Color(0xFFEF4444).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: state.isBlockerEnabled
                    ? const Color(0xFF00E676).withValues(alpha: 0.4)
                    : const Color(0xFFEF4444).withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: state.isBlockerEnabled
                      ? const Color(0xFF00E676).withValues(alpha: 0.08)
                      : const Color(0xFFEF4444).withValues(alpha: 0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444))
                            .withValues(alpha: 0.8),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  state.isBlockerEnabled ? s.shieldActive : s.shieldInactive,
                  style: GoogleFonts.plusJakartaSans(
                    color: state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBypassThreatBanner(AppState state) {
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
                  '🚨 VPN / Proxy Algılandı!',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kumar engellemesini aşmaya yönelik VPN tespit edildi. Korumayı sürdürmek için VPN\'i kapatın.',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, height: 1.3),
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
            child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySosBanner() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        setState(() => _currentIndex = 2); // Go to SOS
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF881337), Color(0xFFE11D48), Color(0xFFBE123C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFFDA4AF).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE11D48).withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.bolt_horizontal_circle_fill, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appState.strings.crisisCalloutTitle,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.appState.strings.crisisCalloutSub,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckInBanner(int daysClean) {
    final colors = context.colors;
    final s = widget.appState.strings;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.isDark ? const Color(0xFF131E35) : colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
              : const Color(0xFF0284C7).withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
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
              color: const Color(0xFF0284C7).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: Color(0xFF38BDF8),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.dailyCheckInTitle,
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.dailyCheckInSub,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              _showCelebrationDialog(context, daysClean);
            },
            child: Text(
              s.dailyCheckInButton,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCelebrationDialog(BuildContext context, int daysClean) {
    final colors = context.colors;
    final s = widget.appState.strings;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E676), width: 2),
                ),
                child: const Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  color: Color(0xFF00E676),
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                s.celebrationTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                s.celebrationBody,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: colors.textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF070B14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    s.celebrationButton,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
}

class _FrostedBarSurface extends StatelessWidget {
  const _FrostedBarSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(30));
    const blurSigma = 24.0;
    final colors = context.colors;

    return ClipRSuperellipse(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors.isDark
                  ? const [
                      Color(0xF00B0F14), // Deep pitch black-charcoal top
                      Color(0xF8000000), // Pure black bottom
                    ]
                  : const [
                      Color(0xF5FFFFFF), // Crisp pure white top
                      Color(0xF0F8FAFC), // Off-white bottom
                    ],
            ),
            border: Border.all(
              width: 0.8,
              color: colors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
