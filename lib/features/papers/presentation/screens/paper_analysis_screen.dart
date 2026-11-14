import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_progress_ring.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../data/models/paper_models.dart';
import '../../../../data/repositories/app_repositories.dart';

/// Screen 15: Paper Analysis & Examination Trends.
class PaperAnalysisScreen extends ConsumerWidget {
  const PaperAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final trends = ref.read(pastPaperRepositoryProvider).getExaminationTrends();
    final activity = ref.watch(studentActivityProvider);

    final int overallScore = activity.examHistory.isNotEmpty
        ? activity.averageExamPercentage
        : (activity.mcqsAttempted > 0
            ? (activity.mcqAccuracy * 100).round()
            : 0);

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Analysis',
        subtitle: 'KPK Board Paper Trends & Readiness',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          ImtihanCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'High-yield chapter marks distribution (2021–2025 KPK BISE)',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 150,
                  child: CustomPaint(
                    size: const Size(double.infinity, 150),
                    painter: _TrendsBarChartPainter(
                      trends: trends,
                      barTop: palette.accentCyan,
                      barBottom: palette.primary,
                      labelColor: palette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Column(
                    children: [
                      Text(
                        activity.mcqsAttempted == 0 &&
                                activity.examHistory.isEmpty
                            ? '0%'
                            : '$overallScore%',
                        style: AppTypography.tabularNumeric(
                          textTheme.displayLarge ?? const TextStyle(),
                        ),
                      ),
                      Text(
                        activity.mcqsAttempted == 0 &&
                                activity.examHistory.isEmpty
                            ? 'Take an MCQ or Mock Exam to record your score'
                            : 'Overall Practice & Exam Score',
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImtihanProgressRing(
                        progress: overallScore / 100,
                        size: 112,
                        strokeWidth: 12,
                        showCenterPercentage: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('High-Weightage Board Chapters', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...trends.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ImtihanCard(
                padding: AppSpacing.compactCardPadding,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: palette.surfaceElevated,
                        borderRadius: AppSpacing.badgeBorderRadius,
                        border: Border.all(color: palette.borderSubtle),
                      ),
                      child: Center(
                        child: Text(
                          point.label,
                          style: textTheme.labelMedium?.copyWith(
                            color: palette.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point.chapterTitle,
                            style: textTheme.titleSmall,
                          ),
                          Text(
                            'Appeared in ${point.frequencyYears}/5 recent board papers',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${point.marksWeightage}%',
                      style: AppTypography.tabularNumeric(
                        (textTheme.titleMedium ?? const TextStyle())
                            .copyWith(color: palette.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendsBarChartPainter extends CustomPainter {
  const _TrendsBarChartPainter({
    required this.trends,
    required this.barTop,
    required this.barBottom,
    required this.labelColor,
  });

  final List<PaperTrendPoint> trends;
  final Color barTop;
  final Color barBottom;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (trends.isEmpty) return;

    final int maxMarks = trends
        .map((t) => t.marksWeightage)
        .reduce((a, b) => a > b ? a : b);

    final double slotWidth = size.width / trends.length;
    final double barWidth = (slotWidth * 0.48).clamp(16.0, 32.0);
    final double chartHeight = size.height - 26;

    for (int i = 0; i < trends.length; i++) {
      final point = trends[i];
      final double ratio = maxMarks == 0 ? 0 : point.marksWeightage / maxMarks;
      final double barHeight = (chartHeight * 0.88) * ratio;
      final double left = (i * slotWidth) + (slotWidth - barWidth) / 2;
      final double top = chartHeight - barHeight;

      final Rect rect = Rect.fromLTWH(left, top, barWidth, barHeight);
      final RRect rRect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );

      final Paint barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [barTop, barBottom],
        ).createShader(rect);

      canvas.drawRRect(rRect, barPaint);

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: point.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(left + (barWidth - tp.width) / 2, chartHeight + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendsBarChartPainter oldDelegate) {
    return oldDelegate.trends != trends ||
        oldDelegate.barTop != barTop ||
        oldDelegate.barBottom != barBottom;
  }
}
