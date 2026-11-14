import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/repositories/app_repositories.dart';

/// Screen 8: Chapter List.
class ChapterListScreen extends ConsumerWidget {
  const ChapterListScreen({
    super.key,
    required this.subjectId,
  });

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final subject =
        ref.read(curriculumRepositoryProvider).getSubjectById(subjectId);
    final activity = ref.watch(studentActivityProvider);

    if (subject == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Chapters'),
        body: ImtihanErrorView(message: 'Selected subject could not be found.'),
      );
    }

    final visibleChapters = activity.offlineModeEnabled
        ? subject.chapters
            .where((c) => activity.downloadedChapterIds.contains(c.id))
            .toList()
        : subject.chapters;

    final accent = SubjectVisuals.accentFor(subject.visualKind, palette);

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: subject.title,
        subtitle: '${visibleChapters.length} Chapters',
      ),
      body: visibleChapters.isEmpty
          ? ImtihanEmptyView(
              title: 'No Offline Chapters',
              subtitle:
                  'Offline Mode is active, and no chapters in ${subject.title} are saved offline yet.',
              icon: Icons.offline_bolt_outlined,
              actionLabel: 'Disable Offline Mode',
              onAction: () => ref
                  .read(studentActivityProvider.notifier)
                  .setOfflineModeEnabled(false),
            )
          : ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: visibleChapters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final chapter = visibleChapters[index];
                final bool isCompleted =
                    activity.completedChapterIds.contains(chapter.id);
                final bool isLastOpened = activity.lastChapterId == chapter.id;

                return ImtihanCard(
                  onTap: () => context.push(
                    '${RouteNames.learn}/chapter/${chapter.id}',
                  ),
                  isSelected: isLastOpened,
                  padding: AppSpacing.compactCardPadding,
                  child: Row(
                    children: [
                      ImtihanIconBadge(
                        icon: isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.menu_book_rounded,
                        accentColor: isCompleted ? palette.success : accent,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chapter ${chapter.number}',
                              style: textTheme.labelMedium?.copyWith(
                                color: isLastOpened
                                    ? palette.primary
                                    : palette.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chapter.title,
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      if (activity.bookmarkedChapterIds.contains(chapter.id))
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: Icon(
                            Icons.bookmark_rounded,
                            size: 18,
                            color: palette.primary,
                          ),
                        ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: palette.textMuted,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
