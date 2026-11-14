import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// Five-tab bottom navigation shell: Home, Learn, Papers, Practice, Progress.
class ImtihanBottomNav extends StatelessWidget {
  const ImtihanBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavTabItem> _tabs = [
    _NavTabItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavTabItem(
      label: 'Learn',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
    ),
    _NavTabItem(
      label: 'Papers',
      icon: Icons.description_outlined,
      activeIcon: Icons.description_rounded,
    ),
    _NavTabItem(
      label: 'Practice',
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt_rounded,
    ),
    _NavTabItem(
      label: 'Progress',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadows.floatingNav(palette),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSheet),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: bottomInset > 0 ? bottomInset : AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: palette.surfaceGlass,
              border: Border(
                top: BorderSide(color: palette.borderSubtle, width: 1),
              ),
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final bool selected = index == currentIndex;

                return Expanded(
                  child: _BottomNavButton(
                    tab: tab,
                    selected: selected,
                    onTap: () => onTap(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _NavTabItem tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final Color activeColor = palette.primary;
    final Color inactiveColor = palette.textMuted;

    return Semantics(
      selected: selected,
      button: true,
      label: '${tab.label} tab',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.badgeBorderRadius,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? activeColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Icon(
                  selected ? tab.activeIcon : tab.icon,
                  size: 22,
                  color: selected ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? activeColor : inactiveColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTabItem {
  const _NavTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
