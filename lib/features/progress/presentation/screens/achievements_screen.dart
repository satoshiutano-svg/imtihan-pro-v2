import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../data/models/student_models.dart';

/// Screen 25: Achievements computed dynamically from real student activity.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final activity = ref.watch(studentActivityProvider);

    final int chaptersDone = activity.completedChapterIds.length;
    final int mcqsDone = activity.mcqsAttempted;
    final int examsDone = activity.examHistory.length;
    final int bestExam = activity.examHistory.isEmpty
        ? 0
        : activity.examHistory
            .map((e) => e.percentage)
            .reduce((a, b) => a > b ? a : b);
    final int downloadsCount =
        activity.downloadedChapterIds.length + activity.downloadedPaperIds.length;

    final List<AchievementItem> items = [
      AchievementItem(
        id: 'first_chapter',
        title: 'First Step Mastered',
        description: 'Complete your first syllabus chapter.',
        progressText: '${chaptersDone.clamp(0, 1)} / 1 chapter',
        isUnlocked: chaptersDone >= 1,
      ),
      AchievementItem(
        id: 'mcq_sprinter',
        title: 'MCQ Challenger',
        description: 'Solve at least 10 board MCQs in Practice.',
        progressText: '${mcqsDone.clamp(0, 10)} / 10 MCQs',
        isUnlocked: mcqsDone >= 10,
      ),
      AchievementItem(
        id: 'mock_finisher',
        title: 'Exam Ready',
        description: 'Complete your first timed Mock Exam.',
        progressText: '${examsDone.clamp(0, 1)} / 1 mock exam',
        isUnlocked: examsDone >= 1,
      ),
      AchievementItem(
        id: 'high_scorer',
        title: 'Board Distinction',
        description: 'Score 80% or higher in any Mock Exam.',
        progressText: 'Best score: $bestExam%',
        isUnlocked: bestExam >= 80,
      ),
      AchievementItem(
        id: 'offline_scholar',
        title: 'Offline Scholar',
        description: 'Save at least 1 chapter or past paper for offline study.',
        progressText: '${downloadsCount.clamp(0, 1)} / 1 saved item',
        isUnlocked: downloadsCount >= 1,
      ),
    ];

    final int unlockedCount = items.where((i) => i.isUnlocked).length;

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: 'Achievements',
        subtitle: '$unlockedCount of ${items.length} unlocked',
      ),
      body: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return ImtihanCard(
            padding: AppSpacing.compactCardPadding,
            child: Row(
              children: [
                ImtihanIconBadge(
                  icon: item.isUnlocked
                      ? Icons.emoji_events_rounded
                      : Icons.lock_outline_rounded,
                  size: 46,
                  iconSize: 22,
                  accentColor:
                      item.isUnlocked ? palette.warning : palette.textMuted,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(item.description, style: textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        item.progressText,
                        style: textTheme.labelSmall?.copyWith(
                          color: item.isUnlocked
                              ? palette.success
                              : palette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isUnlocked)
                  Icon(
                    Icons.verified_rounded,
                    color: palette.success,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
