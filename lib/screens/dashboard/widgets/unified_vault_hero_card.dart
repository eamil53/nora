import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/user_profile.dart';

class UnifiedVaultHeroCard extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback? onStreakTap;
  final String? languageCode;

  const UnifiedVaultHeroCard({
    super.key,
    required this.profile,
    this.onStreakTap,
    this.languageCode,
  });

  @override
  State<UnifiedVaultHeroCard> createState() => _UnifiedVaultHeroCardState();
}

class _UnifiedVaultHeroCardState extends State<UnifiedVaultHeroCard> {
  int _selectedTab = 0; // 0: Nakit, 1: Zaman, 2: Engellenen

  @override
  Widget build(BuildContext context) {
    final isTr = (widget.languageCode ?? 'tr').toLowerCase().startsWith('tr');
    final profile = widget.profile;
    final now = DateTime.now();
    final difference = now.difference(profile.quitDate);
    final isNegative = difference.isNegative;

    final totalSeconds = isNegative ? 0 : difference.inSeconds;
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final savedMoney = profile.calculateSavedMoney(now: now);
    final savedHours = profile.calculateSavedHours(now: now);
    final dailySpend = profile.monthlySpend / 30.0;
    final estimatedPreventedBets = (days * 4 + (savedHours * 1.5)).toInt();

    final (nextMilestoneDays, prevMilestoneDays, milestoneTitle) = _getMilestoneInfo(days, isTr);
    final progressInTier = (nextMilestoneDays == prevMilestoneDays)
        ? 1.0
        : ((days - prevMilestoneDays) / (nextMilestoneDays - prevMilestoneDays)).clamp(0.05, 1.0);

    final currencyFormatter = NumberFormat.currency(
      locale: isTr ? 'tr_TR' : 'en_US',
      symbol: profile.currencySymbol,
      decimalDigits: 2,
    );

    final yearlyFormatted = NumberFormat.currency(
      locale: isTr ? 'tr_TR' : 'en_US',
      symbol: profile.currencySymbol,
      decimalDigits: 0,
    ).format(profile.yearlyProjectedSavings);

    final dailyFormatted = NumberFormat.currency(
      locale: isTr ? 'tr_TR' : 'en_US',
      symbol: profile.currencySymbol,
      decimalDigits: 0,
    ).format(dailySpend);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF042F24), // Ultra deep emerald
            Color(0xFF081F1B), // Dark pine
            Color(0xFF07121E), // Deep midnight blue-black
          ],
        ),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withValues(alpha: 0.12),
            blurRadius: 36,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Ambient radial light top-right
            Positioned(
              right: -30,
              top: -30,
              child: IgnorePointer(
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00E676).withValues(alpha: 0.20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Ambient radial light bottom-left
            Positioned(
              left: -40,
              bottom: -40,
              child: IgnorePointer(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF06B6D4).withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP ZONE: CLEAN STREAK & LIVE TIME ORB ---
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onStreakTap?.call();
                    },
                    child: Row(
                      children: [
                        // Mini Circular Progress Arc
                        SizedBox(
                          width: 66,
                          height: 66,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(66, 66),
                                painter: _MiniArcPainter(
                                  progress: progressInTier,
                                  trackColor: Colors.white.withValues(alpha: 0.08),
                                  activeColor: const Color(0xFF00E676),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$days',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    isTr ? 'GÜN' : 'DAYS',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF00E676),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Streak Titles & Live Timer Capsule
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const _PulsingGreenDot(),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      isTr ? 'KUMARSIZ GEÇEN SÜRE' : 'GAMBLING-FREE TIME',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF34D399),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.12),
                                      ),
                                    ),
                                    child: Text(
                                      isTr ? 'Hedef: $nextMilestoneDays Gün' : 'Goal: $nextMilestoneDays Days',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Live Time Capsule
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.timer,
                                        color: Color(0xFF00E676),
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      if (days > 0) ...[
                                        _buildTimePiece(isTr ? '$days g' : '${days}d'),
                                        _buildSeparator(),
                                      ],
                                      _buildTimePiece(isTr ? '${hours.toString().padLeft(2, '0')} sa' : '${hours.toString().padLeft(2, '0')}h'),
                                      _buildSeparator(),
                                      _buildTimePiece(isTr ? '${minutes.toString().padLeft(2, '0')} dk' : '${minutes.toString().padLeft(2, '0')}m'),
                                      _buildSeparator(),
                                      _buildTimePiece(
                                        isTr ? '${seconds.toString().padLeft(2, '0')} sn' : '${seconds.toString().padLeft(2, '0')}s',
                                        isHighlight: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                milestoneTitle,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white60,
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
                  ),

                  const SizedBox(height: 20),

                  // Divider with jewel center
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.12),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.12),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // --- CENTERPIECE: FINANCIAL VAULT ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                CupertinoIcons.lock_shield_fill,
                                color: Color(0xFF00E676),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isTr ? 'GÜVENLİ KASA' : 'SECURE VAULT',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF6EE7B7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Tab Selector Chips
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMiniTab(0, isTr ? 'Nakit' : 'Cash'),
                            _buildMiniTab(1, isTr ? 'Zaman' : 'Time'),
                            _buildMiniTab(2, isTr ? 'Dürtü' : 'Urge'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Main Big Dynamic Display
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _buildDynamicVaultContent(
                      savedMoney: savedMoney,
                      savedHours: savedHours,
                      preventedBets: estimatedPreventedBets,
                      formatter: currencyFormatter,
                      isTr: isTr,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- BOTTOM MICRO-CAPSULES: DAILY, YEARLY, WILLPOWER ---
                  Row(
                    children: [
                      _buildMetricCapsule(
                        label: isTr ? 'GÜNLÜK HIZ' : 'DAILY RATE',
                        value: dailyFormatted,
                        subtext: isTr ? 'Her gün cebinde' : 'Saved daily',
                        icon: CupertinoIcons.arrow_up_right_circle_fill,
                        accentColor: const Color(0xFF34D399),
                      ),
                      const SizedBox(width: 10),
                      _buildMetricCapsule(
                        label: isTr ? '1 YIL HEDEFİ' : '1-YEAR GOAL',
                        value: yearlyFormatted,
                        subtext: isTr ? 'Kurtarılan gelecek' : 'Secured future',
                        icon: CupertinoIcons.sparkles,
                        accentColor: const Color(0xFFFBBF24),
                      ),
                      const SizedBox(width: 10),
                      _buildMetricCapsule(
                        label: isTr ? 'ÖZGÜR ZAMAN' : 'FREE TIME',
                        value: isTr ? '${savedHours.toStringAsFixed(1)} Sa' : '${savedHours.toStringAsFixed(1)}h',
                        subtext: isTr ? 'Kazanılan yaşam' : 'Life reclaimed',
                        icon: CupertinoIcons.time,
                        accentColor: const Color(0xFF818CF8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(
      duration: 3.5.seconds,
      color: Colors.white.withValues(alpha: 0.05),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildMiniTab(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTab != index) {
          HapticFeedback.selectionClick();
          setState(() => _selectedTab = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicVaultContent({
    required double savedMoney,
    required double savedHours,
    required int preventedBets,
    required NumberFormat formatter,
    required bool isTr,
  }) {
    if (_selectedTab == 0) {
      return Column(
        key: const ValueKey('vault_money'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatter.format(savedMoney),
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isTr
                ? 'Kumar sitelerine kaptırmayıp ailene ve kendine sakladığın gerçek para.'
                : 'Real money kept safe for you and your family instead of gambling sites.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Column(
        key: const ValueKey('vault_time'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  savedHours.toStringAsFixed(1),
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isTr ? 'Saat Yaşam' : 'Hours of Life',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF6EE7B7),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isTr
                ? 'Kayıp kuponlar peşinde değil, hayatın içinde geçen değerli saatler.'
                : 'Precious hours spent living your life, not chasing lost bets.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey('vault_bets'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$preventedBets',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isTr ? 'Dürtü Püskürtüldü' : 'Urges Defeated',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF6EE7B7),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isTr
                ? 'Her geri çevrilen istek iradeni çelikleştiriyor ve beynini iyileştiriyor.'
                : 'Every resisted urge strengthens your willpower and resets dopamine loops.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMetricCapsule({
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 13),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white38,
                fontSize: 9.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePiece(String text, {bool isHighlight = false}) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: isHighlight ? const Color(0xFF00E676) : Colors.white,
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        fontFeatures: const [ui.FontFeature.tabularFigures()],
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.25),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  (int next, int prev, String title) _getMilestoneInfo(int daysClean, bool isTr) {
    if (daysClean < 1) {
      return (1, 0, isTr ? '1. Gün: Kurtuluşun İlk Günü' : 'Day 1: First Day of Freedom');
    } else if (daysClean < 3) {
      return (3, 1, isTr ? '3. Gün: Dopamin Çekilme Zirvesi' : 'Day 3: Dopamine Withdrawal Peak');
    } else if (daysClean < 7) {
      return (7, 3, isTr ? '1. Hafta: İrade Kalkanı Güçleniyor' : 'Week 1: Willpower Shield Strengthening');
    } else if (daysClean < 14) {
      return (14, 7, isTr ? '2. Hafta: Zihinsel Berraklık' : 'Week 2: Mental Clarity');
    } else if (daysClean < 30) {
      return (30, 14, isTr ? '1. Ay: Yeni Yaşam Düzeni' : 'Month 1: New Life Pattern');
    } else if (daysClean < 90) {
      return (90, 30, isTr ? '3. Ay: Alışkanlık Kırıldı' : 'Month 3: Habit Loop Broken');
    } else if (daysClean < 365) {
      return (365, 90, isTr ? '1. Yıl: Kalıcı Zafer' : 'Year 1: Permanent Victory');
    } else {
      return (daysClean + 30, daysClean, isTr ? 'Efsanevi Bağımsızlık' : 'Legendary Independence');
    }
  }
}

class _MiniArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color activeColor;

  _MiniArcPainter({
    required this.progress,
    required this.trackColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const strokeWidth = 5.5;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.01, 1.0);

    final glowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, progressPaint);

    // Tip dot
    final tipAngle = startAngle + sweepAngle;
    final tipX = center.dx + radius * math.cos(tipAngle);
    final tipY = center.dy + radius * math.sin(tipAngle);

    canvas.drawCircle(Offset(tipX, tipY), 3.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _MiniArcPainter oldDelegate) => oldDelegate.progress != progress;
}

class _PulsingGreenDot extends StatefulWidget {
  const _PulsingGreenDot();

  @override
  State<_PulsingGreenDot> createState() => _PulsingGreenDotState();
}

class _PulsingGreenDotState extends State<_PulsingGreenDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _scale = Tween<double>(begin: 0.85, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: const Color(0xFF00E676),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E676).withValues(alpha: 0.8),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
