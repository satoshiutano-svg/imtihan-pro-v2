import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';

/// Shared selection card used across Class, KPK Board, and Academic Group screens.
class SelectionOptionTile extends StatelessWidget {
  const SelectionOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      onTap: onTap,
      isSelected: isSelected,
      padding: AppSpacing.compactCardPadding,
      semanticLabel: title,
      child: Row(
        children: [
          ImtihanIconBadge(
            icon: icon,
            accentColor: accentColor,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            isSelected
                ? Icons.check_circle_rounded
                : Icons.chevron_right_rounded,
            size: 22,
            color: isSelected ? palette.primary : palette.textMuted,
          ),
        ],
      ),
    );
  }
}
