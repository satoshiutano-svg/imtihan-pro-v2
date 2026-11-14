import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../data/models/paper_models.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 14: Solved Paper Reader with Paper / Solution toggle.
class SolvedPaperScreen extends ConsumerStatefulWidget {
  const SolvedPaperScreen({
    super.key,
    required this.paperId,
  });

  final String paperId;

  @override
  ConsumerState<SolvedPaperScreen> createState() => _SolvedPaperScreenState();
}

class _SolvedPaperScreenState extends ConsumerState<SolvedPaperScreen> {
  bool _showSolution = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final paper = ref.read(pastPaperRepositoryProvider).getPaperById(
          paperId: widget.paperId,
          preferredBoard: onboarding.selectedBoard ?? KpkBoard.peshawar,
          classLevel: onboarding.selectedClass ?? ClassLevel.class10,
        );

    if (paper == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Solved Paper'),
        body: ImtihanErrorView(message: 'Past paper could not be loaded.'),
      );
    }

    final bool isBookmarked = activity.bookmarkedPaperIds.contains(paper.id);
    final bool isDownloaded = activity.downloadedPaperIds.contains(paper.id);

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: '${paper.year} Paper',
        subtitle: '${paper.subjectName} • ${paper.board.name}',
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Bookmarked' : 'Bookmark Paper',
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            onPressed: () => ref
                .read(studentActivityProvider.notifier)
                .togglePaperBookmark(paper.id),
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isBookmarked ? palette.primary : palette.textPrimary,
            ),
          ),
          IconButton(
            tooltip: isDownloaded ? 'Saved Offline' : 'Download Paper',
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            onPressed: () => ref
                .read(studentActivityProvider.notifier)
                .togglePaperDownload(paper.id),
            icon: Icon(
              isDownloaded
                  ? Icons.download_done_rounded
                  : Icons.download_outlined,
              color: isDownloaded ? palette.success : palette.textPrimary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Paper | Solution Pill Segmented Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: palette.surfacePrimary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(color: palette.borderSubtle),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      label: 'Paper',
                      selected: !_showSolution,
                      onTap: () => setState(() => _showSolution = false),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
                      label: 'Solution',
                      selected: _showSolution,
                      onTap: () => setState(() => _showSolution = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Expanded(
              child: ImtihanCard(
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${paper.board.name.toUpperCase()} — ${paper.year}',
                            style: textTheme.titleSmall?.copyWith(
                              color: palette.primary,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${paper.classLevel.label} • ${paper.subjectName}',
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            'Total Marks: ${paper.totalMarks} • Time: ${paper.durationMinutes} Minutes',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(),
                    ),
                    ...paper.questions.map(
                      (q) => _PaperQuestionBlock(
                        question: q,
                        showSolution: _showSolution,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: _showSolution ? 'View Question Paper' : 'View Solution',
              onPressed: () => setState(() => _showSolution = !_showSolution),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 40,
        decoration: BoxDecoration(
          color: selected ? palette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? palette.textOnPrimary : palette.textSecondary,
                ),
          ),
        ),
      ),
    );
  }
}

class _PaperQuestionBlock extends StatelessWidget {
  const _PaperQuestionBlock({
    required this.question,
    required this.showSolution,
  });

  final PaperQuestion question;
  final bool showSolution;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    final String sectionLabel = switch (question.section) {
      PaperSectionType.mcqs => 'Section A (MCQ)',
      PaperSectionType.shortQuestions => 'Section B (Short)',
      PaperSectionType.longQuestions => 'Section C (Long)',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${question.questionNumber} • $sectionLabel',
                style: textTheme.labelMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '[${question.marks} ${question.marks == 1 ? 'Mark' : 'Marks'}]',
                style: textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            question.prompt,
            style: textTheme.bodyLarge,
          ),
          if (question.options.isNotEmpty && !showSolution) ...[
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(question.options.length, (idx) {
              final letter = String.fromCharCode(65 + idx);
              return Padding(
                padding: const EdgeInsets.only(bottom: 2, left: AppSpacing.sm),
                child: Text(
                  '($letter) ${question.options[idx]}',
                  style: textTheme.bodyMedium,
                ),
              );
            }),
          ],
          if (showSolution) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: palette.successSoft,
                borderRadius: AppSpacing.badgeBorderRadius,
                border: Border.all(
                  color: palette.success.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Official Marking Solution',
                    style: textTheme.labelMedium?.copyWith(
                      color: palette.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.solution,
                    style: textTheme.bodyMedium?.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
