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
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/repositories/app_repositories.dart';

/// Screen 9: Chapter Overview.
class ChapterOverviewScreen extends ConsumerWidget {
  const ChapterOverviewScreen({
    super.key,
    required this.chapterId,
  });

  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final repo = ref.read(curriculumRepositoryProvider);
    final chapter = repo.getChapterById(chapterId);

    if (chapter == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Chapter Overview'),
        body: ImtihanErrorView(message: 'Chapter not found.'),
      );
    }

    final subject = repo.getSubjectById(chapter.subjectId);
    final activity = ref.watch(studentActivityProvider);
    final bool isBookmarked = activity.bookmarkedChapterIds.contains(chapter.id);

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: chapter.title,
        subtitle: 'Chapter ${chapter.number} • ${subject?.title ?? ''}',
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Chapter',
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            onPressed: () => ref
                .read(studentActivityProvider.notifier)
                .toggleChapterBookmark(chapter.id),
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isBookmarked ? palette.primary : palette.textPrimary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SubjectDiagramCard(
                    visualKind:
                        subject?.visualKind ?? SubjectVisualKind.physics,
                    title: chapter.diagramTitle,
                    caption: chapter.diagramCaption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _OverviewActionTile(
                    title: 'Key Concepts',
                    subtitle: '${chapter.keyConcepts.length} core concepts',
                    icon: Icons.check_circle_rounded,
                    onTap: () => _openNotes(context, ref, chapter.subjectId, chapter.id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OverviewActionTile(
                    title: 'Important Formulas',
                    subtitle:
                        '${chapter.quickRevision.keyFormulas.length} board formulas',
                    icon: Icons.functions_rounded,
                    onTap: () => context.push(
                      '${RouteNames.learn}/revision/${chapter.id}',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OverviewActionTile(
                    title: 'Solved Examples',
                    subtitle:
                        '${chapter.solvedExamples.length} step-by-step numericals',
                    icon: Icons.edit_note_rounded,
                    onTap: () => _openNotes(context, ref, chapter.subjectId, chapter.id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OverviewActionTile(
                    title: 'Quick Revision',
                    subtitle: 'Last-minute exam summary & tips',
                    icon: Icons.flash_on_rounded,
                    onTap: () => context.push(
                      '${RouteNames.learn}/revision/${chapter.id}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ImtihanPrimaryButton(
              label: 'Start Learning',
              onPressed: () =>
                  _openNotes(context, ref, chapter.subjectId, chapter.id),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNotes(
    BuildContext context,
    WidgetRef ref,
    String subjectId,
    String chapterId,
  ) async {
    await ref.read(studentActivityProvider.notifier).recordChapterOpened(
          subjectId: subjectId,
          chapterId: chapterId,
        );
    if (context.mounted) {
      await context.push('${RouteNames.learn}/notes/$chapterId');
    }
  }
}

class _OverviewActionTile extends StatelessWidget {
  const _OverviewActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
            size: 38,
            iconSize: 20,
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
