import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_progress_ring.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../state/mock_exam_session.dart';

/// Screen 19: Exam Results.
class ExamResultsScreen extends ConsumerWidget {
  const ExamResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final result = ref.watch(mockExamSessionProvider)?.latestResult;

    if (result == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Exam Results'),
        body: ImtihanErrorView(message: 'No completed exam result available.'),
      );
    }

    final int mins = result.durationSecondsTaken ~/ 60;
    final int secs = result.durationSecondsTaken % 60;

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: 'Exam Results',
        subtitle: result.subjectTitle,
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ImtihanCard(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      children: [
                        ImtihanProgressRing(
                          progress: result.accuracy,
                          size: 120,
                          strokeWidth: 12,
                          showCenterPercentage: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          '${result.correctCount} / ${result.totalQuestions} Correct',
                          style: AppTypography.tabularNumeric(
                            textTheme.displayMedium ?? const TextStyle(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Grade: ${result.gradeLabel}',
                          style: textTheme.titleMedium?.copyWith(
                            color: result.percentage >= 60
                                ? palette.success
                                : palette.warning,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Time Taken: ${mins}m ${secs}s',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _ResultStatCard(
                          label: 'Correct',
                          value: '${result.correctCount}',
                          color: palette.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ResultStatCard(
                          label: 'Wrong',
                          value: '${result.wrongCount}',
                          color: palette.danger,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ResultStatCard(
                          label: 'Skipped',
                          value: '${result.unansweredCount}',
                          color: palette.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Review Mistakes',
              icon: Icons.fact_check_rounded,
              onPressed: () => context.push(
                '${RouteNames.practice}/${RouteNames.mistakeReview}',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ImtihanSecondaryButton(
              label: 'Done',
              onPressed: () => context.go(RouteNames.practice),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultStatCard extends StatelessWidget {
  const _ResultStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.tabularNumeric(
              (textTheme.headlineMedium ?? const TextStyle())
                  .copyWith(color: color),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
