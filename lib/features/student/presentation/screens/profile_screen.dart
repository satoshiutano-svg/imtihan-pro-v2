import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 26: Student Profile with live Class, KPK Board, Group & Name editing.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final String initial = onboarding.studentName.isNotEmpty
        ? onboarding.studentName[0].toUpperCase()
        : 'S';

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Profile',
        subtitle: 'Manage your academic preferences',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          ImtihanCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: palette.primary,
                  child: Text(
                    initial,
                    style: textTheme.headlineMedium?.copyWith(
                      color: palette.textOnPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(onboarding.studentName, style: textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        '${onboarding.selectedClass?.label ?? 'Class 10'} • ${onboarding.selectedBoard?.name ?? 'BISE Peshawar'}',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit Name',
                  onPressed: () => _editNameDialog(context, ref, onboarding.studentName),
                  icon: Icon(Icons.edit_outlined, color: palette.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Academic Details', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          _ProfileOptionCard(
            icon: Icons.class_rounded,
            label: 'Class Level',
            value: onboarding.selectedClass?.label ?? 'Select Class',
            onTap: () => _pickClass(context, ref),
          ),
          const SizedBox(height: AppSpacing.md),
          _ProfileOptionCard(
            icon: Icons.account_balance_rounded,
            label: 'KPK BISE Board',
            value: onboarding.selectedBoard?.name ?? 'Select Board',
            onTap: () => _pickBoard(context, ref),
          ),
          const SizedBox(height: AppSpacing.md),
          _ProfileOptionCard(
            icon: Icons.science_rounded,
            label: 'Academic Group',
            value: onboarding.selectedGroup?.label ?? 'Select Group',
            onTap: () => _pickGroup(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _editNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Student Name'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(onboardingControllerProvider.notifier)
                  .updateStudentName(controller.text);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _pickClass(BuildContext context, WidgetRef ref) async {
    await _showPickerSheet<ClassLevel>(
      context: context,
      title: 'Select Class',
      items: ClassLevel.values,
      labelBuilder: (item) => item.label,
      onSelected: (item) =>
          ref.read(onboardingControllerProvider.notifier).selectClass(item),
    );
  }

  Future<void> _pickBoard(BuildContext context, WidgetRef ref) async {
    await _showPickerSheet<KpkBoard>(
      context: context,
      title: 'Select KPK BISE Board',
      items: KpkBoard.values,
      labelBuilder: (item) => item.name,
      onSelected: (item) =>
          ref.read(onboardingControllerProvider.notifier).selectBoard(item),
    );
  }

  Future<void> _pickGroup(BuildContext context, WidgetRef ref) async {
    await _showPickerSheet<AcademicGroup>(
      context: context,
      title: 'Select Academic Group',
      items: AcademicGroup.values,
      labelBuilder: (item) => item.label,
      onSelected: (item) =>
          ref.read(onboardingControllerProvider.notifier).selectGroup(item),
    );
  }

  Future<void> _showPickerSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    required Future<void> Function(T) onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(labelBuilder(item)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      await onSelected(item);
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ImtihanPrimaryButton(
              label: 'Close',
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  const _ProfileOptionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      onTap: onTap,
      padding: AppSpacing.compactCardPadding,
      child: Row(
        children: [
          ImtihanIconBadge(icon: icon, accentColor: palette.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall),
                Text(value, style: textTheme.titleMedium),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}
