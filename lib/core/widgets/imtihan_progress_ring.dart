import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Lightweight CustomPainter circular progress ring for dashboards and analytics.
class ImtihanProgressRing extends StatelessWidget {
  const ImtihanProgressRing({
    super.key,
    required this.progress,
    this.size = 92,
    this.strokeWidth = 10,
    this.centerLabel,
    this.showCenterPercentage = false,
  });

  /// Value between 0.0 and 1.0.
  final double progress;
  final double size;
  final double strokeWidth;
  final String? centerLabel;
  final bool showCenterPercentage;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final double clamped = progress.clamp(0.0, 1.0);
    final int percent = (clamped * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: clamped,
          trackColor: palette.surfaceElevated,
          startColor: palette.accentCyan,
          endColor: palette.primary,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: showCenterPercentage || centerLabel != null
              ? Text(
                  centerLabel ?? '$percent%',
                  style: AppTypography.tabularNumeric(
                    Theme.of(context).textTheme.titleMedium ??
                        const TextStyle(),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color startColor;
  final Color endColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final SweepGradient gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [startColor, endColor],
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
