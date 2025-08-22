import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/logger.dart';

class WorkoutLogDuration extends ConsumerStatefulWidget {
  final Function(Duration) onDurationChanged;
  final bool isActive;

  final double fontSize;

  const WorkoutLogDuration({
    super.key,
    required this.onDurationChanged,
    this.fontSize = 14,
    this.isActive = false,
  });

  @override
  ConsumerState<WorkoutLogDuration> createState() => _WorkoutLogDurationState();
}

class _WorkoutLogDurationState extends ConsumerState<WorkoutLogDuration>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Duration _pausedDuration = Duration.zero;
  Duration _lastReportedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);

    if (widget.isActive) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant WorkoutLogDuration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive == false && oldWidget.isActive == true) {
      _pauseTimer();
    }
  }

  void _onTick(Duration elapsed) {
    if (_startTime != null) {
      final currentTime = DateTime.now();
      final newElapsed = _pausedDuration + currentTime.difference(_startTime!);

      setState(() {
        _elapsed = newElapsed;
      });

      // Call callback only when seconds change
      if (_elapsed.inSeconds != _lastReportedDuration.inSeconds) {
        _lastReportedDuration = _elapsed;
        widget.onDurationChanged(_elapsed);
      }
    }
  }

  void _startTimer() {
    if (!_ticker.isActive) {
      _startTime = DateTime.now();
      _ticker.start();
    }
  }

  void _pauseTimer() {
    if (_ticker.isActive) {
      _pausedDuration = _elapsed;
      _startTime = null;
      _ticker.stop();
    }
  }

  void reset() {
    _ticker.stop();
    setState(() {
      _elapsed = Duration.zero;
      _pausedDuration = Duration.zero;
      _lastReportedDuration = Duration.zero;
      _startTime = null;
    });
    widget.onDurationChanged(Duration.zero);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_elapsed),
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }
}
