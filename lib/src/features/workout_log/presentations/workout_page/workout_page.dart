import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/set_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/controller/workout_log_controller.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key, required this.plan});

  final int plan;

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  Duration _elapsed = Duration.zero;
  DateTime? _startTime;
  bool _isRunning = false;
  bool _isStopped = true;

  List<ExerciseLogs> exerciseLogs = [];

  @override
  Widget build(BuildContext context) {
    final workoutPlanState = ref.watch(workoutPlanProvider(widget.plan));
    final workoutLog = ref.watch(workoutLogControllerProvider(widget.plan));

    return workoutPlanState.when(
      data:
          (plan) => Scaffold(
            appBar: AppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Duration Locked In:',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                  Text(
                    formattedTime,
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              titleTextStyle: ShadTheme.of(context).textTheme.h4,
              actions: [
                PrimaryButton(
                  title: _isRunning ? 'Finish' : 'Start',
                  onTap:
                      _isRunning
                          ? () {
                            _stopTimer();
                          }
                          : _startTimer,
                  size: ShadButtonSize.sm,
                ),
              ],
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Text(plan.name, style: ShadTheme.of(context).textTheme.h3),
                  Text('Exercises', style: ShadTheme.of(context).textTheme.p),
                  Flexible(
                    child: ListView.separated(
                      itemCount: plan.workoutExercise.length,
                      separatorBuilder: (context, index) => 8.verticalSpace,
                      itemBuilder:
                          (context, index) => WorkoutCard(
                            exercise: plan.workoutExercise[index],
                            onAddSets: () {},
                            setLogs: workoutLog.exerciseLogs[index].setLogs,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      loading:
          () => Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          ),
      error: (error, _) => Scaffold(body: Column()),
    );
  }

  String get formattedTime {
    String time = '';
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    if (hours != '00') {
      time += '$hours:';
    }
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');

    time += '$minutes:$seconds';
    return time;
  }

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (_isRunning) {
        setState(() {
          if (_startTime != null) {
            _elapsed = DateTime.now().difference(_startTime!);
          }
        });
      }
    });
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        // If resuming from a pause, adjust the start time
        if (_elapsed > Duration.zero && !_isStopped) {
          _startTime = DateTime.now().subtract(_elapsed);
        } else {
          // If completely stopped, start fresh
          _startTime = DateTime.now();
          if (_isStopped) {
            _elapsed = Duration.zero;
          }
        }
        _isRunning = true;
        _isStopped = false;
      });
      _ticker.start();
    }
  }

  void _stopTimer() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
      _isStopped = true;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class WorkoutCard extends StatefulWidget {
  const WorkoutCard({
    super.key,
    required this.exercise,
    required this.onAddSets,
    required this.setLogs,
  });
  final WorkoutExercise exercise;
  final VoidCallback onAddSets;
  final List<SetLogs> setLogs;
  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  final List<String> headings = ['SET', 'WEIGHT', 'REPS'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/${widget.exercise.exercise.images[0]}',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.exercise.exercise.name,
                  style: ShadTheme.of(context).textTheme.h4,
                ),
              ),
              // add view in
              IconButton(
                icon: Icon(LucideIcons.eye),
                iconSize: 24,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(LucideIcons.timer, size: 24, color: Colors.blue),
              SizedBox(width: 4),
              Text(
                '2mins 00s',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(color: Colors.blue),
                semanticsLabel: 'Rest Timer 2mins 00s',
              ),
            ],
          ),
          SizedBox(height: 16),

          // Add DataTable for sets
          DataTable(
            columnSpacing: 24,
            dataRowMinHeight: 56,
            columns: [
              DataColumn(label: Text('SET')),
              DataColumn(label: Text('WEIGHT')),
              DataColumn(label: Text('REPS')),
            ],
            rows: List.generate(
              widget.setLogs.length,
              (index) => DataRow(
                cells: [
                  DataCell(Text('${widget.setLogs[index].setNumber}')),
                  DataCell(Text(widget.setLogs[index].weight.toString())),
                  DataCell(Text(widget.setLogs[index].reps.toString())),
                ],
              ),
            ),
          ),

          16.verticalSpace,
          // Add Set button
          ShadButton.ghost(
            onPressed: widget.onAddSets,
            icon: Icon(Icons.add),
            child: Text('Add Set'),
          ),
        ],
      ),
    );
  }
}
