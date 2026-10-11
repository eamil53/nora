import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  /// Light Theme (Koyu Mod Kapalıyken)
  /// Clean, crisp white & paper aesthetic.
  static ThemeData get lightTheme {
    const scheme = AppColors.light;
    final baseTextTheme = ThemeData(brightness: Brightness.light).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scheme.surfaceCanvas,
      colorScheme: ColorScheme.light(
        primary: scheme.accentPrimary,
        secondary: scheme.accentSecondary,
        surface: scheme.surfaceCard,
        surfaceContainerHighest: scheme.surfaceCardAlt,
        error: scheme.accentError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: scheme.textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
        bodyColor: scheme.textPrimary,
        displayColor: scheme.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light, // iOS: dark/black status bar icons
          statusBarIconBrightness: Brightness.dark, // Android: dark/black status bar icons
        ),
        iconTheme: IconThemeData(color: scheme.textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: scheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.separator,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.border, width: 1),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }

  /// Dark Theme (Koyu Mod Açıkken)
  /// Deep black, midnight slate & OLED aesthetic.
  static ThemeData get darkTheme {
    const scheme = AppColors.dark;
    final baseTextTheme = ThemeData(brightness: Brightness.dark).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scheme.surfaceCanvas,
      colorScheme: ColorScheme.dark(
        primary: scheme.accentPrimary,
        secondary: scheme.accentSecondary,
        surface: scheme.surfaceCard,
        surfaceContainerHighest: scheme.surfaceCardAlt,
        error: scheme.accentError,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: scheme.textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
        bodyColor: scheme.textPrimary,
        displayColor: scheme.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark, // iOS: light/white status bar icons
          statusBarIconBrightness: Brightness.light, // Android: light/white status bar icons
        ),
        iconTheme: IconThemeData(color: scheme.textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: scheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.separator,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.border, width: 1),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}
