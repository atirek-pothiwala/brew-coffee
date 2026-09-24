import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryCoffee,
        onPrimary: Colors.white,
        secondary: AppColors.caramelAccent,
        onSecondary: AppColors.darkCoffee,
        surface: AppColors.cardBackground,
        onSurface: AppColors.primaryText,
        error: AppColors.error,
      ),
      dividerColor: AppColors.borderDivider,
      cardColor: AppColors.cardBackground,
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.primaryText,
      displayColor: AppColors.darkCoffee,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.darkCoffee,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderDivider),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCoffee,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryCoffee,
          side: const BorderSide(color: AppColors.borderDivider, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: AppColors.caramelAccent.withOpacity(0.35),
        backgroundColor: AppColors.cardBackground,
        side: const BorderSide(color: AppColors.borderDivider),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
