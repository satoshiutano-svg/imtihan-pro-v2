import 'package:flutter/material.dart';

/// Semantic color system for Imtihan Pro's Silver Blue (Light) and Deep Navy (Dark) themes.
@immutable
class AppColorPalette extends ThemeExtension<AppColorPalette> {
  const AppColorPalette({
    required this.brightness,
    required this.canvasTop,
    required this.canvasBottom,
    required this.surfacePrimary,
    required this.surfaceElevated,
    required this.surfaceGlass,
    required this.surfaceSelected,
    required this.borderSubtle,
    required this.borderHighlight,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accentCyan,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.iconBadgeBgStart,
    required this.iconBadgeBgEnd,
    required this.shadowColor,
  });

  final Brightness brightness;
  final Color canvasTop;
  final Color canvasBottom;
  final Color surfacePrimary;
  final Color surfaceElevated;
  final Color surfaceGlass;
  final Color surfaceSelected;
  final Color borderSubtle;
  final Color borderHighlight;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accentCyan;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color iconBadgeBgStart;
  final Color iconBadgeBgEnd;
  final Color shadowColor;

  /// Default Silver Blue Light Theme palette.
  static const AppColorPalette light = AppColorPalette(
    brightness: Brightness.light,
    canvasTop: Color(0xFFEAF2FD),
    canvasBottom: Color(0xFFD6E5FA),
    surfacePrimary: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF3F8FF),
    surfaceGlass: Color(0xCCFFFFFF),
    surfaceSelected: Color(0xFFE5F0FF),
    borderSubtle: Color(0xFFD2E1F5),
    borderHighlight: Color(0xE6FFFFFF),
    primary: Color(0xFF1550A6),
    primaryDark: Color(0xFF0A3270),
    primaryLight: Color(0xFF2B73D9),
    accentCyan: Color(0xFF0EA5E9),
    textPrimary: Color(0xFF0B1D3A),
    textSecondary: Color(0xFF475F84),
    textMuted: Color(0xFF6F84A6),
    textOnPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF0F9D68),
    successSoft: Color(0xFFE6F7F0),
    warning: Color(0xFFD97706),
    warningSoft: Color(0xFFFEF3C7),
    danger: Color(0xFFDC2626),
    dangerSoft: Color(0xFFFEE2E2),
    iconBadgeBgStart: Color(0xFFEAF2FF),
    iconBadgeBgEnd: Color(0xFFD7E7FF),
    shadowColor: Color(0x140E2F66),
  );

  /// Deep Navy & Blue-Gray Dark Theme palette.
  static const AppColorPalette dark = AppColorPalette(
    brightness: Brightness.dark,
    canvasTop: Color(0xFF061124),
    canvasBottom: Color(0xFF0B1D3A),
    surfacePrimary: Color(0xFF112341),
    surfaceElevated: Color(0xFF172D52),
    surfaceGlass: Color(0xBF122546),
    surfaceSelected: Color(0xFF1C3866),
    borderSubtle: Color(0xFF243E6B),
    borderHighlight: Color(0x2E93C5FD),
    primary: Color(0xFF2F7CF6),
    primaryDark: Color(0xFF1A56C4),
    primaryLight: Color(0xFF60A5FA),
    accentCyan: Color(0xFF38BDF8),
    textPrimary: Color(0xFFF1F6FF),
    textSecondary: Color(0xFFA2B8DA),
    textMuted: Color(0xFF738DB5),
    textOnPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF34D399),
    successSoft: Color(0xFF10332B),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF362A11),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF3B1820),
    iconBadgeBgStart: Color(0xFF1D3A6B),
    iconBadgeBgEnd: Color(0xFF142A4F),
    shadowColor: Color(0x59020814),
  );

  LinearGradient get scaffoldGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [canvasTop, canvasBottom],
      );

  LinearGradient get primaryButtonGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryLight, primaryDark],
      );

  LinearGradient get cardSheenGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: brightness == Brightness.light
            ? [const Color(0xFFFFFFFF), const Color(0xFFF5F9FF)]
            : [const Color(0xFF14294B), const Color(0xFF0F1F3B)],
      );

  @override
  AppColorPalette copyWith({
    Brightness? brightness,
    Color? canvasTop,
    Color? canvasBottom,
    Color? surfacePrimary,
    Color? surfaceElevated,
    Color? surfaceGlass,
    Color? surfaceSelected,
    Color? borderSubtle,
    Color? borderHighlight,
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? accentCyan,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOnPrimary,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? iconBadgeBgStart,
    Color? iconBadgeBgEnd,
    Color? shadowColor,
  }) {
    return AppColorPalette(
      brightness: brightness ?? this.brightness,
      canvasTop: canvasTop ?? this.canvasTop,
      canvasBottom: canvasBottom ?? this.canvasBottom,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      surfaceSelected: surfaceSelected ?? this.surfaceSelected,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderHighlight: borderHighlight ?? this.borderHighlight,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      accentCyan: accentCyan ?? this.accentCyan,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      iconBadgeBgStart: iconBadgeBgStart ?? this.iconBadgeBgStart,
      iconBadgeBgEnd: iconBadgeBgEnd ?? this.iconBadgeBgEnd,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  AppColorPalette lerp(ThemeExtension<AppColorPalette>? other, double t) {
    if (other is! AppColorPalette) return this;
    return AppColorPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      canvasTop: Color.lerp(canvasTop, other.canvasTop, t)!,
      canvasBottom: Color.lerp(canvasBottom, other.canvasBottom, t)!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      surfaceSelected: Color.lerp(surfaceSelected, other.surfaceSelected, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderHighlight: Color.lerp(borderHighlight, other.borderHighlight, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      iconBadgeBgStart: Color.lerp(iconBadgeBgStart, other.iconBadgeBgStart, t)!,
      iconBadgeBgEnd: Color.lerp(iconBadgeBgEnd, other.iconBadgeBgEnd, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}

extension AppColorsBuildContext on BuildContext {
  AppColorPalette get colors =>
      Theme.of(this).extension<AppColorPalette>() ?? AppColorPalette.light;
}
