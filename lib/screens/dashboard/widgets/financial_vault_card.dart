import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/user_profile.dart';

class FinancialVaultCard extends StatefulWidget {
  final UserProfile profile;

  const FinancialVaultCard({
    super.key,
    required this.profile,
  });

  @override
  State<FinancialVaultCard> createState() => _FinancialVaultCardState();
}

class _FinancialVaultCardState extends State<FinancialVaultCard> {
  int _selectedTabIndex = 0; // 0: Para, 1: Zaman, 2: Engellenen Dürtü

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final savedMoney = profile.calculateSavedMoney();
    final savedHours = profile.calculateSavedHours();
    final daysClean = profile.calculateDaysClean();

    final currencyFormatter = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: profile.currencySymbol,
      decimalDigits: 2,
    );

    final yearlySavingsFormatted = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: profile.currencySymbol,
      decimalDigits: 0,
    ).format(profile.yearlyProjectedSavings);

    // Approximate urges/bets prevented based on hours and days
    final estimatedPreventedBets = (daysClean * 4 + (savedHours * 1.5)).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064E3B), // Deep Emerald
            Color(0xFF062D24), // Rich Pine Dark
            Color(0xFF051B16), // Dark Obsidian Green
          ],
        ),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Background subtle grid/lines pattern effect
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF34D399).withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title & Vault Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: const Icon(
                              CupertinoIcons.lock_shield_fill,
                              color: Color(0xFF34D399),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GÜVENLİ KASA',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF6EE7B7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'Cebinde Kalan Geleceğin',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00E676).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: Color(0xFF00E676),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Büyüyor',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF00E676),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tab switcher (Nakit, Zaman, Bahis)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem(0, 'Nakit', CupertinoIcons.money_dollar_circle),
                        _buildTabItem(1, 'Zaman', CupertinoIcons.clock),
                        _buildTabItem(2, 'Engellenen', CupertinoIcons.shield),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Main Big Dynamic Stat
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: _buildSelectedContent(
                      savedMoney: savedMoney,
                      savedHours: savedHours,
                      preventedBets: estimatedPreventedBets,
                      formatter: currencyFormatter,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Projection footer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.sparkles,
                              color: Color(0xFFFBBF24),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1 Yıllık Tahmini Birikim',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          yearlySavingsFormatted,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [ui.FontFeature.tabularFigures()],
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
    ).animate().shimmer(
      duration: 3.seconds,
      color: Colors.white.withValues(alpha: 0.06),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTabItem(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedTabIndex != index) {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedTabIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white54,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent({
    required double savedMoney,
    required double savedHours,
    required int preventedBets,
    required NumberFormat formatter,
  }) {
    if (_selectedTabIndex == 0) {
      return Column(
        key: const ValueKey('money_tab'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KURTARILAN TOPLAM PARA',
            style: GoogleFonts.outfit(
              color: const Color(0xFF6EE7B7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatter.format(savedMoney),
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Her saniye cebinde birikmeye ve çoğalmaya devam ediyor.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      return Column(
        key: const ValueKey('hours_tab'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GERİ KAZANILAN YAŞAM ZAMANI',
            style: GoogleFonts.outfit(
              color: const Color(0xFF6EE7B7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                savedHours.toStringAsFixed(1),
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Saat',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF6EE7B7),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Ekrana kilitli kalmak yerine sevdiklerine ve kendine ayırdığın vakit.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey('bets_tab'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BAŞARIYLA PÜSKÜRTÜLEN DÜRTÜLER',
            style: GoogleFonts.outfit(
              color: const Color(0xFF6EE7B7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$preventedBets',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Dürtü Engellendi',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF6EE7B7),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Her geri çekilme beynindeki kumar isteğini zayıflatıyor.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }
}
