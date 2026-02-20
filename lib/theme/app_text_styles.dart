import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme buildTextTheme(Color textColor, Color secondaryTextColor) {
    return GoogleFonts.baloo2TextTheme(
      TextTheme(
        headlineLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.45,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: secondaryTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          color: textColor,
        ),
      ),
    );
  }
}
