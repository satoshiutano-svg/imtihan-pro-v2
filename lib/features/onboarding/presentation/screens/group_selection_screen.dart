import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../state/onboarding_controller.dart';
import '../widgets/selection_option_tile.dart';

/// Screen 5: Academic Group Selection (Science, Arts, Commerce).
class GroupSelectionScreen extends ConsumerWidget {
  const GroupSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final selectedGroup = ref.watch(
      onboardingControllerProvider.select((state) => state.selectedGroup),
    );

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Select Group',
        subtitle: 'Choose your academic group',
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: AcademicGroup.values.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final group = AcademicGroup.values[index];
                  final (IconData icon, Color accent) = switch (group) {
                    AcademicGroup.science => (
                        Icons.science_rounded,
                        palette.primary,
                      ),
                    AcademicGroup.arts => (
                        Icons.palette_rounded,
                        palette.warning,
                      ),
                    AcademicGroup.commerce => (
                        Icons.trending_up_rounded,
                        palette.accentCyan,
                      ),
                  };

                  return SelectionOptionTile(
                    title: group.label,
                    subtitle: group.subtitle,
                    icon: icon,
                    accentColor: accent,
                    isSelected: selectedGroup == group,
                    onTap: () => ref
                        .read(onboardingControllerProvider.notifier)
                        .selectGroup(group),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Continue',
              onPressed: selectedGroup == null
                  ? null
                  : () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) {
                        context.go(RouteNames.home);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
