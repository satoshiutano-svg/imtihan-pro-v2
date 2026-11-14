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

/// Screen 4: Board Selection (all eight official KPK BISE boards).
class BoardSelectionScreen extends ConsumerWidget {
  const BoardSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBoard = ref.watch(
      onboardingControllerProvider.select((state) => state.selectedBoard),
    );

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Select Board',
        subtitle: 'Choose your KPK BISE board',
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: KpkBoard.values.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final board = KpkBoard.values[index];
                  return SelectionOptionTile(
                    title: board.name,
                    subtitle: board.region,
                    icon: Icons.account_balance_rounded,
                    isSelected: selectedBoard == board,
                    onTap: () => ref
                        .read(onboardingControllerProvider.notifier)
                        .selectBoard(board),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Next',
              onPressed: selectedBoard == null
                  ? null
                  : () => context.push(RouteNames.selectGroup),
            ),
          ],
        ),
      ),
    );
  }
}
