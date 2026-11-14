import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../data/models/practice_models.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';
import '../../state/mock_exam_session.dart';

/// Screen 17: Mock Exam Setup.
class MockExamSetupScreen extends ConsumerStatefulWidget {
  const MockExamSetupScreen({super.key});

  @override
  ConsumerState<MockExamSetupScreen> createState() =>
      _MockExamSetupScreenState();
}

class _MockExamSetupScreenState extends ConsumerState<MockExamSetupScreen> {
  String? _subjectId;
  String? _subjectTitle;
  int _questionCount = 10;
  int _durationMinutes = 10;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final group = onboarding.selectedGroup ?? AcademicGroup.science;
    final groupSubjects =
        ref.read(curriculumRepositoryProvider).getSubjectsForGroup(group);

    final subjects = <(String, String)>[
      ...groupSubjects.map((s) => (s.id, s.title)),
      ('all', 'Mixed ${group.label}'),
    ];

    final String effectiveSubjectId =
        subjects.any((s) => s.$1 == _subjectId) ? _subjectId! : subjects.first.$1;
    final String effectiveSubjectTitle = subjects
        .firstWhere((s) => s.$1 == effectiveSubjectId)
        .$2;

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Mock Exam Setup',
        subtitle: 'Configure your timed board test',
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ImtihanCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Subject', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: subjects.map((entry) {
                            final (id, label) = entry;
                            final selected = effectiveSubjectId == id;
                            return ChoiceChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: (_) => setState(() {
                                _subjectId = id;
                                _subjectTitle = label;
                              }),
                              selectedColor: palette.primary,
                              backgroundColor: palette.surfaceElevated,
                              labelStyle: textTheme.labelMedium?.copyWith(
                                color: selected
                                    ? palette.textOnPrimary
                                    : palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? palette.primary
                                    : palette.borderSubtle,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ImtihanCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Number of Questions', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [5, 10, 15].map((count) {
                            final selected = _questionCount == count;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _OptionBox(
                                  label: '$count MCQs',
                                  selected: selected,
                                  onTap: () =>
                                      setState(() => _questionCount = count),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ImtihanCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Time Limit', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [5, 10, 20].map((mins) {
                            final selected = _durationMinutes == mins;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _OptionBox(
                                  label: '$mins min',
                                  selected: selected,
                                  onTap: () =>
                                      setState(() => _durationMinutes = mins),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Start Mock Exam',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                ref.read(mockExamSessionProvider.notifier).startExam(
                      MockExamConfig(
                        subjectId: effectiveSubjectId,
                        subjectTitle: _subjectTitle ?? effectiveSubjectTitle,
                        questionCount: _questionCount,
                        durationMinutes: _durationMinutes,
                      ),
                    );
                unawaited(
                  context.pushReplacement(
                    '${RouteNames.practice}/${RouteNames.mockExamSession}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionBox extends StatelessWidget {
  const _OptionBox({
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

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.badgeBorderRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        decoration: BoxDecoration(
          color: selected ? palette.primary : palette.surfaceElevated,
          borderRadius: AppSpacing.badgeBorderRadius,
          border: Border.all(
            color: selected ? palette.primary : palette.borderSubtle,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? palette.textOnPrimary : palette.textPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
