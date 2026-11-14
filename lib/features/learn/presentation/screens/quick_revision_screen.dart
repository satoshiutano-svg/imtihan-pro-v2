import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';
import '../../../../data/repositories/app_repositories.dart';

/// Screen 11: Quick Revision Notes.
class QuickRevisionScreen extends ConsumerWidget {
  const QuickRevisionScreen({
    super.key,
    required this.chapterId,
  });

  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final chapter =
        ref.read(curriculumRepositoryProvider).getChapterById(chapterId);

    if (chapter == null) {
      return const ImtihanScaffold(
        appBar: ImtihanAppBar(title: 'Quick Revision'),
        body: ImtihanErrorView(message: 'Revision notes not found.'),
      );
    }

    final revision = chapter.quickRevision;

    return ImtihanScaffold(
      appBar: ImtihanAppBar(
        title: 'Quick Revision',
        subtitle: chapter.title,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _RevisionSectionCard(
            title: 'Key Formulas',
            icon: Icons.functions_rounded,
            accent: palette.primary,
            items: revision.keyFormulas,
            initiallyExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _RevisionSectionCard(
            title: 'Important Points',
            icon: Icons.lightbulb_outline_rounded,
            accent: palette.accentCyan,
            items: revision.importantPoints,
          ),
          const SizedBox(height: AppSpacing.md),
          _RevisionSectionCard(
            title: 'Exam Tips',
            icon: Icons.workspace_premium_rounded,
            accent: palette.success,
            items: revision.examTips,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Signature Remember Highlight Callout Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              gradient: palette.primaryButtonGradient,
              borderRadius: AppSpacing.cardBorderRadius,
              boxShadow: AppShadows.primaryButton(palette),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    size: 30,
                    color: palette.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Remember:',
                  style: textTheme.headlineMedium?.copyWith(
                    color: palette.textOnPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  revision.rememberHighlight,
                  style: textTheme.bodyLarge?.copyWith(
                    color: palette.textOnPrimary.withValues(alpha: 0.92),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RevisionSectionCard extends StatelessWidget {
  const _RevisionSectionCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.items,
    this.initiallyExpanded = false,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final List<String> items;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          leading: ImtihanIconBadge(
            icon: icon,
            size: 38,
            iconSize: 20,
            accentColor: accent,
          ),
          title: Text(title, style: textTheme.titleMedium),
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right_rounded, size: 20, color: accent),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(item, style: textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
