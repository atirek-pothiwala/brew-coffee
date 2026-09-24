import 'package:brew_coffee/core/constants/app_constants.dart';
import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class ReceiptTheme {
  static const Color pageBackground = Color(0xFFE5DDD3);
  static const Color paper = Color(0xFFFFFDF9);
  static const Color ink = AppColors.darkCoffee;
  static const Color inkMuted = AppColors.secondaryText;
  static const Color dash = AppColors.borderDivider;

  static TextStyle brand(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 6,
        color: ink,
      );

  static TextStyle shopLine(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 11,
        letterSpacing: 3,
        color: inkMuted,
      );

  static TextStyle meta(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 10,
        color: inkMuted,
        height: 1.5,
      );

  static TextStyle lineTitle(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ink,
      );

  static TextStyle lineDetail(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 11,
        color: inkMuted,
        height: 1.4,
      );

  static TextStyle price(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 12,
        color: ink,
      );

  static TextStyle totalLabel(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: ink,
      );

  static TextStyle totalAmount(BuildContext context) => GoogleFonts.robotoMono(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: ink,
      );

  static BoxConstraints paperConstraints() => const BoxConstraints(
        maxWidth: AppConstants.receiptMaxWidth,
      );
}
