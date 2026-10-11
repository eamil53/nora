import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class _QuoteItem {
  final String quoteTr;
  final String quoteEn;
  final String author;
  final String tagTr;
  final String tagEn;

  const _QuoteItem({
    required this.quoteTr,
    required this.quoteEn,
    required this.author,
    required this.tagTr,
    required this.tagEn,
  });
}

class DailyQuoteCard extends StatefulWidget {
  final String? languageCode;

  const DailyQuoteCard({super.key, this.languageCode});

  @override
  State<DailyQuoteCard> createState() => _DailyQuoteCardState();
}

class _DailyQuoteCardState extends State<DailyQuoteCard> {
  int _currentIndex = 0;

  static const List<_QuoteItem> _quotes = [
    _QuoteItem(
      quoteTr: 'Kendi zihnini fetheden bir insan, savaşta binlerce insanı yenen birinden daha büyüktür.',
      quoteEn: 'One who conquers their own mind is greater than one who conquers thousands in battle.',
      author: 'Buda / Buddha',
      tagTr: 'İçsel Güç',
      tagEn: 'Inner Strength',
    ),
    _QuoteItem(
      quoteTr: 'Dış dünyadaki olayları kontrol edemezsin, ama onlara verdiğin tepkiyi tamamen kontrol edebilirsin.',
      quoteEn: 'You cannot control external events, but you have absolute control over your response.',
      author: 'Marcus Aurelius',
      tagTr: 'Stoacılık',
      tagEn: 'Stoicism',
    ),
    _QuoteItem(
      quoteTr: 'Acı kaçınılmazdır, ancak ıstırap çekmek senin seçimine bağlıdır.',
      quoteEn: 'Pain is inevitable, but suffering is optional.',
      author: 'Haruki Murakami',
      tagTr: 'Farkındalık',
      tagEn: 'Mindfulness',
    ),
    _QuoteItem(
      quoteTr: 'Zorluklar insanı yok etmek için değil, gücünü ve potansiyelini ortaya çıkarmak için gelir.',
      quoteEn: 'Difficulties come not to destroy you, but to reveal your hidden strength and potential.',
      author: 'Epiktetos / Epictetus',
      tagTr: 'Direnç',
      tagEn: 'Resilience',
    ),
    _QuoteItem(
      quoteTr: 'Uğruna yaşayacak bir nedeni olan insan, hemen her "nasıl"a katlanabilir.',
      quoteEn: 'He who has a why to live can bear almost any how.',
      author: 'Viktor E. Frankl',
      tagTr: 'Amaç',
      tagEn: 'Purpose',
    ),
    _QuoteItem(
      quoteTr: 'Bir alışkanlığı kırmanın en iyi yolu, ona giden yolu engellemek ve zihni özgürleştirmektir.',
      quoteEn: 'The best way to break a habit is to make cues invisible and keep friction absolute.',
      author: 'James Clear',
      tagTr: 'Davranış Bilimi',
      tagEn: 'Behavior Science',
    ),
  ];

  void _nextQuote() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTr = (widget.languageCode ?? 'tr').toLowerCase().startsWith('tr');
    final item = _quotes[_currentIndex];
    final colors = context.colors;
    final quoteText = isTr ? item.quoteTr : item.quoteEn;
    final tagText = isTr ? item.tagTr : item.tagEn;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.isDark ? const Color(0xFF131B2E) : colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.isDark
              ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
              : const Color(0xFFF59E0B).withValues(alpha: 0.4),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.quote_bubble_fill,
                    color: Color(0xFFF59E0B),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTr ? 'GÜNÜN REHBERİ' : 'DAILY GUIDE',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFD97706),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.surfaceCardAlt,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tagText,
                      style: GoogleFonts.plusJakartaSans(
                        color: colors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: colors.textTertiary,
                  size: 16,
                ),
                onPressed: _nextQuote,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '"$quoteText"',
              key: ValueKey(quoteText),
              style: GoogleFonts.plusJakartaSans(
                color: colors.textPrimary,
                fontSize: 13.5,
                height: 1.45,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '— ${item.author}',
            style: GoogleFonts.plusJakartaSans(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
