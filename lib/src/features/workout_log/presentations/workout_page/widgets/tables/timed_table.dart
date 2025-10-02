import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TimedWorkoutTable extends StatefulWidget {
  final Exercise exercise;
  final List<ExercisesLog> exerciseLogs;
  final void Function(int index) onSave;
  final void Function(int index) onRemove;
  final void Function(int index, ExercisesLog log) onUpdate;
  final List<ExercisesLog> savedLogs;

  const TimedWorkoutTable({
    super.key,
    required this.exercise,
    required this.exerciseLogs,
    required this.onSave,
    required this.onRemove,
    required this.onUpdate,
    required this.savedLogs,
  });

  @override
  State<TimedWorkoutTable> createState() => _TimedWorkoutTableState();
}

class _TimedWorkoutTableState extends State<TimedWorkoutTable>
    with SingleTickerProviderStateMixin {
  final Map<int, int> _durations = {};
  int? _activeTimerIndex;
  Ticker? _ticker;
  DateTime? _lastTickTime;

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _startTimer(int index) {
    if (_activeTimerIndex == index) {
      _pauseTimer();
      return;
    }

    _pauseTimer();

    setState(() {
      _activeTimerIndex = index;
      _durations.putIfAbsent(index, () => 0);
    });

    _lastTickTime = DateTime.now();

    _ticker = createTicker((elapsed) {
      final now = DateTime.now();
      final difference = now.difference(_lastTickTime!);

      if (difference.inSeconds >= 1) {
        _lastTickTime = now;

        if (_activeTimerIndex == index) {
          setState(() {
            _durations[index] = (_durations[index] ?? 0) + 1;
            final row = widget.exerciseLogs[index];
            final newLog = row.copyWith(
              duration: Duration(seconds: _durations[index]!),
            );
            widget.onUpdate(index, newLog);
          });
        }
      }
    });

    _ticker?.start();
  }

  void _pauseTimer() {
    _ticker?.dispose();
    _ticker = null;
    _lastTickTime = null;
    setState(() {
      _activeTimerIndex = null;
    });
  }

  void _resetTimer(int index) {
    if (_activeTimerIndex == index) {
      _pauseTimer();
    }
    setState(() {
      _durations[index] = 0;
      final row = widget.exerciseLogs[index];
      final newLog = row.copyWith(duration: Duration.zero);
      widget.onUpdate(index, newLog);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER ROW
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _headerCell("Set"),
                _headerCell("Duration"),
                Spacer(),
                _headerCell(null, Icon(LucideIcons.check, color: Colors.green)),
              ],
            ),
          ),

          /// DATA ROWS
          ...List.generate(widget.exerciseLogs.length, (index) {
            final row = widget.exerciseLogs[index];
            final isActive = _activeTimerIndex == index;
            final duration = _durations[index] ?? 0;

            return _buildRow(
              ValueKey(row.set),
              onRemove: () {
                if (_activeTimerIndex == index) {
                  _pauseTimer();
                }
                _durations.remove(index);
                widget.onRemove(index);
              },
              children: [
                _dataCell(Text("${row.set}")),
                _dataCell(
                  SetTimer(
                    setIndex: index,
                    isActive: isActive,
                    duration: duration,
                    onStart: () => _startTimer(index),
                    onReset: () => _resetTimer(index),
                  ),
                ),
                Spacer(),
                _dataCell(
                  GestureDetector(
                    onTap: () => widget.onSave(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.savedLogs.contains(row)
                            ? Colors.green
                            : Colors.grey.shade100,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.check,
                        color: widget.savedLogs.contains(row)
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(
    Key key, {
    required List<Widget> children,
    required VoidCallback onRemove,
  }) => Slidable(
    key: key,
    endActionPane: ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.3,
      children: [
        SlidableAction(
          onPressed: (context) => onRemove(),
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          label: 'Delete',
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(children: children),
    ),
  );

  Widget _headerCell([String? text, Widget? lead]) {
    assert(text != null || lead != null);
    return lead != null
        ? Flexible(child: Center(child: lead))
        : Expanded(
            child: Text(
              text!,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _dataCell(Widget child) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(child: child),
      ),
    );
  }
}

class SetTimer extends StatelessWidget {
  final int setIndex;
  final bool isActive;
  final int duration;
  final VoidCallback onStart;
  final VoidCallback onReset;

  const SetTimer({
    super.key,
    required this.setIndex,
    required this.isActive,
    required this.duration,
    required this.onStart,
    required this.onReset,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      onDoubleTap: onReset,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? LucideIcons.pause : LucideIcons.play,
              size: 14,
              color: isActive ? Colors.blue : Colors.grey.shade700,
            ),
            4.horizontalSpace,
            Text(
              _formatDuration(duration),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.blue : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
