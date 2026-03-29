import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color background;
  final Color cardBackground;
  final Color cardBackgroundDark;
  final Color inputBackground;
  final Color textWhite;
  final Color textGrey;
  final Color textGreyLight;
  final Color borderColor;
  final Color divider;
  final Color navBar;

  const AppThemeColors({
    required this.background,
    required this.cardBackground,
    required this.cardBackgroundDark,
    required this.inputBackground,
    required this.textWhite,
    required this.textGrey,
    required this.textGreyLight,
    required this.borderColor,
    required this.divider,
    required this.navBar,
  });

  static const dark = AppThemeColors(
    background: Color(0xFF0A0E1A),
    cardBackground: Color(0xFF111827),
    cardBackgroundDark: Color(0xFF080C18),
    inputBackground: Color(0xFF1E2A3A),
    textWhite: Color(0xFFFFFFFF),
    textGrey: Color(0xFF6B7280),
    textGreyLight: Color(0xFF9CA3AF),
    borderColor: Color(0xFF1F2A3C),
    divider: Color(0xFF1A2332),
    navBar: Color(0xFF080C18),
  );

  static const light = AppThemeColors(
    background: Color(0xFFF3F4F6),
    cardBackground: Color(0xFFFFFFFF),
    cardBackgroundDark: Color(0xFFE5E7EB),
    inputBackground: Color(0xFFF9FAFB),
    textWhite: Color(0xFF111928), // Neutral
    textGrey: Color(0xFF6B7280),
    textGreyLight: Color(0xFF9CA3AF),
    borderColor: Color(0xFFE5E7EB),
    divider: Color(0xFFE5E7EB),
    navBar: Color(0xFFFFFFFF),
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? cardBackground,
    Color? cardBackgroundDark,
    Color? inputBackground,
    Color? textWhite,
    Color? textGrey,
    Color? textGreyLight,
    Color? borderColor,
    Color? divider,
    Color? navBar,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundDark: cardBackgroundDark ?? this.cardBackgroundDark,
      inputBackground: inputBackground ?? this.inputBackground,
      textWhite: textWhite ?? this.textWhite,
      textGrey: textGrey ?? this.textGrey,
      textGreyLight: textGreyLight ?? this.textGreyLight,
      borderColor: borderColor ?? this.borderColor,
      divider: divider ?? this.divider,
      navBar: navBar ?? this.navBar,
    );
  }

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other == null) return this;
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBackgroundDark: Color.lerp(
        cardBackgroundDark,
        other.cardBackgroundDark,
        t,
      )!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      textGrey: Color.lerp(textGrey, other.textGrey, t)!,
      textGreyLight: Color.lerp(textGreyLight, other.textGreyLight, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
    );
  }
}

// Convenience extension on BuildContext
extension AppThemeColorsX on BuildContext {
  AppThemeColors get tc =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.dark;
}
