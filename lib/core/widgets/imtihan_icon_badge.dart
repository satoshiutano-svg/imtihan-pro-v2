import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Dual-tone rounded icon badge matching Imtihan Pro's layered Silver Blue icon aesthetic.
class ImtihanIconBadge extends StatelessWidget {
  const ImtihanIconBadge({
    super.key,
    required this.icon,
    this.size = 42,
    this.iconSize = 21,
    this.accentColor,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final Color effectiveAccent = accentColor ?? palette.primary;

    final List<Color> gradientColors = accentColor == null
        ? [palette.iconBadgeBgStart, palette.iconBadgeBgEnd]
        : [
            effectiveAccent.withValues(
              alpha: palette.brightness == Brightness.dark ? 0.28 : 0.16,
            ),
            effectiveAccent.withValues(
              alpha: palette.brightness == Brightness.dark ? 0.14 : 0.08,
            ),
          ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusIconBadge),
        border: Border.all(
          color: effectiveAccent.withValues(
            alpha: palette.brightness == Brightness.dark ? 0.30 : 0.16,
          ),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: effectiveAccent,
        ),
      ),
    );
  }
}
