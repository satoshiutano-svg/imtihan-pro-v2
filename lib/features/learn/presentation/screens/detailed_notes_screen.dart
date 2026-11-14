import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/repositories/app_repositories.dart';

/// Screen 10: Detailed Notes Reader.
class DetailedNotesScreen extends ConsumerStatefulWidget {
  const DetailedNotesScreen({
    super.key,
    required this.chapterId,
  });

  final String chapterId;

  @override
  ConsumerState<DetailedNotesScreen> createState() =>
      _DetailedNotesScreenState();
}

class _DetailedNotesScreenState extends ConsumerState<DetailedNotesScreen> {
  bool _showSearch = false;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final repo = ref.read(curriculumRepositoryProvider);
    final chapter = repo.getChapterById(widget.chapterId);

    if (chapter == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Notes'),
        body: ImtihanErrorView(message: 'Notes for this chapter were not found.'),
      );
    }

    final subject = repo.getSubjectById(chapter.subjectId);
    final activity = ref.watch(studentActivityProvider);
    final bool isCompleted = activity.completedChapterIds.contains(chapter.id);
    final bool isBookmarked =
        activity.bookmarkedChapterIds.contains(chapter.id);
    final bool isDownloaded =
        activity.downloadedChapterIds.contains(chapter.id);

    final filteredPoints = chapter.keyPoints
        .where(
          (p) =>
              _searchTerm.isEmpty ||
              p.toLowerCase().contains(_searchTerm.toLowerCase()),
        )
        .toList();

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: 'Notes',
        subtitle: '${subject?.title ?? ''} • Chapter ${chapter.number}',
        actions: [
          IconButton(
            tooltip: 'Search notes',
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            onPressed: () => setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) _searchTerm = '';
            }),
            icon: Icon(
              _showSearch ? Icons.close_rounded : Icons.search_rounded,
              color: palette.textPrimary,
            ),
          ),
          IconButton(
            tooltip: isBookmarked ? 'Bookmarked' : 'Bookmark',
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
          IconButton(
            tooltip: isDownloaded ? 'Saved Offline' : 'Save Offline',
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            onPressed: () {
              unawaited(
                ref
                    .read(studentActivityProvider.notifier)
                    .toggleChapterDownload(chapter.id),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isDownloaded
                        ? 'Removed from offline downloads'
                        : 'Saved "${chapter.title}" for offline reading',
                  ),
                ),
              );
            },
            icon: Icon(
              isDownloaded
                  ? Icons.download_done_rounded
                  : Icons.download_outlined,
              color: isDownloaded ? palette.success : palette.textPrimary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          if (_showSearch) ...[
            TextField(
              autofocus: true,
              onChanged: (val) => setState(() => _searchTerm = val),
              decoration: const InputDecoration(
                hintText: 'Filter key points in this chapter...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          ImtihanCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: textTheme.displayMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  chapter.summary,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SubjectDiagramCard(
                  visualKind:
                      subject?.visualKind ?? SubjectVisualKind.physics,
                  title: chapter.diagramTitle,
                  caption: chapter.diagramCaption,
                  height: 164,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Key Concepts',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...chapter.keyConcepts.map(
                  (concept) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.circle,
                            size: 6,
                            color: palette.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(concept, style: textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Key Points:',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...filteredPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: palette.success,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(point, style: textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Solved Examples Section
          ...chapter.solvedExamples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: ImtihanCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(example.title, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(example.problem, style: textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: palette.surfaceElevated,
                        borderRadius: AppSpacing.badgeBorderRadius,
                        border: Border.all(color: palette.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Formula: ${example.formula}',
                            style: textTheme.titleSmall?.copyWith(
                              color: palette.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ...example.solutionSteps.map(
                            (step) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(step, style: textTheme.bodyMedium),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Answer: ${example.answer}',
                            style: textTheme.titleSmall?.copyWith(
                              color: palette.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ImtihanPrimaryButton(
            label: isCompleted ? 'Chapter Completed' : 'Mark Chapter Complete',
            icon: isCompleted
                ? Icons.check_circle_rounded
                : Icons.task_alt_rounded,
            onPressed: () => ref
                .read(studentActivityProvider.notifier)
                .toggleChapterCompleted(chapter.id),
          ),
          const SizedBox(height: AppSpacing.md),
          ImtihanSecondaryButton(
            label: 'Quick Revision Notes',
            icon: Icons.flash_on_rounded,
            onPressed: () => context.push(
              '${RouteNames.learn}/revision/${chapter.id}',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
