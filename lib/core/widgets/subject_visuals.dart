import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/curriculum_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Maps each [SubjectVisualKind] to a crisp Material Rounded icon and semantic accent.
abstract final class SubjectVisuals {
  static IconData iconFor(SubjectVisualKind kind) => switch (kind) {
        SubjectVisualKind.physics => Icons.bolt_rounded,
        SubjectVisualKind.chemistry => Icons.science_rounded,
        SubjectVisualKind.mathematics => Icons.calculate_rounded,
        SubjectVisualKind.biology => Icons.eco_rounded,
        SubjectVisualKind.computerScience => Icons.memory_rounded,
        SubjectVisualKind.english => Icons.menu_book_rounded,
        SubjectVisualKind.humanities => Icons.public_rounded,
        SubjectVisualKind.commerce => Icons.account_balance_wallet_rounded,
      };

  static Color accentFor(SubjectVisualKind kind, AppColorPalette palette) =>
      switch (kind) {
        SubjectVisualKind.physics => palette.primary,
        SubjectVisualKind.chemistry => palette.accentCyan,
        SubjectVisualKind.mathematics => palette.primaryLight,
        SubjectVisualKind.biology => palette.success,
        SubjectVisualKind.computerScience => palette.primary,
        SubjectVisualKind.english => palette.warning,
        SubjectVisualKind.humanities => palette.warning,
        SubjectVisualKind.commerce => palette.accentCyan,
      };
}

/// Lightweight CustomPainter educational illustration used in Chapter Overview
/// and Detailed Notes Reader (zero image asset bloat).
class SubjectDiagramCard extends StatelessWidget {
  const SubjectDiagramCard({
    super.key,
    required this.visualKind,
    required this.title,
    required this.caption,
    this.height = 176,
  });

  final SubjectVisualKind visualKind;
  final String title;
  final String caption;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.brightness == Brightness.light
              ? [const Color(0xFFE8F1FE), const Color(0xFFD2E4FC)]
              : [const Color(0xFF152C52), const Color(0xFF0E1F3D)],
        ),
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(color: palette.borderSubtle),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height - 56,
            width: double.infinity,
            child: CustomPaint(
              painter: _SubjectDiagramPainter(
                kind: visualKind,
                primary: palette.primary,
                accent: palette.accentCyan,
                danger: palette.danger,
                surface: palette.surfacePrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SubjectDiagramPainter extends CustomPainter {
  const _SubjectDiagramPainter({
    required this.kind,
    required this.primary,
    required this.accent,
    required this.danger,
    required this.surface,
  });

  final SubjectVisualKind kind;
  final Color primary;
  final Color accent;
  final Color danger;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    if (kind == SubjectVisualKind.physics) {
      // Magnetic flux lines + U-shaped / bar magnet illustration
      final Paint fluxPaint = Paint()
        ..color = primary.withValues(alpha: 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;

      for (int i = 1; i <= 3; i++) {
        final double rx = 46.0 + (i * 22);
        final double ry = 22.0 + (i * 12);
        canvas.drawOval(
          Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
          fluxPaint,
        );
      }

      // Magnet core (Red North / Blue South)
      final RRect north = RRect.fromRectAndCorners(
        Rect.fromLTWH(center.dx - 44, center.dy - 14, 44, 28),
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(8),
      );
      final RRect south = RRect.fromRectAndCorners(
        Rect.fromLTWH(center.dx, center.dy - 14, 44, 28),
        topRight: const Radius.circular(8),
        bottomRight: const Radius.circular(8),
      );
      canvas.drawRRect(north, Paint()..color = danger);
      canvas.drawRRect(south, Paint()..color = primary);
      return;
    }

    if (kind == SubjectVisualKind.mathematics ||
        kind == SubjectVisualKind.commerce) {
      // Coordinate axes + smooth curve
      final Paint axisPaint = Paint()
        ..color = primary.withValues(alpha: 0.45)
        ..strokeWidth = 1.6;
      canvas.drawLine(
        Offset(24, center.dy + 20),
        Offset(size.width - 24, center.dy + 20),
        axisPaint,
      );
      canvas.drawLine(
        Offset(center.dx, 10),
        Offset(center.dx, size.height - 8),
        axisPaint,
      );

      final Path curve = Path();
      for (double x = -1.0; x <= 1.0; x += 0.05) {
        final double px = center.dx + x * (size.width * 0.34);
        final double py = (center.dy + 20) - (1 - x * x) * (size.height * 0.52);
        if (x == -1.0) {
          curve.moveTo(px, py);
        } else {
          curve.lineTo(px, py);
        }
      }
      canvas.drawPath(
        curve,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      return;
    }

    // Atomic / cellular orbital rings for Chemistry, Biology, CS, Humanities
    final Paint ringPaint = Paint()
      ..color = accent.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final angle in [0.0, math.pi / 3, -math.pi / 3]) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 112, height: 42),
        ringPaint,
      );
      canvas.restore();
    }

    canvas.drawCircle(center, 14, Paint()..color = primary);
    canvas.drawCircle(center, 6, Paint()..color = surface);
  }

  @override
  bool shouldRepaint(covariant _SubjectDiagramPainter oldDelegate) {
    return oldDelegate.kind != kind ||
        oldDelegate.primary != primary ||
        oldDelegate.accent != accent;
  }
}
