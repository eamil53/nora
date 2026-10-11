import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_strings.dart';
import '../../models/journal_entry.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';

class JournalScreen extends StatefulWidget {
  final AppState appState;

  const JournalScreen({super.key, required this.appState});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedCravingLevel = 1;
  String _selectedMood = 'Sakin';
  final List<String> _selectedTriggers = [];
  final TextEditingController _noteController = TextEditingController();
  bool _isFormExpanded = false;

  AppStrings get s => widget.appState.strings;

  List<Map<String, dynamic>> get _moodOptions => [
    {'id': 'Harika', 'label': s.moodGreat, 'icon': CupertinoIcons.star_fill, 'color': const Color(0xFF00E676)},
    {'id': 'Sakin', 'label': s.moodCalm, 'icon': CupertinoIcons.heart_fill, 'color': const Color(0xFF06B6D4)},
    {'id': 'Stresli', 'label': s.moodStressed, 'icon': CupertinoIcons.bolt_fill, 'color': const Color(0xFFF59E0B)},
    {'id': 'Endişeli', 'label': s.moodAnxious, 'icon': CupertinoIcons.cloud_bolt_rain_fill, 'color': const Color(0xFFF97316)},
    {'id': 'Zorlanıyor', 'label': s.moodStruggling, 'icon': CupertinoIcons.exclamationmark_triangle_fill, 'color': const Color(0xFFEF4444)},
  ];

  List<Map<String, dynamic>> get _possibleTriggers => [
    {'id': 'Stres', 'name': s.triggerStress, 'icon': CupertinoIcons.bolt},
    {'id': 'Finansal Borç', 'name': s.triggerDebt, 'icon': CupertinoIcons.creditcard},
    {'id': 'Sosyal Medya Reklamı', 'name': s.triggerSocialMedia, 'icon': CupertinoIcons.device_phone_portrait},
    {'id': 'Gece Yalnızlık', 'name': s.triggerLoneliness, 'icon': CupertinoIcons.moon_stars},
    {'id': 'Alkollü Ortam', 'name': s.triggerAlcoholMood, 'icon': CupertinoIcons.flame},
  ];

