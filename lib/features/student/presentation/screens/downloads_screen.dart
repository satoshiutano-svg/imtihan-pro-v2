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

/// Screen 23: Downloads (Offline Content).
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final activity = ref.watch(studentActivityProvider);
    final onboarding = ref.watch(onboardingControllerProvider);
    final curriculumRepo = ref.read(curriculumRepositoryProvider);
    final paperRepo = ref.read(pastPaperRepositoryProvider);

    final List<Chapter> chapters = activity.downloadedChapterIds
        .map(curriculumRepo.getChapterById)
        .whereType<Chapter>()
        .toList();
    final List<PastPaper> papers = activity.downloadedPaperIds
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
        title: 'Downloads',
        subtitle: 'Available offline without internet',
      ),
      body: isEmpty
          ? ImtihanEmptyView(
              title: 'No Offline Downloads',
              subtitle:
                  'Download chapters or past papers to study anywhere even without mobile data.',
              icon: Icons.download_for_offline_outlined,
              actionLabel: 'Browse Past Papers',
              onAction: () => context.go(RouteNames.papers),
            )
          : ListView(
              padding: AppSpacing.screenPadding,
              children: [
                if (chapters.isNotEmpty) ...[
                  Text('Offline Chapters', style: textTheme.titleMedium),
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
                              icon: Icons.offline_pin_rounded,
                              accentColor: palette.success,
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
                                    'Chapter ${chapter.number} • Saved offline',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete Download',
                              onPressed: () => ref
                                  .read(studentActivityProvider.notifier)
                                  .toggleChapterDownload(chapter.id),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: palette.danger,
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
                  Text('Offline Past Papers', style: textTheme.titleMedium),
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
                              icon: Icons.offline_pin_rounded,
                              accentColor: palette.success,
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
                                    '${paper.board.name} • ${paper.fileSizeLabel}',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete Download',
                              onPressed: () => ref
                                  .read(studentActivityProvider.notifier)
                                  .togglePaperDownload(paper.id),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: palette.danger,
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
