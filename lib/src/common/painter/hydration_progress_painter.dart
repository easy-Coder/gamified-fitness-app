import 'package:flutter/material.dart';
import 'dart:math' as math;

class HydrationProgressPainter extends CustomPainter {
  final double progress;
  final double width;
  final double baseAngle = -math.pi / 2;
  final double circleRadius;
  final List<Color> gradientColors;
  final Color backgroundColor;

  HydrationProgressPainter({
    required this.progress,
    this.width = 8,
    this.circleRadius = 40,
    required this.gradientColors,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: circleRadius);

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
        stops: const [0.1, 0.4, 0.7, 1.0], // Adjust stops for smooth transitions
      ).createShader(rect);

    final bgPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = backgroundColor;

    // Calculate sweep angle based on progress
    const double maxSweepAngle = 2 * math.pi; // Full circle (anti-clockwise)
    final double sweepAngle = maxSweepAngle * (progress / 100);

    canvas.drawArc(rect, baseAngle, maxSweepAngle, false, bgPaint);

    canvas.drawArc(rect, baseAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(HydrationProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
