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
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 12: Past Papers Dashboard (Papers Tab root).
class PastPapersDashboardScreen extends ConsumerWidget {
  const PastPapersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final repo = ref.read(pastPaperRepositoryProvider);

    final papers = repo.getPastPapers(
      preferredBoard: onboarding.selectedBoard ?? KpkBoard.peshawar,
      classLevel: onboarding.selectedClass ?? ClassLevel.class10,
      group: onboarding.selectedGroup ?? AcademicGroup.science,
    );

    final bottomPadding = 104 + MediaQuery.viewPaddingOf(context).bottom;

    return Column(
      children: [
        ImtihanAppBar(
          title: 'Past Papers',
          subtitle:
              '${onboarding.selectedBoard?.name ?? 'BISE Peshawar'} • ${onboarding.selectedClass?.label ?? 'Class 10'}',
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
              // KPK Board Papers Header Banner
              ImtihanCard(
                padding: AppSpacing.compactCardPadding,
                child: Row(
                  children: [
                    ImtihanIconBadge(
                      icon: Icons.school_rounded,
                      accentColor: palette.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KPK Board Papers',
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            'Solved papers & official marking schemes',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Quick Access: Paper Library & Examination Trends
              Row(
                children: [
                  Expanded(
                    child: ImtihanCard(
                      onTap: () => context.push(
                        '${RouteNames.papers}/${RouteNames.paperLibrary}',
                      ),
                      padding: AppSpacing.compactCardPadding,
                      child: Row(
                        children: [
                          ImtihanIconBadge(
                            icon: Icons.library_books_rounded,
                            size: 38,
                            iconSize: 19,
                            accentColor: palette.accentCyan,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Paper Library',
                              style: textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ImtihanCard(
                      onTap: () => context.push(
                        '${RouteNames.papers}/${RouteNames.paperAnalysis}',
                      ),
                      padding: AppSpacing.compactCardPadding,
                      child: Row(
                        children: [
                          ImtihanIconBadge(
                            icon: Icons.analytics_rounded,
                            size: 38,
                            iconSize: 19,
                            accentColor: palette.success,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Exam Trends',
                              style: textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Recent Solved Papers', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),

              ...papers.map((paper) {
                final bool isDownloaded =
                    activity.downloadedPaperIds.contains(paper.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ImtihanCard(
                    onTap: () => context.push(
                      '${RouteNames.papers}/paper/${paper.id}',
                    ),
                    padding: AppSpacing.compactCardPadding,
                    child: Row(
                      children: [
                        ImtihanIconBadge(
                          icon: Icons.description_rounded,
                          accentColor: palette.primary,
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${paper.year} Solved Paper',
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${paper.subjectName} • ${paper.board.name}',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (isDownloaded)
                          Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.xs),
                            child: Icon(
                              Icons.download_done_rounded,
                              size: 18,
                              color: palette.success,
                            ),
                          ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: palette.textMuted,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
