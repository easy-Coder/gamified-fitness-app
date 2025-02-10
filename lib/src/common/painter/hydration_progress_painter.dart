import 'package:flutter/material.dart';
import 'dart:math' as math;

class HydrationProgressPainter extends CustomPainter {
  final double progress;
  final double width;
  final double baseAngle = -math.pi / 2;
  final double circleRadius;

  HydrationProgressPainter({
    required this.progress,
    this.width = 8,
    this.circleRadius = 40,
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
        colors: [
          Color(0xFF64B5F6), // Light blue
          Color(0xFF42A5F5), // Medium blue
          Color(0xFF1E88E5), // Darker blue
          Color(0xFF1976D2), // Deep blue
        ],
        stops: [0.1, 0.4, 0.7, 1.0], // Adjust stops for smooth transitions
      ).createShader(rect);

    final bgPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = Colors.grey.shade400;

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
