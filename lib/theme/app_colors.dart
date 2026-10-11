import 'package:flutter/material.dart';

/// Semantic color tokens for Nora, modeled after the Refine_ios
/// "Mürekkep & Mühür" role-based design system.
///
/// In this system, call sites never use raw hex values; they reference the semantic
/// role (`surfaceCanvas`, `surfaceCard`, `textPrimary`, `border`, etc.).
/// When dark mode is OFF, the entire app renders in a crisp white/light aesthetic.
/// When dark mode is ON, the app renders in a deep black/OLED dark aesthetic.
class AppColors {
  const AppColors._();

  // Brand Accents
  static const Color primary = Color(0xFF00E676); // Emerald Green
  static const Color primaryDark = Color(0xFF00B359);
  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color cyan = Color(0xFF06B6D4);
  static const Color amber = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color purple = Color(0xFF8B5CF6);

  // Helper to get active color scheme from BuildContext
  static AppColorScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  // --- LIGHT PALETTE (Koyu Mod Kapalıyken - Bembeyaz & Ferah) ---
  static const AppColorScheme light = AppColorScheme(
    isDark: false,
    surfaceCanvas: Color(0xFFF4F6F9), // Crisp paper desk canvas
    surfaceCard: Color(0xFFFFFFFF), // Pure white cards
    surfaceCardAlt: Color(0xFFEEF2F6), // Inset wells, chips, quiet fills
    surfaceInk: Color(0xFF0B1120), // Dark by design (hero/splash)
    surfaceInkRaised: Color(0xFF16202E),
    separator: Color(0xFFE2E8F0), // Hairline dividers
    border: Color(0xFFCBD5E1), // Card outlines
    textPrimary: Color(0xFF0F172A), // Deep ink for headings & body
    textSecondary: Color(0xFF475569), // Slate secondary copy
    textTertiary: Color(0xFF94A3B8), // Captions & timestamps
    textOnDark: Color(0xFFF8FAFC),
    accentPrimary: primary,
    accentSecondary: secondary,
    accentWarning: amber,
    accentError: error,
    cardShadow: Color(0x0A0F172A),
    glassFill: Color(0xF2FFFFFF),
    glassBorder: Color(0x33CBD5E1),
    bottomBarFill: Color(0xF2FFFFFF),
    bottomBarUnselected: Color(0xFF64748B),
  );

  // --- DARK PALETTE (Koyu Mod Açıkken - Derin Siyah & OLED) ---
  static const AppColorScheme dark = AppColorScheme(
    isDark: true,
    surfaceCanvas: Color(0xFF070A12), // Deep midnight black canvas
    surfaceCard: Color(0xFF101726), // Elevated dark card
    surfaceCardAlt: Color(0xFF192233), // Inset chips, wells
    surfaceInk: Color(0xFF070B14), // Dark by design
    surfaceInkRaised: Color(0xFF111827),
    separator: Color(0x1F94A3B8), // Hairlines
    border: Color(0x2EFFFFFF), // Borders
    textPrimary: Color(0xFFF9FAFB), // Light ink
    textSecondary: Color(0xFF94A3B8), // Muted grey
    textTertiary: Color(0xFF64748B), // Captions
    textOnDark: Color(0xFFF8FAFC),
    accentPrimary: primary,
    accentSecondary: Color(0xFF818CF8),
    accentWarning: amber,
    accentError: error,
    cardShadow: Color(0x40000000),
    glassFill: Color(0xEB000000),
    glassBorder: Color(0x1FFFFFFF),
    bottomBarFill: Color(0xF00B0F14),
    bottomBarUnselected: Color(0x8AFFFFFF),
  );
}

class AppColorScheme {
  final bool isDark;
  final Color surfaceCanvas;
  final Color surfaceCard;
  final Color surfaceCardAlt;
  final Color surfaceInk;
  final Color surfaceInkRaised;
  final Color separator;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnDark;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentWarning;
  final Color accentError;
  final Color cardShadow;
  final Color glassFill;
  final Color glassBorder;
  final Color bottomBarFill;
  final Color bottomBarUnselected;

  List<BoxShadow> get cardShadows => [
    BoxShadow(
      color: cardShadow,
      blurRadius: isDark ? 16 : 10,
      offset: const Offset(0, 4),
    ),
  ];

  const AppColorScheme({
    required this.isDark,
    required this.surfaceCanvas,
    required this.surfaceCard,
    required this.surfaceCardAlt,
    required this.surfaceInk,
    required this.surfaceInkRaised,
    required this.separator,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnDark,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentWarning,
    required this.accentError,
    required this.cardShadow,
    required this.glassFill,
    required this.glassBorder,
    required this.bottomBarFill,
    required this.bottomBarUnselected,
  });
}

extension AppThemeContextExtension on BuildContext {
  AppColorScheme get colors => AppColors.of(this);
}
