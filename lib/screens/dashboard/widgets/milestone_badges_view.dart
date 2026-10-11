import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class MilestoneBadgesView extends StatelessWidget {
  final int daysClean;
  final String? languageCode;

  const MilestoneBadgesView({
    super.key,
    required this.daysClean,
    this.languageCode,
  });

  static const List<_BadgeData> _badges = [
    _BadgeData(
      days: 1,
      titleTr: 'İlk Adım',
      titleEn: 'First Step',
      descTr: 'Kumar döngüsünü kırma kararını aldın ve 24 saati geride bıraktın.',
      descEn: 'You broke the gambling loop and completed your first 24 hours clean.',
      icon: Icons.bolt_rounded,
      color: Color(0xFF10B981),
    ),
    _BadgeData(
      days: 3,
      titleTr: 'Kriz Zirvesi',
      titleEn: 'Peak Urge',
      descTr: 'En şiddetli dopamin yoksunluğu krizini başarıyla atlattın.',
      descEn: 'You successfully overcame the acute dopamine withdrawal peak.',
      icon: Icons.shield_rounded,
      color: Color(0xFF06B6D4),
    ),
    _BadgeData(
      days: 7,
      titleTr: 'İrade Kalkanı',
      titleEn: 'Willpower Shield',
      descTr: 'Tam 1 haftadır kumar oynamıyorsun. Beynin yeni bir döneme girdi.',
      descEn: 'One full week without gambling. Your neural receptors are resetting.',
      icon: Icons.star_rounded,
      color: Color(0xFF6366F1),
    ),
    _BadgeData(
      days: 14,
      titleTr: 'Berrak Zihin',
      titleEn: 'Clear Mind',
      descTr: 'Sürekli kumarı düşünme sisi dağılmaya başladı. Finansal kontrol senin elinde.',
      descEn: 'The fog of constant gambling thoughts is lifting. You control your finances.',
      icon: Icons.psychology_rounded,
      color: Color(0xFF8B5CF6),
    ),
    _BadgeData(
      days: 30,
      titleTr: '1 Ay Özgürlük',
      titleEn: '1 Month Free',
      descTr: 'Alışkanlık döngüsü nörolojik olarak kırıldı. Yeni bir kimlik inşa ediyorsun.',
      descEn: 'The habit loop is neurologically severed. You are building a new identity.',
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFFF59E0B),
    ),
    _BadgeData(
      days: 90,
      titleTr: 'Çelik Kalkan',
      titleEn: 'Steel Shield',
      descTr: '3 aylık temizlik! Artık tetikleyiciler sana eskisi gibi etki edemez.',
      descEn: '3 full months clean! Emotional triggers no longer control your actions.',
      icon: Icons.military_tech_rounded,
      color: Color(0xFFEC4899),
    ),
    _BadgeData(
      days: 365,
      titleTr: 'Efsanevi Zafer',
      titleEn: 'Legendary Victory',
      descTr: '1 YIL! Kumar bağımlılığına karşı hayatının en büyük zaferini kazandın.',
      descEn: '1 FULL YEAR! You achieved the ultimate victory against gambling addiction.',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFEAB308),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isTr = (languageCode ?? 'tr').toLowerCase().startsWith('tr');
    final unlockedCount = _badges.where((b) => daysClean >= b.days).length;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.rosette,
                  color: Color(0xFFF59E0B),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isTr ? 'Kurtuluş Rozetleri' : 'Milestone Badges',
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
                isTr ? '$unlockedCount / ${_badges.length} Açık' : '$unlockedCount / ${_badges.length} Unlocked',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFD97706),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _badges.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final badge = _badges[index];
              final isUnlocked = daysClean >= badge.days;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _showBadgeDetail(context, badge, isUnlocked, isTr);
                },
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? (colors.isDark ? const Color(0xFF131B2E) : colors.surfaceCard)
                        : colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isUnlocked
                          ? badge.color.withValues(alpha: 0.5)
                          : colors.border,
                      width: isUnlocked ? 1.4 : 1,
                    ),
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: badge.color.withValues(alpha: colors.isDark ? 0.18 : 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? badge.color.withValues(alpha: 0.15)
                              : (colors.isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isUnlocked
                                ? badge.color.withValues(alpha: 0.4)
                                : colors.border,
                          ),
                        ),
                        child: Icon(
                          isUnlocked ? badge.icon : Icons.lock_outline_rounded,
                          color: isUnlocked ? badge.color : colors.textTertiary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${badge.days} ${isTr ? 'Gün' : 'Days'}',
                        style: GoogleFonts.outfit(
                          color: isUnlocked ? colors.textPrimary : colors.textTertiary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge.title(isTr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: isUnlocked ? colors.textSecondary : colors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showBadgeDetail(BuildContext context, _BadgeData badge, bool isUnlocked, bool isTr) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
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
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: badge.color.withValues(alpha: isUnlocked ? 0.2 : 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? badge.color : colors.border,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isUnlocked ? badge.icon : Icons.lock_rounded,
                  color: isUnlocked ? badge.color : colors.textTertiary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${badge.days} ${isTr ? 'Gün' : 'Days'}: ${badge.title(isTr)}',
                style: GoogleFonts.outfit(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? const Color(0xFF00E676).withValues(alpha: 0.15)
                      : colors.surfaceCardAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isUnlocked ? const Color(0xFF00E676).withValues(alpha: 0.3) : colors.border),
                ),
                child: Text(
                  isUnlocked
                      ? (isTr ? '✅ KAZANILDI' : '✅ UNLOCKED')
                      : (isTr ? '🔒 HENÜZ KİLİTLİ (Kalan: ${badge.days - daysClean} Gün)' : '🔒 LOCKED (${badge.days - daysClean} Days Left)'),
                  style: GoogleFonts.plusJakartaSans(
                    color: isUnlocked ? const Color(0xFF00B359) : colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge.desc(isTr),
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: colors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.surfaceCardAlt,
                    foregroundColor: colors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: colors.border),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(isTr ? 'Kapat' : 'Close', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeData {
  final int days;
  final String titleTr;
  final String titleEn;
  final String descTr;
  final String descEn;
  final IconData icon;
  final Color color;

  const _BadgeData({
    required this.days,
    required this.titleTr,
    required this.titleEn,
    required this.descTr,
    required this.descEn,
    required this.icon,
    required this.color,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String desc(bool isTr) => isTr ? descTr : descEn;
}
