import 'package:flutter/widgets.dart';
import 'package:gamified/src/common/painter/fluid_painter.dart';
import 'package:gamified/src/common/painter/hydration_progress_painter.dart';

class HydrationProgress extends StatefulWidget {
  const HydrationProgress({
    super.key,
    required this.progress,
    required this.size,
    this.radius = 40,
    this.duration = const Duration(milliseconds: 700),
  });

  final double progress;
  final Size size;
  final double radius;
  final Duration duration;

  @override
  State<HydrationProgress> createState() => _HydrationProgressState();
}

class _HydrationProgressState extends State<HydrationProgress>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.progress.isNegative ? 0.0 : widget.progress;
    return CustomPaint(
      size: widget.size,
      painter: WavePainter(
        progress: progress,
        waveAnimation: _waveController,
        circleRadius: widget.radius,
      ),
      foregroundPainter: HydrationProgressPainter(
        progress: progress,
        circleRadius: widget.radius,
      ),
    );
  }
}
