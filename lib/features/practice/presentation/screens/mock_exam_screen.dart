import 'dart:async';

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
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../state/mock_exam_session.dart';

/// Screen 18: Timed Mock Exam Interface with navigator sheet and exit confirmation.
class MockExamScreen extends ConsumerStatefulWidget {
  const MockExamScreen({super.key});

  @override
  ConsumerState<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends ConsumerState<MockExamScreen> {
  Timer? _timer;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = ref.read(mockExamSessionProvider);
      if (session == null) return;
      if (session.remainingSeconds <= 1) {
        _finishExam();
      } else {
        ref.read(mockExamSessionProvider.notifier).tickOneSecond();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _finishExam() async {
    if (_submitting) return;
    _submitting = true;
    _timer?.cancel();
    await ref.read(mockExamSessionProvider.notifier).submitExam();
    if (mounted) {
      context.pushReplacement(
        '${RouteNames.practice}/${RouteNames.examResults}',
      );
    }
  }

  Future<void> _confirmExit() async {
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit Mock Exam?'),
        content: const Text(
          'Your current exam attempt will be discarded if you leave before submitting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Continue Exam'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      context.pop();
    }
  }

  String _formatClock(int totalSeconds) {
    final int mins = totalSeconds ~/ 60;
    final int secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final session = ref.watch(mockExamSessionProvider);

    if (session == null || session.questions.isEmpty) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Mock Exam'),
        body: ImtihanErrorView(message: 'No active exam session found.'),
      );
    }

    final question = session.questions[session.currentIndex];
    final int? selectedOption = session.selectedAnswers[session.currentIndex];
    final bool isFlagged =
        session.flaggedIndices.contains(session.currentIndex);
    final bool lowTime = session.remainingSeconds <= 60;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirmExit());
      },
      child: ImtihanScaffold(
        appBar: ImtihanAppBar(
          title: session.config.subjectTitle,
          subtitle:
              'Question ${session.currentIndex + 1} of ${session.questions.length}',
          onBackPressed: _confirmExit,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: lowTime ? palette.dangerSoft : palette.surfaceElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(
                  color: lowTime ? palette.danger : palette.borderSubtle,
                ),
              ),
              child: Text(
                _formatClock(session.remainingSeconds),
                style: AppTypography.tabularNumeric(
                  (textTheme.labelLarge ?? const TextStyle()).copyWith(
                    color: lowTime ? palette.danger : palette.primary,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Question Navigator',
              constraints: const BoxConstraints(
                minWidth: AppSpacing.minTouchTarget,
                minHeight: AppSpacing.minTouchTarget,
              ),
              onPressed: () => _showNavigatorSheet(context, session),
              icon: Icon(Icons.grid_view_rounded, color: palette.textPrimary),
            ),
          ],
        ),
        body: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (session.currentIndex + 1) / session.questions.length,
                minHeight: 6,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                backgroundColor: palette.surfaceElevated,
                color: palette.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  children: [
                    ImtihanCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Q${session.currentIndex + 1}',
                                style: textTheme.labelLarge?.copyWith(
                                  color: palette.primary,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => ref
                                    .read(mockExamSessionProvider.notifier)
                                    .toggleFlagCurrent(),
                                icon: Icon(
                                  isFlagged
                                      ? Icons.flag_rounded
                                      : Icons.outlined_flag_rounded,
                                  size: 18,
                                  color: isFlagged
                                      ? palette.warning
                                      : palette.textMuted,
                                ),
                                label: Text(
                                  isFlagged ? 'Flagged' : 'Flag',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: isFlagged
                                        ? palette.warning
                                        : palette.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(question.question, style: textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.lg),
                          ...List.generate(question.options.length, (idx) {
                            final bool selected = selectedOption == idx;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: InkWell(
                                borderRadius: AppSpacing.buttonBorderRadius,
                                onTap: () => ref
                                    .read(mockExamSessionProvider.notifier)
                                    .selectAnswer(idx),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minHeight: AppSpacing.minTouchTarget,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.md,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? palette.surfaceSelected
                                        : palette.surfaceElevated,
                                    borderRadius: AppSpacing.buttonBorderRadius,
                                    border: Border.all(
                                      color: selected
                                          ? palette.primary
                                          : palette.borderSubtle,
                                      width: selected ? 1.6 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 13,
                                        backgroundColor: selected
                                            ? palette.primary
                                            : palette.surfacePrimary,
                                        child: Text(
                                          String.fromCharCode(65 + idx),
                                          style:
                                              textTheme.labelMedium?.copyWith(
                                            color: selected
                                                ? palette.textOnPrimary
                                                : palette.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Text(
                                          question.options[idx],
                                          style: textTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: ImtihanSecondaryButton(
                      label: 'Previous',
                      onPressed: session.currentIndex > 0
                          ? () => ref
                              .read(mockExamSessionProvider.notifier)
                              .goToQuestion(session.currentIndex - 1)
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ImtihanPrimaryButton(
                      label: session.currentIndex < session.questions.length - 1
                          ? 'Next'
                          : 'Submit Exam',
                      onPressed:
                          session.currentIndex < session.questions.length - 1
                              ? () => ref
                                  .read(mockExamSessionProvider.notifier)
                                  .goToQuestion(session.currentIndex + 1)
                              : _finishExam,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNavigatorSheet(
    BuildContext context,
    ActiveMockExamState session,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final palette = sheetContext.colors;
        return Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question Navigator',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: List.generate(session.questions.length, (idx) {
                  final bool answered = session.selectedAnswers.containsKey(idx);
                  final bool flagged = session.flaggedIndices.contains(idx);
                  final bool current = idx == session.currentIndex;

                  return InkWell(
                    onTap: () {
                      ref
                          .read(mockExamSessionProvider.notifier)
                          .goToQuestion(idx);
                      Navigator.of(sheetContext).pop();
                    },
                    borderRadius: AppSpacing.badgeBorderRadius,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: current
                            ? palette.primary
                            : (answered
                                ? palette.successSoft
                                : palette.surfaceElevated),
                        borderRadius: AppSpacing.badgeBorderRadius,
                        border: Border.all(
                          color: flagged
                              ? palette.warning
                              : (answered
                                  ? palette.success
                                  : palette.borderSubtle),
                          width: flagged ? 1.8 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${idx + 1}',
                          style:
                              Theme.of(sheetContext).textTheme.labelLarge?.copyWith(
                                    color: current
                                        ? palette.textOnPrimary
                                        : palette.textPrimary,
                                  ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xl),
              ImtihanPrimaryButton(
                label: 'Submit Exam Now',
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_finishExam());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
