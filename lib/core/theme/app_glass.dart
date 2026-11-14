import 'dart:ui';

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';

/// Selective glassmorphism surface.
///
/// Set [enableBlur] to true ONLY on stationary chrome (floating bottom nav,
/// sticky header bars, or hero highlight cards) so scrollable lists remain
/// 60fps on budget 8GB Android devices.
class ImtihanGlassSurface extends StatelessWidget {
  const ImtihanGlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.enableBlur = false,
    this.blurSigma = 10,
    this.isSelected = false,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool enableBlur;
  final double blurSigma;
  final bool isSelected;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final radius = borderRadius ?? AppSpacing.cardBorderRadius;

    final Color fillColor = isSelected
        ? palette.surfaceSelected
        : (enableBlur ? palette.surfaceGlass : palette.surfacePrimary);

    final Color borderColor =
        isSelected ? palette.primary.withValues(alpha: 0.65) : palette.borderSubtle;

    final Widget decorated = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: radius,
        border: Border.all(
          color: borderColor,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: showShadow ? AppShadows.card(palette) : null,
      ),
      child: child,
    );

    if (!enableBlur) {
      return decorated;
    }

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: decorated,
      ),
    );
  }
}
