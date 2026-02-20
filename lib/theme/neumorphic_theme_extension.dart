import 'package:flutter/material.dart';

@immutable
class NeumorphicThemeExtension
    extends ThemeExtension<NeumorphicThemeExtension> {
  const NeumorphicThemeExtension({
    required this.background,
    required this.surface,
    required this.inset,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.shadowDark,
    required this.shadowLight,
  });

  final Color background;
  final Color surface;
  final Color inset;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color shadowDark;
  final Color shadowLight;

  @override
  NeumorphicThemeExtension copyWith({
    Color? background,
    Color? surface,
    Color? inset,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? shadowDark,
    Color? shadowLight,
  }) {
    return NeumorphicThemeExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      inset: inset ?? this.inset,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      shadowDark: shadowDark ?? this.shadowDark,
      shadowLight: shadowLight ?? this.shadowLight,
    );
  }

  @override
  NeumorphicThemeExtension lerp(
    ThemeExtension<NeumorphicThemeExtension>? other,
    double t,
  ) {
    if (other is! NeumorphicThemeExtension) {
      return this;
    }

    return NeumorphicThemeExtension(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      inset: Color.lerp(inset, other.inset, t) ?? inset,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      shadowDark: Color.lerp(shadowDark, other.shadowDark, t) ?? shadowDark,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t) ?? shadowLight,
    );
  }

  static const light = NeumorphicThemeExtension(
    background: Color(0xFFF9F2FF),
    surface: Color(0xFFFFFCF2),
    inset: Color(0xFFEDE3FF),
    accent: Color(0xFF6B7CFF),
    textPrimary: Color(0xFF2F2B4A),
    textSecondary: Color(0xFF6A6892),
    shadowDark: Color(0x22A093C4),
    shadowLight: Color(0xFFFFFFFF),
  );

  static const dark = NeumorphicThemeExtension(
    background: Color(0xFF1E1C37),
    surface: Color(0xFF2A274A),
    inset: Color(0xFF201D3C),
    accent: Color(0xFF9EA9FF),
    textPrimary: Color(0xFFF3F2FF),
    textSecondary: Color(0xFFC2BFE8),
    shadowDark: Color(0xAA0F0D22),
    shadowLight: Color(0x33454272),
  );
}

extension NeumorphicThemeX on BuildContext {
  NeumorphicThemeExtension get neu =>
      Theme.of(this).extension<NeumorphicThemeExtension>()!;
}
