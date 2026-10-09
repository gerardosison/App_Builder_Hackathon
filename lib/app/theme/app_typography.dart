import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme light() => _theme(
    headingColor: AppColors.ink,
    bodyColor: AppColors.ink,
    mutedColor: AppColors.navySoft,
  );

  static TextTheme dark() => _theme(
    headingColor: Colors.white,
    bodyColor: Colors.white,
    mutedColor: Colors.white70,
  );

  static TextTheme _theme({
    required Color headingColor,
    required Color bodyColor,
    required Color mutedColor,
  }) {
    final heading = GoogleFonts.bricolageGrotesque(
      color: headingColor,
      fontWeight: FontWeight.w800,
    );
    final body = GoogleFonts.inter(color: bodyColor);
    final muted = GoogleFonts.inter(color: mutedColor);

    return TextTheme(
      displaySmall: heading,
      headlineMedium: heading,
      titleLarge: heading.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: body.copyWith(height: 1.45),
      bodyMedium: muted.copyWith(height: 1.4),
      labelLarge: GoogleFonts.inter(
        color: bodyColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nunito Sans type scale from the Stitch tailwind config / DESIGN.md.
///
/// display-lg-mobile 34/42 w800 -0.02em → [AppTypography.display]
/// headline-lg-mobile 26/34 w700 -0.01em → headlineLarge
/// headline-md 22/28 w700 → headlineMedium
/// headline-sm 18/24 w700 → headlineSmall
/// body-lg 16/24 w500 → bodyLarge
/// body-md 14/20 w400 → bodyMedium
/// body-sm 12/16 w400 → bodySmall
/// label-lg 14/20 w700 0.01em → labelLarge
/// label-md 12/16 w700 0.02em → labelMedium
/// label-sm 11/14 w700 0.03em → labelSmall
abstract final class AppTypography {
  static TextTheme textTheme(Color color) {
    final base = GoogleFonts.nunitoSans();
    return TextTheme(
      displayLarge: base.copyWith(
          fontSize: 34,
          height: 42 / 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.68,
          color: color),
      headlineLarge: base.copyWith(
          fontSize: 26,
          height: 34 / 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.26,
          color: color),
      headlineMedium: base.copyWith(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: color),
      headlineSmall: base.copyWith(
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w700,
          color: color),
      titleLarge: base.copyWith(
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w700,
          color: color),
      titleMedium: base.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w700,
          color: color),
      bodyLarge: base.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          color: color),
      bodyMedium: base.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: color),
      bodySmall: base.copyWith(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          color: color),
      labelLarge: base.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.14,
          color: color),
      labelMedium: base.copyWith(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.24,
          color: color),
      labelSmall: base.copyWith(
          fontSize: 11,
          height: 14 / 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.33,
          color: color),
    );
  }
}
