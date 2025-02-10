import 'package:flutter/widgets.dart';
import 'package:gamified/src/common/painter/fluid_painter.dart';
import 'package:gamified/src/common/painter/hydration_progress_painter.dart';

class HydrationProgress extends StatefulWidget {
  const HydrationProgress(
      {super.key, required this.progress, required this.size});

  final double progress;
  final Size size;

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
        vsync: this, duration: const Duration(milliseconds: 700));

    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: WavePainter(
        progress: widget.progress,
        waveAnimation: _waveController,
      ),
      foregroundPainter: HydrationProgressPainter(
        progress: widget.progress,
      ),
    );
  }
}