  String _getLocalizedMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'harika':
      case 'great':
        return s.moodGreat;
      case 'sakin':
      case 'calm':
        return s.moodCalm;
      case 'stresli':
      case 'stressed':
        return s.moodStressed;
      case 'endişeli':
      case 'anxious':
        return s.moodAnxious;
      case 'zorlanıyor':
      case 'struggling':
        return s.moodStruggling;
      default:
        return mood;
    }
  }

  String _getLocalizedTrigger(String trigger) {
    switch (trigger) {
      case 'Stres':
      case 'Stress':
        return s.triggerStress;
      case 'Finansal Borç':
      case 'Financial Debt':
      case 'Maddi Kaygı':
      case 'Financial Anxiety':
        return s.triggerDebt;
      case 'Sosyal Medya Reklamı':
      case 'Social Media Ad':
      case 'Sosyal Medya':
      case 'Social Media':
        return s.triggerSocialMedia;
      case 'Reklamlar':
      case 'Ads':
        return s.triggerAds;
      case 'Gece Yalnızlık':
      case 'Late Night Solitude':
      case 'Yalnızlık':
      case 'Loneliness':
      case 'Gece Geç Saat':
      case 'Late Night':
        return s.triggerLoneliness;
      case 'Alkollü Ortam':
      case 'Alcohol Environment':
      case 'Alkol':
      case 'Alcohol':
        return s.triggerAlcoholMood;
      case 'Sıkıntı':
      case 'Boredom':
        return s.triggerBoredom;
      case 'Kaybı Geri Kazanma Hırsı':
      case 'Chasing Losses':
        return s.triggerChasingLosses;
      default:
        return trigger;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleGirisEklePressed() async {
    HapticFeedback.lightImpact();
    if (_isFormExpanded) {
      setState(() => _isFormExpanded = false);
      return;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final entry = await widget.appState.presentAddJournalEntrySheet();
        if (entry != null && mounted) {
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
                      s.journalSavedSuccess,
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
        // Fallback to inline form if native method is unavailable (e.g. before rebuild or in test)
        if (mounted) {
          setState(() => _isFormExpanded = true);
        }
      }
    } else {
      setState(() => _isFormExpanded = true);
    }
  }

  void _saveEntry() {
    HapticFeedback.mediumImpact();
    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      cravingLevel: _selectedCravingLevel,
      mood: _selectedMood,
      triggersEncountered: List.from(_selectedTriggers),
      note: _noteController.text.trim(),
    );

    widget.appState.addJournalEntry(newEntry);
    _noteController.clear();
    setState(() {
      _selectedCravingLevel = 1;
      _selectedTriggers.clear();
      _isFormExpanded = false;
    });

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
                s.journalSavedSuccess,
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final entries = widget.appState.journalEntries;

        // Calculate quick insight stats
        double avgCraving = 0;
        if (entries.isNotEmpty) {
          final total = entries.fold<int>(0, (sum, e) => sum + e.cravingLevel);
          avgCraving = total / entries.length;
        }

        return Scaffold(
          backgroundColor: context.colors.surfaceCanvas,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopHeader(entries.length),

                // Main Scroll Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mindful Insight Card
                        _buildInsightCard(entries.length, avgCraving),

                        const SizedBox(height: 18),

                        // Collapsible New Entry Form
                        _buildCheckInForm(),

                        const SizedBox(height: 24),

                        // Past Entries Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(CupertinoIcons.clock_fill, color: Color(0xFF6366F1), size: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      s.journalPastEntries,
                                      style: GoogleFonts.outfit(
                                        color: context.colors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entries.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceCardAlt,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: context.colors.border),
                                ),
                                child: Text(
                                  s.journalLogsCount(entries.length),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: context.colors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (entries.isEmpty)
                          _buildEmptyState()
                        else
                          ...entries.map((entry) => _buildEntryCard(entry)),
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

  Widget _buildTopHeader(int totalEntries) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(CupertinoIcons.book_fill, color: Color(0xFF6366F1), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.journalScreenTitle,
                        style: GoogleFonts.outfit(
                          color: colors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        s.journalScreenSub,
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _handleGirisEklePressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isFormExpanded ? colors.surfaceCardAlt : null,
                gradient: _isFormExpanded
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF00E676), Color(0xFF10B981)],
                      ),
                borderRadius: BorderRadius.circular(20),
                border: _isFormExpanded ? Border.all(color: colors.border) : null,
                boxShadow: _isFormExpanded
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFF00E676).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isFormExpanded ? CupertinoIcons.xmark : CupertinoIcons.add,
                    color: _isFormExpanded ? colors.textPrimary : const Color(0xFF070B14),
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _isFormExpanded ? s.journalClose : s.journalAddEntry,
                    style: GoogleFonts.plusJakartaSans(
                      color: _isFormExpanded ? colors.textPrimary : const Color(0xFF070B14),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(int count, double avgCraving) {
    String cravingStatus;
    Color statusColor;
    if (avgCraving <= 1.5) {
      cravingStatus = s.journalResistGreat;
      statusColor = const Color(0xFF00E676);
    } else if (avgCraving <= 3.0) {
      cravingStatus = s.journalResistBalanced;
      statusColor = const Color(0xFFF59E0B);
    } else {
      cravingStatus = s.journalResistCareful;
      statusColor = const Color(0xFFEF4444);
    }

    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(22),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.sparkles, color: Color(0xFF6366F1), size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.journalInsightTitle,
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
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    cravingStatus,
                    style: GoogleFonts.plusJakartaSans(
                      color: statusColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count == 0
                ? s.journalInsightEmpty
                : s.journalInsightCount(count),
            style: GoogleFonts.plusJakartaSans(
              color: colors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: colors.surfaceCardAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.journalTotalCheckin,
                          style: GoogleFonts.plusJakartaSans(color: colors.textTertiary, fontSize: 9.5, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.journalCheckinCount(count),
                          style: GoogleFonts.outfit(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: colors.surfaceCardAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.journalAvgCravingTitle,
                          style: GoogleFonts.plusJakartaSans(color: colors.textTertiary, fontSize: 9.5, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${avgCraving.toStringAsFixed(1)} / 5',
                          style: GoogleFonts.outfit(color: statusColor, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckInForm() {
    final colors = context.colors;
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: _isFormExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: GestureDetector(
        onTap: _handleGirisEklePressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.pen, color: Color(0xFF00E676), size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.journalFormCollapsedTitle,
                            style: GoogleFonts.outfit(
                              color: colors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s.journalFormCollapsedSub,
                            style: GoogleFonts.plusJakartaSans(
                              color: colors.textSecondary,
                              fontSize: 11,
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(CupertinoIcons.add, color: Color(0xFF00E676), size: 15),
              ),
            ],
          ),
        ),
      ),
      secondChild: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 20,
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
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.pen, color: Color(0xFF00E676), size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.journalFormExpandedTitle,
                          style: GoogleFonts.outfit(
                            color: colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
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
                  onTap: () => setState(() => _isFormExpanded = false),
                  child: Icon(CupertinoIcons.xmark_circle_fill, color: colors.textTertiary, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 18),

            Text(
              s.journalMoodStep,
              style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moodOptions.map((mood) {
                  final id = (mood['id'] ?? mood['label']) as String;
                  final isSelected = _selectedMood == id;
                  final color = mood['color'] as Color;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedMood = id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.2) : colors.surfaceCardAlt,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? color : colors.border,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(mood['icon'] as IconData, color: isSelected ? color : colors.textSecondary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            mood['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              color: isSelected ? (color == const Color(0xFF00E676) ? const Color(0xFF00C853) : color) : colors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    s.journalCravingStep,
                    style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _getCravingLabel(_selectedCravingLevel),
                  style: GoogleFonts.plusJakartaSans(
                    color: _getCravingColor(_selectedCravingLevel),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final level = index + 1;
                final isSelected = _selectedCravingLevel == level;
                final color = _getCravingColor(level);
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedCravingLevel = level);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: index == 4 ? 0 : 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.25) : colors.surfaceCardAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : colors.border,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: GoogleFonts.outfit(
                            color: isSelected ? (color == const Color(0xFF00E676) ? const Color(0xFF00C853) : color) : colors.textSecondary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            Text(
              s.journalTriggersStep,
              style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _possibleTriggers.map((t) {
                final id = (t['id'] ?? t['name']) as String;
                final name = t['name'] as String;
                final icon = t['icon'] as IconData;
                final isSelected = _selectedTriggers.contains(id);
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (isSelected) {
                        _selectedTriggers.remove(id);
                      } else {
                        _selectedTriggers.add(id);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
                          : colors.surfaceCardAlt,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFF59E0B) : colors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 12, color: isSelected ? const Color(0xFFF59E0B) : colors.textSecondary),
                        const SizedBox(width: 5),
                        Text(
                          name,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected ? colors.textPrimary : colors.textSecondary,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            Text(
              s.journalNotesStep,
              style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceCardAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                style: GoogleFonts.plusJakartaSans(color: colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: s.journalNoteHint,
                  hintStyle: GoogleFonts.plusJakartaSans(color: colors.textTertiary, fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: const Color(0xFF070B14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                icon: const Icon(CupertinoIcons.checkmark_alt, size: 18),
                label: Text(
                  s.journalSaveBtn,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                onPressed: _saveEntry,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    final cravingColor = _getCravingColor(entry.cravingLevel);
    final cravingLabel = _getCravingLabel(entry.cravingLevel);
    final dateStr = '${entry.date.day} ${_getMonthName(entry.date.month)} • ${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}';
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                    Icon(CupertinoIcons.calendar, color: colors.textTertiary, size: 13),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dateStr,
                        style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cravingColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cravingColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  s.journalCravingBadge(entry.cravingLevel, cravingLabel),
                  style: GoogleFonts.plusJakartaSans(
                    color: cravingColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _getMoodColor(entry.mood).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getMoodIcon(entry.mood), color: _getMoodColor(entry.mood), size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.journalMoodBadge(_getLocalizedMood(entry.mood)),
                  style: GoogleFonts.outfit(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (entry.triggersEncountered.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: entry.triggersEncountered.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    '⚡ ${_getLocalizedTrigger(t)}',
                    style: GoogleFonts.plusJakartaSans(color: const Color(0xFFF59E0B), fontSize: 10.5, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
          ],

          if (entry.note.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceCardAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.8), width: 3)),
              ),
              child: Text(
                entry.note,
                style: GoogleFonts.plusJakartaSans(
                  color: colors.textPrimary,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(22),
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
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.book, color: Color(0xFF6366F1), size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            s.journalEmptyTitle,
            style: GoogleFonts.outfit(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            s.journalEmptyDesc,
            style: GoogleFonts.plusJakartaSans(color: colors.textSecondary, fontSize: 12, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: const Color(0xFF070B14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(CupertinoIcons.add, size: 16),
            label: Text(
              s.journalEmptyBtn,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            onPressed: _handleGirisEklePressed,
          ),
        ],
      ),
    );
  }

  Color _getCravingColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF00E676);
      case 2:
        return const Color(0xFF10B981);
      case 3:
        return const Color(0xFFF59E0B);
      case 4:
        return const Color(0xFFF97316);
      default:
        return const Color(0xFFEF4444);
    }
  }

  String _getCravingLabel(int level) {
    switch (level) {
      case 1:
        return s.cravingLevel1;
      case 2:
        return s.cravingLevel2;
      case 3:
        return s.cravingLevel3;
      case 4:
        return s.cravingLevel4;
      default:
        return s.cravingLevel5;
    }
  }

  Color _getMoodColor(String mood) {
    final match = _moodOptions.firstWhere(
      (m) => m['id'] == mood || m['label'] == mood,
      orElse: () => _moodOptions[1],
    );
    return match['color'] as Color;
  }

  IconData _getMoodIcon(String mood) {
    final match = _moodOptions.firstWhere(
      (m) => m['id'] == mood || m['label'] == mood,
      orElse: () => _moodOptions[1],
    );
    return match['icon'] as IconData;
  }

  String _getMonthName(int month) {
    final trMonths = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final enMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final months = s.isTr ? trMonths : enMonths;
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
