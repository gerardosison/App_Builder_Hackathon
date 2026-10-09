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
