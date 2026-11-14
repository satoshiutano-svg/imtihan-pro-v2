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
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 13: Past Paper Library with year & subject filtering.
class PastPaperLibraryScreen extends ConsumerStatefulWidget {
  const PastPaperLibraryScreen({super.key});

  @override
  ConsumerState<PastPaperLibraryScreen> createState() =>
      _PastPaperLibraryScreenState();
}

class _PastPaperLibraryScreenState
    extends ConsumerState<PastPaperLibraryScreen> {
  int? _selectedYear;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final repo = ref.read(pastPaperRepositoryProvider);

    final allPapers = repo.getPastPapers(
      preferredBoard: onboarding.selectedBoard ?? KpkBoard.peshawar,
      classLevel: onboarding.selectedClass ?? ClassLevel.class10,
      group: onboarding.selectedGroup,
    );

    final filtered = allPapers.where((paper) {
      if (_selectedYear != null && paper.year != _selectedYear) return false;
      if (activity.offlineModeEnabled &&
          !activity.downloadedPaperIds.contains(paper.id)) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return paper.subjectName.toLowerCase().contains(q) ||
            paper.board.name.toLowerCase().contains(q) ||
            paper.year.toString().contains(q);
      }
      return true;
    }).toList();

    const years = [2025, 2024, 2023, 2022];

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Paper Library',
        subtitle: 'Filter by year, subject, or board',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search Physics, Chemistry, BISE...',
                    prefixIcon:
                        Icon(Icons.search_rounded, color: palette.textMuted),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _YearFilterChip(
                        label: 'All Years',
                        selected: _selectedYear == null,
                        onTap: () => setState(() => _selectedYear = null),
                      ),
                      ...years.map(
                        (year) => Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.sm),
                          child: _YearFilterChip(
                            label: '$year',
                            selected: _selectedYear == year,
                            onTap: () => setState(() => _selectedYear = year),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? ImtihanEmptyView(
                    title: 'No matching papers',
                    subtitle: activity.offlineModeEnabled
                        ? 'Offline Mode is active. Download a paper or disable Offline Mode.'
                        : 'Try clearing your search or selecting All Years.',
                    icon: Icons.description_outlined,
                    actionLabel: 'Reset Filters',
                    onAction: () => setState(() {
                      _selectedYear = null;
                      _searchQuery = '';
                    }),
                  )
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final paper = filtered[index];
                      final isDownloaded =
                          activity.downloadedPaperIds.contains(paper.id);

                      return ImtihanCard(
                        onTap: () => context.push(
                          '${RouteNames.papers}/paper/${paper.id}',
                        ),
                        padding: AppSpacing.compactCardPadding,
                        child: Row(
                          children: [
                            ImtihanIconBadge(
                              icon: Icons.article_rounded,
                              accentColor: palette.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${paper.subjectName} (${paper.year})',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${paper.board.name} • ${paper.totalMarks} Marks • ${paper.fileSizeLabel}',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: isDownloaded
                                  ? 'Remove offline copy'
                                  : 'Save offline',
                              constraints: const BoxConstraints(
                                minWidth: AppSpacing.minTouchTarget,
                                minHeight: AppSpacing.minTouchTarget,
                              ),
                              onPressed: () => ref
                                  .read(studentActivityProvider.notifier)
                                  .togglePaperDownload(paper.id),
                              icon: Icon(
                                isDownloaded
                                    ? Icons.download_done_rounded
                                    : Icons.download_outlined,
                                color: isDownloaded
                                    ? palette.success
                                    : palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _YearFilterChip extends StatelessWidget {
  const _YearFilterChip({
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

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: palette.primary,
      backgroundColor: palette.surfacePrimary,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? palette.textOnPrimary : palette.textPrimary,
            fontWeight: FontWeight.w600,
          ),
      side: BorderSide(
        color: selected ? palette.primary : palette.borderSubtle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
    );
  }
}
