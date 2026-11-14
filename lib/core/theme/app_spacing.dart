import 'package:flutter/material.dart';

/// Consistent 4dp-based spacing, border radii, and Android touch-target tokens.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets compactCardPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Minimum interactive touch target per Android Accessibility guidelines.
  static const double minTouchTarget = 48;

  /// Standard carved card and button radii.
  static const double radiusSm = 10;
  static const double radiusIconBadge = 12;
  static const double radiusButton = 16;
  static const double radiusCard = 18;
  static const double radiusSheet = 24;
  static const double radiusPill = 999;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(radiusButton);
  static final BorderRadius badgeBorderRadius = BorderRadius.circular(radiusIconBadge);
}
