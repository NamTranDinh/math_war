import 'package:flutter/material.dart';
import 'package:math_war/theme/app_text_styles.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';

class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        neu: NeumorphicThemeExtension.light,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        neu: NeumorphicThemeExtension.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required NeumorphicThemeExtension neu,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: neu.accent,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: neu.background,
      textTheme:
          AppTextStyles.buildTextTheme(neu.textPrimary, neu.textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: neu.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: neu.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: neu.surface,
        selectedItemColor: neu.accent,
        unselectedItemColor: neu.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: neu.accent,
        inactiveTrackColor: neu.inset,
        thumbColor: neu.accent,
        overlayColor: neu.accent.withOpacity(0.15),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        trackHeight: 6,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: neu.surface,
        contentTextStyle:
            TextStyle(color: neu.textPrimary, fontWeight: FontWeight.w700),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      cardTheme: CardTheme(
        color: neu.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      extensions: <ThemeExtension<dynamic>>[neu],
    );
  }
}
