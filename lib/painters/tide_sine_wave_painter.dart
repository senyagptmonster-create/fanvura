import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/fanvura_theme.dart';

class TideSineWavePainter extends CustomPainter {
  final double tideProgress; // 0.0 to 1.0 (phase within 12.4 hour cycle)
  final double currentHeightM; // e.g. 3.4 meters

  TideSineWavePainter({
    required this.tideProgress,
    required this.currentHeightM,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final midY = h * 0.5;
    final amplitude = h * 0.32;

    // Background card border
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(16),
    );
    final bgPaint = Paint()
      ..color = FanvuraTheme.edge.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgRect, bgPaint);

    // Dotted high and low tide guide lines
    final guidePaint = Paint()
      ..color = FanvuraTheme.edge
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(16, midY - amplitude), Offset(w - 16, midY - amplitude), guidePaint);
    canvas.drawLine(Offset(16, midY + amplitude), Offset(w - 16, midY + amplitude), guidePaint);

    // Sinusoidal wave path
    final wavePath = Path();
    wavePath.moveTo(16, midY + sin((16 / w) * 2 * pi) * amplitude);

    for (double x = 16; x <= w - 16; x += 3) {
      final normX = (x - 16) / (w - 32);
      final y = midY - sin(normX * 2 * pi) * amplitude;
      wavePath.lineTo(x, y);
    }

    final waveLinePaint = Paint()
      ..color = FanvuraTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(wavePath, waveLinePaint);

    // Current position on the wave
    final currentX = 16 + (w - 32) * tideProgress.clamp(0.0, 1.0);
    final currentY = midY - sin(tideProgress * 2 * pi) * amplitude;

    // Dropline
    final dropPaint = Paint()
      ..color = FanvuraTheme.accentLight
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(currentX, 12), Offset(currentX, h - 12), dropPaint);

    // Current water point
    final pointPaint = Paint()
      ..color = FanvuraTheme.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 6.0, pointPaint);

    final pulsePaint = Paint()
      ..color = FanvuraTheme.accent.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 11.0, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant TideSineWavePainter oldDelegate) {
    return oldDelegate.tideProgress != tideProgress ||
        oldDelegate.currentHeightM != currentHeightM;
  }
}
