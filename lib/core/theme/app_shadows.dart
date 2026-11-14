import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Refined layered shadows tuned for Light (soft navy tint) and Dark (subtle depth) themes.
abstract final class AppShadows {
  static List<BoxShadow> card(AppColorPalette palette) {
    if (palette.brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: palette.shadowColor,
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    }

    return [
      BoxShadow(
        color: palette.shadowColor,
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
      const BoxShadow(
        color: Color(0x080E2F66),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> primaryButton(AppColorPalette palette) {
    return [
      BoxShadow(
        color: palette.primary.withValues(
          alpha: palette.brightness == Brightness.dark ? 0.32 : 0.24,
        ),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> floatingNav(AppColorPalette palette) {
    return [
      BoxShadow(
        color: palette.shadowColor.withValues(
          alpha: palette.brightness == Brightness.dark ? 0.45 : 0.14,
        ),
        blurRadius: 24,
        offset: const Offset(0, -4),
      ),
    ];
  }
}
