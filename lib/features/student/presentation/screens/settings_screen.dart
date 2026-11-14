import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 27: Settings (matches approved reference layout in Light & Dark themes).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final themeMode = ref.watch(themeControllerProvider);

    final String themeLabel = switch (themeMode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    final String initial = onboarding.studentName.isNotEmpty
        ? onboarding.studentName[0].toUpperCase()
        : 'S';

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(title: 'Settings'),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Student Profile Summary Card
          ImtihanCard(
            onTap: () => context.push(RouteNames.profile),
            padding: AppSpacing.compactCardPadding,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: palette.primary,
                  child: Text(
                    initial,
                    style: textTheme.titleMedium?.copyWith(
                      color: palette.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(onboarding.studentName, style: textTheme.titleMedium),
                      Text(
                        '${onboarding.selectedClass?.label ?? 'Class 10'} • ${onboarding.selectedBoard?.name ?? 'BISE Peshawar'}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: palette.textMuted),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Theme, Language, Notifications, Offline Mode Card
          ImtihanCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                _SettingsActionTile(
                  icon: Icons.dark_mode_rounded,
                  title: 'Theme',
                  trailingText: themeLabel,
                  onTap: () => _showThemePicker(context, ref, themeMode),
                ),
                const Divider(),
                _SettingsActionTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailingText: 'English',
                  onTap: () => _showInfoDialog(
                    context,
                    title: 'Language',
                    message:
                        'Imtihan Pro is currently configured in English for KPK BISE curricula. Urdu & regional language packs are planned for a future update.',
                  ),
                ),
                const Divider(),
                _SettingsSwitchTile(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  value: activity.notificationsEnabled,
                  onChanged: (val) => ref
                      .read(studentActivityProvider.notifier)
                      .setNotificationsEnabled(val),
                ),
                const Divider(),
                _SettingsSwitchTile(
                  icon: Icons.offline_bolt_rounded,
                  title: 'Offline Mode',
                  value: activity.offlineModeEnabled,
                  onChanged: (val) => ref
                      .read(studentActivityProvider.notifier)
                      .setOfflineModeEnabled(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // About, Help & Support, Privacy Policy Card
          ImtihanCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                _SettingsActionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About App',
                  onTap: () => _showInfoDialog(
                    context,
                    title: 'About Imtihan Pro',
                    message:
                        'Imtihan Pro v1.0.0 — Dedicated board exam preparation companion for Class 9–12 students across all 8 KPK BISE boards.',
                  ),
                ),
                const Divider(),
                _SettingsActionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => _showInfoDialog(
                    context,
                    title: 'Help & Support',
                    message:
                        'Use the Learn tab for chapter notes, Papers for 2022–2025 solved board papers, and Practice for instant MCQ explanations and timed Mock Exams.',
                  ),
                ),
                const Divider(),
                _SettingsActionTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showInfoDialog(
                    context,
                    title: 'Privacy Policy',
                    message:
                        'Your study progress, bookmarks, planner tasks, and theme preferences are stored locally on your device.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          ImtihanSecondaryButton(
            label: 'Log Out',
            icon: Icons.logout_rounded,
            onPressed: () => _confirmReset(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Theme',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              ...[
                (ThemeMode.light, 'Light (Silver Blue)', Icons.light_mode_rounded),
                (ThemeMode.dark, 'Dark (Deep Navy)', Icons.dark_mode_rounded),
                (ThemeMode.system, 'Follow System', Icons.brightness_auto_rounded),
              ].map((entry) {
                final (mode, label, icon) = entry;
                final bool selected = current == mode;
                return ListTile(
                  leading: Icon(icon),
                  title: Text(label),
                  trailing: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? sheetContext.colors.primary : null,
                  ),
                  onTap: () async {
                    await ref
                        .read(themeControllerProvider.notifier)
                        .setThemeMode(mode);
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out & Reset Profile?'),
        content: const Text(
          'This clears your local class/board selections and study progress on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(studentActivityProvider.notifier).resetAllActivity();
      await ref.read(onboardingControllerProvider.notifier).resetOnboarding();
      if (context.mounted) {
        context.go(RouteNames.welcome);
      }
    }
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      minVerticalPadding: 12,
      leading: ImtihanIconBadge(icon: icon, size: 36, iconSize: 18),
      title: Text(title, style: textTheme.titleSmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: textTheme.bodySmall,
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: ImtihanIconBadge(icon: icon, size: 36, iconSize: 18),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
