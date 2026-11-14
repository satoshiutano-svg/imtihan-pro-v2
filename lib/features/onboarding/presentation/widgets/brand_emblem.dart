import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

/// Custom layered academic emblem (mortarboard + open book crest) used on
/// Splash and Welcome screens.
class ImtihanBrandEmblem extends StatelessWidget {
  const ImtihanBrandEmblem({
    super.key,
    this.size = 112,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            palette.accentCyan.withValues(
              alpha: palette.brightness == Brightness.dark ? 0.28 : 0.20,
            ),
            palette.primary.withValues(alpha: 0.04),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.74,
          height: size * 0.74,
          decoration: BoxDecoration(
            gradient: palette.primaryButtonGradient,
            borderRadius: BorderRadius.circular(size * 0.22),
            border: Border.all(
              color: palette.borderHighlight,
              width: 1.5,
            ),
            boxShadow: AppShadows.primaryButton(palette),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: size * 0.14,
                child: Icon(
                  Icons.menu_book_rounded,
                  size: size * 0.34,
                  color: palette.textOnPrimary.withValues(alpha: 0.92),
                ),
              ),
              Positioned(
                top: size * 0.12,
                child: Icon(
                  Icons.school_rounded,
                  size: size * 0.30,
                  color: palette.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact inline brand header used on the Welcome screen.
class ImtihanBrandHeader extends StatelessWidget {
  const ImtihanBrandHeader({
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: palette.primaryButtonGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusIconBadge),
            boxShadow: AppShadows.card(palette),
          ),
          child: Icon(
            Icons.school_rounded,
            size: 22,
            color: palette.textOnPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          'Imtihan Pro',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
