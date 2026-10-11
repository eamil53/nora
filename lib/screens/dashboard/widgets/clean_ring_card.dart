import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';

class CleanRingCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onTap;

  const CleanRingCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(profile.quitDate);
    final isNegative = difference.isNegative;

    final totalSeconds = isNegative ? 0 : difference.inSeconds;
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    // Milestone calculation
    final (nextMilestoneDays, prevMilestoneDays, milestoneTitle) = _getMilestoneInfo(days);
    final progressInTier = (nextMilestoneDays == prevMilestoneDays)
        ? 1.0
        : ((days - prevMilestoneDays) / (nextMilestoneDays - prevMilestoneDays)).clamp(0.05, 1.0);

    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: colors.surfaceCard,
          border: Border.all(
            color: colors.isDark
                ? const Color(0xFF00E676).withValues(alpha: 0.2)
                : const Color(0xFF00E676).withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E676).withValues(alpha: colors.isDark ? 0.08 : 0.06),
              blurRadius: 36,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Circular Ring with Central Stats
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient background glow
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF00E676).withValues(alpha: colors.isDark ? 0.18 : 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Custom circular arc painter
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _RingPainter(
                      progress: progressInTier,
                      trackColor: colors.surfaceCardAlt,
                      glowColor: const Color(0xFF00E676),
                    ),
                  ),

                  // Center Content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulsingDot(color: Color(0xFF00E676)),
                          const SizedBox(width: 6),
                          Text(
                            'KUMARSIZ GEÇEN',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF00B359),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$days',
                        style: GoogleFonts.outfit(
                          color: colors.textPrimary,
                          fontSize: 58,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Text(
                        'GÜN TEMİZ',
                        style: GoogleFonts.outfit(
                          color: colors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Target chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.surfaceCardAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors.border,
                          ),
                        ),
                        child: Text(
                          'Hedef: $nextMilestoneDays Gün',
                          style: GoogleFonts.plusJakartaSans(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Live Time Counter (Hours : Minutes : Seconds)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceCardAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.timer,
                    color: Color(0xFF00E676),
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  _buildTimeUnit(context, days > 0 ? '$days g' : null),
                  _buildTimeUnit(context, '${hours.toString().padLeft(2, '0')} sa'),
                  Text(
                    ':',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTimeUnit(context, '${minutes.toString().padLeft(2, '0')} dk'),
                  Text(
                    ':',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTimeUnit(
                    context,
                    '${seconds.toString().padLeft(2, '0')} sn',
                    isHighlight: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Milestone description & progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.sparkles,
                  color: Color(0xFFF59E0B),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  milestoneTitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '• ${(progressInTier * 100).toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF00E676),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String? text, {bool isHighlight = false}) {
    if (text == null) return const SizedBox.shrink();
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: isHighlight ? const Color(0xFF00E676) : colors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  (int next, int prev, String title) _getMilestoneInfo(int daysClean) {
    if (daysClean < 1) {
      return (1, 0, '1. Gün: Kurtuluşun İlk Günü');
    } else if (daysClean < 3) {
      return (3, 1, '3. Gün: Dopamin Çekilme Zirvesi');
    } else if (daysClean < 7) {
      return (7, 3, '1. Hafta: İrade Kalkanı Güçleniyor');
    } else if (daysClean < 14) {
      return (14, 7, '2. Hafta: Beyin Sisinden Kurtuluş');
    } else if (daysClean < 30) {
      return (30, 14, '1. Ay: Yeni Yaşam Düzeni');
    } else if (daysClean < 90) {
      return (90, 30, '3. Ay: Alışkanlık Döngüsü Kırıldı');
    } else if (daysClean < 365) {
      return (365, 90, '1. Yıl: Kalıcı Zafer ve Özgürlük');
    } else {
      return (daysClean + 30, daysClean, 'Efsanevi Bağımsızlık');
    }
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color glowColor;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 14.0;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    final sweepAngle = 2 * math.pi * progress.clamp(0.01, 1.0);
    const startAngle = -math.pi / 2;

    // Gradient shader for arc
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      colors: const [
        Color(0xFF00E676),
        Color(0xFF06B6D4),
        Color(0xFF6366F1),
        Color(0xFF00E676),
      ],
      transform: const GradientRotation(-math.pi / 2),
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Arc shadow/glow
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glowing tip indicator
    final tipAngle = startAngle + sweepAngle;
    final tipX = center.dx + radius * math.cos(tipAngle);
    final tipY = center.dy + radius * math.sin(tipAngle);

    final tipDotPaint = Paint()..color = Colors.white;
    final tipGlowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(Offset(tipX, tipY), 7, tipGlowPaint);
    canvas.drawCircle(Offset(tipX, tipY), 4, tipDotPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.25).animate(
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
      scale: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.8),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
