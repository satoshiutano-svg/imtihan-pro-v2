import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 16: MCQ Practice (Practice Tab root).
class McqPracticeScreen extends ConsumerStatefulWidget {
  const McqPracticeScreen({super.key});

  @override
  ConsumerState<McqPracticeScreen> createState() => _McqPracticeScreenState();
}

class _McqPracticeScreenState extends ConsumerState<McqPracticeScreen> {
  String? _selectedSubjectId;
  int _questionIndex = 0;
  int? _chosenOption;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final group = onboarding.selectedGroup ?? AcademicGroup.science;

    final groupSubjects =
        ref.read(curriculumRepositoryProvider).getSubjectsForGroup(group);
    final filters = <(String?, String)>[
      (null, 'All (${group.label})'),
      ...groupSubjects.map((s) => (s.id, s.title)),
    ];

    // Ensure selected filter stays valid if student switches academic group.
    final bool filterExists = filters.any((f) => f.$1 == _selectedSubjectId);
    final String? effectiveSubjectId = filterExists ? _selectedSubjectId : null;

    final questions = ref.read(practiceRepositoryProvider).getMcqs(
          subjectId: effectiveSubjectId,
          group: effectiveSubjectId == null ? group : null,
        );

    final int safeIndex =
        questions.isEmpty ? 0 : _questionIndex.clamp(0, questions.length - 1);
    final currentQuestion = questions.isEmpty ? null : questions[safeIndex];

    final bottomPadding = 104 + MediaQuery.viewPaddingOf(context).bottom;

    return Column(
      children: [
        const ImtihanAppBar(
          title: 'Practice',
          subtitle: 'Board MCQs & Timed Mock Exams',
          showBackButton: false,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              bottomPadding,
            ),
            children: [
              // Mock Exam Launch Card
              ImtihanCard(
                onTap: () => unawaited(
                  context.push(
                    '${RouteNames.practice}/${RouteNames.mockExamSetup}',
                  ),
                ),
                padding: AppSpacing.compactCardPadding,
                child: Row(
                  children: [
                    ImtihanIconBadge(
                      icon: Icons.timer_rounded,
                      size: 46,
                      iconSize: 22,
                      accentColor: palette.warning,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timed Mock Exam', style: textTheme.titleMedium),
                          Text(
                            'Simulate KPK BISE exam pressure & review mistakes',
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

              // Dynamic Group-Aware Subject Filter Chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final (id, label) = filters[index];
                    final selected = effectiveSubjectId == id;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _selectedSubjectId = id;
                        _questionIndex = 0;
                        _chosenOption = null;
                      }),
                      selectedColor: palette.primary,
                      backgroundColor: palette.surfacePrimary,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: selected
                            ? palette.textOnPrimary
                            : palette.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: selected ? palette.primary : palette.borderSubtle,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (currentQuestion == null)
                const ImtihanEmptyView(
                  title: 'No MCQs available',
                  subtitle: 'Select another subject filter above.',
                )
              else ...[
                // Stats strip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${safeIndex + 1} of ${questions.length}',
                      style: AppTypography.tabularNumeric(
                        textTheme.titleSmall ?? const TextStyle(),
                      ),
                    ),
                    Text(
                      'Accuracy: ${activity.mcqsAttempted == 0 ? '—' : '${(activity.mcqAccuracy * 100).round()}%'}',
                      style: textTheme.labelMedium?.copyWith(
                        color: palette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                ImtihanCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentQuestion.boardTag != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: palette.surfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: palette.borderSubtle),
                          ),
                          child: Text(
                            currentQuestion.boardTag!,
                            style: textTheme.labelSmall?.copyWith(
                              color: palette.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Text(
                        currentQuestion.question,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ...List.generate(currentQuestion.options.length, (idx) {
                        final bool hasAnswered = _chosenOption != null;
                        final bool isCorrectOption =
                            idx == currentQuestion.correctIndex;
                        final bool isSelectedOption = idx == _chosenOption;

                        Color borderColor = palette.borderSubtle;
                        Color bgColor = palette.surfaceElevated;
                        IconData? trailingIcon;
                        Color? trailingColor;

                        if (hasAnswered) {
                          if (isCorrectOption) {
                            borderColor = palette.success;
                            bgColor = palette.successSoft;
                            trailingIcon = Icons.check_circle_rounded;
                            trailingColor = palette.success;
                          } else if (isSelectedOption) {
                            borderColor = palette.danger;
                            bgColor = palette.dangerSoft;
                            trailingIcon = Icons.cancel_rounded;
                            trailingColor = palette.danger;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: InkWell(
                            borderRadius: AppSpacing.buttonBorderRadius,
                            onTap: hasAnswered
                                ? null
                                : () {
                                    setState(() => _chosenOption = idx);
                                    unawaited(
                                      ref
                                          .read(studentActivityProvider.notifier)
                                          .recordMcqAnswer(
                                            isCorrect: idx ==
                                                currentQuestion.correctIndex,
                                          ),
                                    );
                                  },
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: AppSpacing.minTouchTarget,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: AppSpacing.buttonBorderRadius,
                                border: Border.all(
                                  color: borderColor,
                                  width: hasAnswered &&
                                          (isCorrectOption || isSelectedOption)
                                      ? 1.5
                                      : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 13,
                                    backgroundColor: palette.surfacePrimary,
                                    child: Text(
                                      String.fromCharCode(65 + idx),
                                      style: textTheme.labelMedium?.copyWith(
                                        color: palette.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      currentQuestion.options[idx],
                                      style: textTheme.bodyLarge,
                                    ),
                                  ),
                                  if (trailingIcon != null)
                                    Icon(
                                      trailingIcon,
                                      size: 20,
                                      color: trailingColor,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      if (_chosenOption != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: palette.surfaceSelected,
                            borderRadius: AppSpacing.badgeBorderRadius,
                            border: Border.all(
                              color: palette.primary.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explanation',
                                style: textTheme.labelMedium?.copyWith(
                                  color: palette.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentQuestion.explanation,
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
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: ImtihanSecondaryButton(
                        label: 'Previous',
                        onPressed: safeIndex > 0
                            ? () => setState(() {
                                  _questionIndex--;
                                  _chosenOption = null;
                                })
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ImtihanPrimaryButton(
                        label: safeIndex < questions.length - 1
                            ? 'Next MCQ'
                            : 'Restart Set',
                        onPressed: () => setState(() {
                          _questionIndex = safeIndex < questions.length - 1
                              ? safeIndex + 1
                              : 0;
                          _chosenOption = null;
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
