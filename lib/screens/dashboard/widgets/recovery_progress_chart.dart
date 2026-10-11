import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class RecoveryProgressChart extends StatelessWidget {
  final int daysClean;
  final String? languageCode;

  const RecoveryProgressChart({
    super.key,
    required this.daysClean,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final isTr = (languageCode ?? 'tr').toLowerCase().startsWith('tr');
    final (stageName, stageProgress, stageDesc) = _getNeuroStage(daysClean, isTr);
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.waveform_path_ecg,
                      color: Color(0xFF818CF8),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTr ? 'BEYİN TOPARLANMASI' : 'BRAIN RECOVERY',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF818CF8),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                      Text(
                        isTr ? 'Dopamin Reseptör İyileşmesi' : 'Dopamine Receptor Healing',
                        style: GoogleFonts.plusJakartaSans(
                          color: colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '%${(stageProgress * 100).toInt()}',
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFFA5B4FC),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stage description & progress bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceCardAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stageName,
                      style: GoogleFonts.plusJakartaSans(
                        color: colors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$daysClean. Gün',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF00E676),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: stageProgress,
                    minHeight: 6,
                    backgroundColor: colors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stageDesc,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Mini 7-Day interactive fl_chart
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const daysLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cts', 'Paz'];
                        final idx = value.toInt();
                        if (idx >= 0 && idx < daysLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              daysLabels[idx],
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateCurveSpots(daysClean),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    barWidth: 3,
                    color: const Color(0xFF00E676),
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        // show dot only on last spot or clean points
                        return spot.x == 6 || spot.x == (daysClean.clamp(0, 6));
                      },
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: const Color(0xFF00E676),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF00E676).withValues(alpha: 0.28),
                          const Color(0xFF6366F1).withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 7 Days Clean Indicator Checkpoints
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isPassed = (daysClean >= (index + 1)) || (daysClean >= 7);
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isPassed
                      ? const Color(0xFF00E676).withValues(alpha: 0.18)
                      : colors.surfaceCardAlt,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPassed ? const Color(0xFF00E676) : colors.border,
                    width: isPassed ? 1.5 : 1,
                  ),
                ),
                child: Icon(
                  isPassed ? Icons.check_rounded : Icons.lock_outline_rounded,
                  size: 14,
                  color: isPassed ? const Color(0xFF00E676) : colors.textTertiary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateCurveSpots(int days) {
    // Generate realistic dopamine stabilization curve based on days
    final baseValues = [20.0, 30.0, 42.0, 58.0, 72.0, 84.0, 95.0];
    return List.generate(7, (i) {
      final val = (i <= days)
          ? baseValues[i]
          : (baseValues[i] * 0.4); // projected
      return FlSpot(i.toDouble(), val.clamp(10.0, 100.0));
    });
  }

  (String name, double progress, String desc) _getNeuroStage(int days, bool isTr) {
    if (days < 3) {
      final p = ((days + 1) / 3).clamp(0.1, 1.0);
      return (
        isTr ? '1. Aşama: Dopamin Arınması' : 'Stage 1: Dopamine Detox',
        p,
        isTr
            ? 'Beyin ani uyarım eksikliğinden dolayı dürtü gönderebilir. Kriz anları geçicidir, iradeni koru.'
            : 'Brain experiences sudden withdrawal cues. Urges are temporary waves; stand firm.',
      );
    } else if (days < 14) {
      final p = ((days - 3) / 11).clamp(0.1, 1.0);
      return (
        isTr ? '2. Aşama: Nöral Dengeleme' : 'Stage 2: Neural Rebalancing',
        p,
        isTr
            ? 'Dopamin reseptörleri normal hayatın sakin uyaranlarına yeniden duyarlı hale gelmeye başlıyor.'
            : 'Dopamine receptors become sensitive again to calm, healthy daily rewards.',
      );
    } else if (days < 30) {
      final p = ((days - 14) / 16).clamp(0.1, 1.0);
      return (
        isTr ? '3. Aşama: Alışkanlık Kırılımı' : 'Stage 3: Habit Loop Broken',
        p,
        isTr
            ? 'Prefrontal korteks karar alma yetisini geri kazanıyor. Kumar isteği arka plana itiliyor.'
            : 'Prefrontal cortex regains executive control. Gambling triggers fade into background.',
      );
    } else {
      return (
        isTr ? '4. Aşama: Zihinsel Hakimiyet' : 'Stage 4: Mental Mastery',
        1.0,
        isTr
            ? 'Tebrikler! Kumar döngüsü kırıldı. Yaşam kontrolü tamamen senin elinde.'
            : 'Congratulations! The gambling cycle is broken. You have full command of your life.',
      );
    }
  }
}
