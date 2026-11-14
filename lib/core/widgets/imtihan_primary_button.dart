import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// Primary gradient CTA button matching the Silver Blue / Navy visual identity.
class ImtihanPrimaryButton extends StatelessWidget {
  const ImtihanPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final bool enabled = onPressed != null && !isLoading;

    final Widget inner = AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: enabled ? 1.0 : 0.55,
      child: Container(
        height: 52,
        constraints: const BoxConstraints(
          minHeight: AppSpacing.minTouchTarget,
        ),
        decoration: BoxDecoration(
          gradient: palette.primaryButtonGradient,
          borderRadius: AppSpacing.buttonBorderRadius,
          boxShadow: enabled ? AppShadows.primaryButton(palette) : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppSpacing.buttonBorderRadius,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: AppSpacing.buttonBorderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: palette.textOnPrimary,
                      ),
                    )
                  else ...[
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: palette.textOnPrimary),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: palette.textOnPrimary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: inner) : inner;
  }
}

/// Secondary outlined surface button ("Sign In", secondary actions).
class ImtihanSecondaryButton extends StatelessWidget {
  const ImtihanSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    final Widget inner = Container(
      height: 52,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.minTouchTarget,
      ),
      decoration: BoxDecoration(
        color: palette.surfacePrimary,
        borderRadius: AppSpacing.buttonBorderRadius,
        border: Border.all(color: palette.borderSubtle, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.buttonBorderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppSpacing.buttonBorderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: palette.primary),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: inner) : inner;
  }
}
