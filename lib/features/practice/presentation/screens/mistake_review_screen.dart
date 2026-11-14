import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../state/mock_exam_session.dart';

/// Screen 20: Mistake Review.
class MistakeReviewScreen extends ConsumerStatefulWidget {
  const MistakeReviewScreen({super.key});

  @override
  ConsumerState<MistakeReviewScreen> createState() =>
      _MistakeReviewScreenState();
}

class _MistakeReviewScreenState extends ConsumerState<MistakeReviewScreen> {
  bool _wrongOnly = true;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final result = ref.watch(mockExamSessionProvider)?.latestResult;

    if (result == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Mistake Review'),
        body: ImtihanErrorView(message: 'No exam attempt found to review.'),
      );
    }

    final items = _wrongOnly
        ? result.answers.where((a) => !a.isCorrect).toList()
        : result.answers;

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: 'Mistake Review',
        subtitle: '${result.subjectTitle} • ${result.percentage}%',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Mistakes & Skipped')),
                    selected: _wrongOnly,
                    onSelected: (_) => setState(() => _wrongOnly = true),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('All Questions')),
                    selected: !_wrongOnly,
                    onSelected: (_) => setState(() => _wrongOnly = false),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const ImtihanEmptyView(
                    title: 'Zero Mistakes!',
                    subtitle:
                        'You answered every question correctly in this mock exam.',
                    icon: Icons.emoji_events_rounded,
                  )
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final answer = items[index];
                      final q = answer.question;
                      final String selectedText = answer.selectedIndex == null
                          ? 'Skipped'
                          : q.options[answer.selectedIndex!];
                      final String correctText = q.options[q.correctIndex];

                      return ImtihanCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q.question, style: textTheme.titleSmall),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Icon(
                                  answer.isCorrect
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 18,
                                  color: answer.isCorrect
                                      ? palette.success
                                      : palette.danger,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Your Answer: $selectedText',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: answer.isCorrect
                                          ? palette.success
                                          : palette.danger,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!answer.isCorrect) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: palette.success,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Correct Answer: $correctText',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: palette.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              q.explanation,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
