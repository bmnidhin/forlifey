import 'package:flutter/material.dart';

class GlassTheme {
  // Brand colors (Apple light mode palette)
  static const Color backgroundColor = Color(0xFFF2F2F7); // iOS Grouped Background
  static const Color primaryAccent = Color(0xFF007AFF); // Apple Blue
  static const Color secondaryAccent = Color(0xFF5856D6); // Apple Indigo
  static const Color tertiaryAccent = Color(0xFFFF2D55); // Apple Pink

  // Card/Glass colors (Apple frosted material light)
  static Color glassBg = Colors.white.withOpacity(0.75);
  static Color glassBgLight = Colors.white.withOpacity(0.92);
  static Color glassBorder = Colors.black.withOpacity(0.06);
  static Color glassBorderSpecular = Colors.black.withOpacity(0.12);
  
  static const Color textPrimary = Color(0xFF1C1C1E); // System Primary Label
  static final Color textSecondary = const Color(0xFF3C3C43).withOpacity(0.6); // System Secondary Label
  static final Color textMuted = const Color(0xFF3C3C43).withOpacity(0.3); // System Muted Label

  // Glass box decoration helper for Light Mode
  static BoxDecoration glassDecoration({
    double opacity = 0.75,
    double borderOpacity = 0.06,
    double borderRadius = 24.0,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(isSelected ? 0.92 : opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected 
            ? primaryAccent.withOpacity(0.5) 
            : Colors.black.withOpacity(borderOpacity),
        width: isSelected ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        if (isSelected)
          BoxShadow(
            color: primaryAccent.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
      ],
    );
  }

  // Typography styles
  static TextStyle get largeTitle => const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 0.37,
      );

  static TextStyle get title1 => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 0.36,
      );

  static TextStyle get title2 => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.35,
      );

  static TextStyle get headline => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.41,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        letterSpacing: -0.41,
      );

  static TextStyle get subhead => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        letterSpacing: -0.24,
      );

  static TextStyle get footnote => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: textSecondary.withOpacity(0.7),
        letterSpacing: -0.08,
      );
}
