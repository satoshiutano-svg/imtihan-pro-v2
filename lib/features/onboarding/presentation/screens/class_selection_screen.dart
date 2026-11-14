import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../state/onboarding_controller.dart';
import '../widgets/selection_option_tile.dart';

/// Screen 3: Class Selection (Class 9-12).
class ClassSelectionScreen extends ConsumerWidget {
  const ClassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedClass = ref.watch(
      onboardingControllerProvider.select((state) => state.selectedClass),
    );

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Select Class',
        subtitle: 'Choose your class level',
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: ClassLevel.values.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final level = ClassLevel.values[index];
                  return SelectionOptionTile(
                    title: level.label,
                    subtitle: level.subtitle,
                    icon: Icons.class_rounded,
                    isSelected: selectedClass == level,
                    onTap: () => ref
                        .read(onboardingControllerProvider.notifier)
                        .selectClass(level),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Next',
              onPressed: selectedClass == null
                  ? null
                  : () => context.push(RouteNames.selectBoard),
            ),
          ],
        ),
      ),
    );
  }
}
