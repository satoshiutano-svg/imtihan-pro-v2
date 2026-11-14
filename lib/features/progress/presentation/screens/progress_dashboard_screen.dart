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
import '../../../../core/widgets/imtihan_progress_ring.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 21: Progress Dashboard (Progress Tab root).
class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final repo = ref.read(curriculumRepositoryProvider);

    final subjects = repo.getSubjectsForGroup(
      onboarding.selectedGroup ?? AcademicGroup.science,
    );
    final allChapters = subjects.expand((s) => s.chapters).toList();
    final int completedChapters = allChapters
        .where((c) => activity.completedChapterIds.contains(c.id))
        .length;
    final double syllabusProgress =
        allChapters.isEmpty ? 0.0 : completedChapters / allChapters.length;

    final bottomPadding = 104 + MediaQuery.viewPaddingOf(context).bottom;

    return Column(
      children: [
        ImtihanAppBar(
          title: 'Progress',
          subtitle: '${onboarding.studentName} • ${onboarding.selectedBoard?.name ?? 'KPK BISE'}',
          showBackButton: false,
          actions: [
            IconButton(
              tooltip: 'Settings',
              constraints: const BoxConstraints(
                minWidth: AppSpacing.minTouchTarget,
                minHeight: AppSpacing.minTouchTarget,
              ),
              onPressed: () => context.push(RouteNames.settings),
              icon: Icon(Icons.settings_outlined, color: palette.textPrimary),
            ),
          ],
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
              // Overall Readiness Card
              ImtihanCard(
                child: Row(
                  children: [
                    ImtihanProgressRing(
                      progress: syllabusProgress,
                      size: 88,
                      strokeWidth: 10,
                      showCenterPercentage: true,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Syllabus Readiness', style: textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            '$completedChapters of ${allChapters.length} chapters completed',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Study Time: ${activity.formattedStudyTime}',
                            style: textTheme.labelMedium?.copyWith(
                              color: palette.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Practice Stats Row
              Row(
                children: [
                  Expanded(
                    child: ImtihanCard(
                      padding: AppSpacing.compactCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MCQs Solved', style: textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${activity.mcqsAttempted}',
                            style: AppTypography.tabularNumeric(
                              textTheme.headlineMedium ?? const TextStyle(),
                            ),
                          ),
                          Text(
                            activity.mcqsAttempted == 0
                                ? 'No attempts yet'
                                : '${(activity.mcqAccuracy * 100).round()}% accuracy',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ImtihanCard(
                      padding: AppSpacing.compactCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mock Exams', style: textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${activity.examHistory.length}',
                            style: AppTypography.tabularNumeric(
                              textTheme.headlineMedium ?? const TextStyle(),
                            ),
                          ),
                          Text(
                            activity.examHistory.isEmpty
                                ? 'Not attempted'
                                : 'Avg ${activity.averageExamPercentage}%',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Subject Breakdown
              Text('Subject Mastery', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ...subjects.map((subject) {
                final done = subject.chapters
                    .where((c) => activity.completedChapterIds.contains(c.id))
                    .length;
                final ratio = subject.chapters.isEmpty
                    ? 0.0
                    : done / subject.chapters.length;
                final accent =
                    SubjectVisuals.accentFor(subject.visualKind, palette);

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ImtihanCard(
                    padding: AppSpacing.compactCardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              SubjectVisuals.iconFor(subject.visualKind),
                              size: 18,
                              color: accent,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                subject.title,
                                style: textTheme.titleSmall,
                              ),
                            ),
                            Text(
                              '$done/${subject.chapters.length}',
                              style: AppTypography.tabularNumeric(
                                textTheme.labelMedium ?? const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(
                          value: ratio,
                          minHeight: 7,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                          backgroundColor: palette.surfaceElevated,
                          color: accent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),

              // Student Workspace Utilities
              Text('Student Workspace', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              _WorkspaceRow(
                icon: Icons.calendar_today_rounded,
                title: 'Study Planner',
                subtitle: '${activity.studyTasks.length} scheduled tasks',
                accent: palette.primary,
                onTap: () => context.push(RouteNames.studyPlanner),
              ),
              const SizedBox(height: AppSpacing.sm),
              _WorkspaceRow(
                icon: Icons.bookmark_rounded,
                title: 'Bookmarks',
                subtitle:
                    '${activity.bookmarkedChapterIds.length + activity.bookmarkedPaperIds.length} saved items',
                accent: palette.accentCyan,
                onTap: () => context.push(RouteNames.bookmarks),
              ),
              const SizedBox(height: AppSpacing.sm),
              _WorkspaceRow(
                icon: Icons.download_done_rounded,
                title: 'Downloads',
                subtitle:
                    '${activity.downloadedChapterIds.length + activity.downloadedPaperIds.length} offline items',
                accent: palette.success,
                onTap: () => context.push(RouteNames.downloads),
              ),
              const SizedBox(height: AppSpacing.sm),
              _WorkspaceRow(
                icon: Icons.emoji_events_rounded,
                title: 'Achievements',
                subtitle: 'Track study milestones',
                accent: palette.warning,
                onTap: () => context.push(RouteNames.achievements),
              ),
              const SizedBox(height: AppSpacing.sm),
              _WorkspaceRow(
                icon: Icons.person_rounded,
                title: 'Student Profile & Settings',
                subtitle: 'Board, Class, Theme & Preferences',
                accent: palette.primary,
                onTap: () => context.push(RouteNames.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkspaceRow extends StatelessWidget {
  const _WorkspaceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
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
          ImtihanIconBadge(
            icon: icon,
            size: 40,
            iconSize: 20,
            accentColor: accent,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleSmall),
                Text(subtitle, style: textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}
