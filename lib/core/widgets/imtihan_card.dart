import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// Layered carved card with subtle specular rim, optional selection state,
/// and budget-Android-friendly ripple interaction.
class ImtihanCard extends StatelessWidget {
  const ImtihanCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = AppSpacing.cardPadding,
    this.isSelected = false,
    this.borderRadius,
    this.showShadow = true,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool isSelected;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final BorderRadius radius = borderRadius ?? AppSpacing.cardBorderRadius;

    final Color borderColor = isSelected
        ? palette.primary
        : palette.borderSubtle;

    final BoxDecoration decoration = BoxDecoration(
      gradient: isSelected ? null : palette.cardSheenGradient,
      color: isSelected ? palette.surfaceSelected : null,
      borderRadius: radius,
      border: Border.all(
        color: borderColor,
        width: isSelected ? 1.6 : 1.0,
      ),
      boxShadow: showShadow ? AppShadows.card(palette) : null,
    );

    final Widget content = Padding(
      padding: padding,
      child: child,
    );

    final Widget card = Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.minTouchTarget,
      ),
      decoration: decoration,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: radius,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                splashColor: palette.primary.withValues(alpha: 0.08),
                highlightColor: palette.primary.withValues(alpha: 0.04),
                child: content,
              ),
            ),
    );

    if (semanticLabel != null) {
      return Semantics(
        button: onTap != null,
        selected: isSelected,
        label: semanticLabel,
        child: card,
      );
    }

    return card;
  }
}
