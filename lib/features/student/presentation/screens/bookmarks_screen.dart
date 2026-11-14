import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/kpk_boards.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../data/models/curriculum_models.dart';
import '../../../../data/models/paper_models.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 22: Bookmarks.
class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final activity = ref.watch(studentActivityProvider);
    final onboarding = ref.watch(onboardingControllerProvider);
    final curriculumRepo = ref.read(curriculumRepositoryProvider);
    final paperRepo = ref.read(pastPaperRepositoryProvider);

    final List<Chapter> chapters = activity.bookmarkedChapterIds
        .map(curriculumRepo.getChapterById)
        .whereType<Chapter>()
        .toList();
    final List<PastPaper> papers = activity.bookmarkedPaperIds
        .map(
          (id) => paperRepo.getPaperById(
            paperId: id,
            preferredBoard: onboarding.selectedBoard ?? KpkBoard.peshawar,
            classLevel: onboarding.selectedClass ?? ClassLevel.class10,
          ),
        )
        .whereType<PastPaper>()
        .toList();

    final bool isEmpty = chapters.isEmpty && papers.isEmpty;

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Bookmarks',
        subtitle: 'Saved chapters & past papers',
      ),
      body: isEmpty
          ? ImtihanEmptyView(
              title: 'No Bookmarks Yet',
              subtitle:
                  'Tap the bookmark icon while reading notes or past papers to save quick shortcuts here.',
              icon: Icons.bookmark_border_rounded,
              actionLabel: 'Browse Subjects',
              onAction: () => context.go(RouteNames.learn),
            )
          : ListView(
              padding: AppSpacing.screenPadding,
              children: [
                if (chapters.isNotEmpty) ...[
                  Text('Bookmarked Chapters', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ...chapters.map(
                    (chapter) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ImtihanCard(
                        onTap: () => context.push(
                          '${RouteNames.learn}/notes/${chapter.id}',
                        ),
                        padding: AppSpacing.compactCardPadding,
                        child: Row(
                          children: [
                            ImtihanIconBadge(
                              icon: Icons.menu_book_rounded,
                              accentColor: palette.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chapter.title,
                                    style: textTheme.titleSmall,
                                  ),
                                  Text(
                                    'Chapter ${chapter.number}',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove Bookmark',
                              onPressed: () => ref
                                  .read(studentActivityProvider.notifier)
                                  .toggleChapterBookmark(chapter.id),
                              icon: Icon(
                                Icons.bookmark_remove_rounded,
                                color: palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (papers.isNotEmpty) ...[
                  Text('Bookmarked Papers', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ...papers.map(
                    (paper) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ImtihanCard(
                        onTap: () => context.push(
                          '${RouteNames.papers}/paper/${paper.id}',
                        ),
                        padding: AppSpacing.compactCardPadding,
                        child: Row(
                          children: [
                            ImtihanIconBadge(
                              icon: Icons.description_rounded,
                              accentColor: palette.accentCyan,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${paper.subjectName} (${paper.year})',
                                    style: textTheme.titleSmall,
                                  ),
                                  Text(
                                    paper.board.name,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove Bookmark',
                              onPressed: () => ref
                                  .read(studentActivityProvider.notifier)
                                  .togglePaperBookmark(paper.id),
                              icon: Icon(
                                Icons.bookmark_remove_rounded,
                                color: palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
