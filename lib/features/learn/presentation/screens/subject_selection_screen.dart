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
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../core/widgets/subject_visuals.dart';
import '../../../../data/repositories/app_repositories.dart';
import '../../../onboarding/state/onboarding_controller.dart';

/// Screen 7: Subject Selection (Learn Tab root).
class SubjectSelectionScreen extends ConsumerStatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  ConsumerState<SubjectSelectionScreen> createState() =>
      _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState
    extends ConsumerState<SubjectSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);
    final activity = ref.watch(studentActivityProvider);
    final repo = ref.read(curriculumRepositoryProvider);

    final AcademicGroup group =
        onboarding.selectedGroup ?? AcademicGroup.science;
    final allSubjects = repo.getSubjectsForGroup(group);

    final filtered = allSubjects.where((s) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q);
    }).toList();

    final bottomPadding = 104 + MediaQuery.viewPaddingOf(context).bottom;

    return Column(
      children: [
        ImtihanAppBar(
          title: 'Select Subject',
          subtitle: '${group.label} Group • ${onboarding.selectedClass?.label ?? 'Class 10'}',
          showBackButton: false,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search subjects...',
              prefixIcon: Icon(Icons.search_rounded, color: palette.textMuted),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: Icon(Icons.close_rounded, color: palette.textMuted),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? ImtihanEmptyView(
                  title: 'No matching subjects',
                  subtitle: 'Try searching another subject name.',
                  icon: Icons.search_off_rounded,
                  actionLabel: 'Clear Search',
                  onAction: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xs,
                    AppSpacing.xl,
                    bottomPadding,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final subject = filtered[index];
                    final completedInSubject = subject.chapters
                        .where(
                          (c) => activity.completedChapterIds.contains(c.id),
                        )
                        .length;
                    final accent =
                        SubjectVisuals.accentFor(subject.visualKind, palette);

                    return ImtihanCard(
                      onTap: () => context.push(
                        '${RouteNames.learn}/chapters/${subject.id}',
                      ),
                      padding: AppSpacing.compactCardPadding,
                      child: Row(
                        children: [
                          ImtihanIconBadge(
                            icon: SubjectVisuals.iconFor(subject.visualKind),
                            size: 48,
                            iconSize: 24,
                            accentColor: accent,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.title,
                                  style: textTheme.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${subject.chapters.length} Chapters • $completedInSubject Completed',
                                  style: textTheme.bodySmall,
                                ),
                              ],
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
        ),
      ],
    );
  }
}
