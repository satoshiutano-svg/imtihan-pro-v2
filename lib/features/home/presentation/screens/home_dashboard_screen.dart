import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_glass.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_progress_ring.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/models/curriculum_models.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 6: Home Dashboard.
class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final curriculumRepo = ref.read(curriculumRepositoryProvider);

    final AcademicGroup group =
        onboarding.selectedGroup ?? AcademicGroup.science;
    final List<Subject> subjects = curriculumRepo.getSubjectsForGroup(group);
    final List<Chapter> allChapters =
        subjects.expand((subject) => subject.chapters).toList();

    final int completedCount = allChapters
        .where((c) => activity.completedChapterIds.contains(c.id))
        .length;
    final double overallProgress =
        allChapters.isEmpty ? 0.0 : completedCount / allChapters.length;
    final int progressPercent = (overallProgress * 100).round();

    final Subject continueSubject = subjects.firstWhere(
      (s) => s.id == activity.lastSubjectId,
      orElse: () => subjects.first,
    );
    final Chapter continueChapter = continueSubject.chapters.firstWhere(
      (c) => c.id == activity.lastChapterId,
      orElse: () {
        if (continueSubject.id == 'physics' &&
            continueSubject.chapters.length >= 3) {
          return continueSubject.chapters[2];
        }
        return continueSubject.chapters.first;
      },
    );

    final bottomPadding = 104 + MediaQuery.viewPaddingOf(context).bottom;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          bottomPadding,
        ),
        children: [
          // Top Greeting Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${onboarding.studentName}',
                      style: textTheme.displayMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Keep going, you’re doing great!',
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${onboarding.selectedClass?.label ?? 'Class 10'} • ${onboarding.selectedBoard?.name ?? 'BISE Peshawar'}',
                      style: textTheme.labelSmall?.copyWith(
                        color: palette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Search Curriculum',
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouchTarget,
                  minHeight: AppSpacing.minTouchTarget,
                ),
                onPressed: () => context.go(RouteNames.learn),
                icon: Icon(Icons.search_rounded, color: palette.textPrimary),
              ),
              IconButton(
                tooltip: 'Settings',
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouchTarget,
                  minHeight: AppSpacing.minTouchTarget,
                ),
                onPressed: () => context.push(RouteNames.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Hero Progress Card (selective glass surface)
          ImtihanGlassSurface(
            enableBlur: true,
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Progress',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$progressPercent%',
                        style: AppTypography.tabularNumeric(
                          textTheme.displayLarge ?? const TextStyle(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: palette.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${activity.formattedStudyTime} Study Time',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCount of ${allChapters.length} chapters completed',
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ImtihanProgressRing(
                  progress: overallProgress,
                  size: 92,
                  strokeWidth: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2x2 Quick Actions Grid
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: 'Study Notes',
                  subtitle: '${subjects.length} Subjects',
                  icon: Icons.menu_book_rounded,
                  accent: palette.primary,
                  onTap: () => context.go(RouteNames.learn),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _QuickActionCard(
                  title: 'Past Papers',
                  subtitle: 'KPK BISE',
                  icon: Icons.description_rounded,
                  accent: palette.accentCyan,
                  onTap: () => context.go(RouteNames.papers),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: 'MCQs',
                  subtitle: '${activity.mcqsAttempted} Solved',
                  icon: Icons.task_alt_rounded,
                  accent: palette.success,
                  onTap: () => context.go(RouteNames.practice),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _QuickActionCard(
                  title: 'Mock Exam',
                  subtitle: 'Timed Test',
                  icon: Icons.timer_outlined,
                  accent: palette.warning,
                  onTap: () => context.push(
                    '${RouteNames.practice}/${RouteNames.mockExamSetup}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Continue Learning Section
          Text(
            'Continue Learning',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          ImtihanCard(
            onTap: () => context.push(
              '${RouteNames.learn}/chapter/${continueChapter.id}',
            ),
            child: Row(
              children: [
                ImtihanIconBadge(
                  icon: SubjectVisuals.iconFor(continueSubject.visualKind),
                  accentColor: SubjectVisuals.accentFor(
                    continueSubject.visualKind,
                    palette,
                  ),
                  size: 46,
                  iconSize: 22,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        continueSubject.title,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Chapter ${continueChapter.number}: ${continueChapter.title}',
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: palette.primaryButtonGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: palette.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Quick Utility Strip (Planner, Bookmarks, Downloads)
          Row(
            children: [
              Expanded(
                child: _CompactUtilityPill(
                  icon: Icons.calendar_today_rounded,
                  label: 'Planner',
                  onTap: () => context.push(RouteNames.studyPlanner),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _CompactUtilityPill(
                  icon: Icons.bookmark_rounded,
                  label: 'Bookmarks',
                  onTap: () => context.push(RouteNames.bookmarks),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _CompactUtilityPill(
                  icon: Icons.download_done_rounded,
                  label: 'Offline',
                  onTap: () => context.push(RouteNames.downloads),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          ImtihanIconBadge(
            icon: icon,
            size: 46,
            iconSize: 22,
            accentColor: accent,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompactUtilityPill extends StatelessWidget {
  const _CompactUtilityPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    return ImtihanCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: palette.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
