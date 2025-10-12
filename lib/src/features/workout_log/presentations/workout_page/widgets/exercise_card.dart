import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/workout_table.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ExerciseCard extends ConsumerStatefulWidget {
  const ExerciseCard({
    super.key,
    required this.workoutExcercise,
    this.workoutLogs = const [],
    required this.onSave,
    required this.isDone,
  });

  final WorkoutExerciseDTO workoutExcercise;
  final bool isDone;
  final void Function(List<ExerciseLogsDTO> logs) onSave;

  final List<ExerciseLogsDTO> workoutLogs;

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard> {
  List<ExerciseLogsDTO> logs = [];

  @override
  void initState() {
    super.initState();
    logs = List.generate(
      1,
      (index) => ExerciseLogsDTO(
        sets: index + 1,
        exerciseId: widget.workoutExcercise.exercise.exerciseId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.workoutExcercise.exercise.gifUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: widget.workoutExcercise.exercise.name.toTitleCase(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.pushNamed(
                        AppRouter.exerciseDetail.name,
                        pathParameters: {
                          "id": widget.workoutExcercise.exercise.exerciseId,
                        },
                      ),
                  ),

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              24.horizontalSpace,
              ShadButton(
                // size: ShadButtonSize.sm,
                padding: EdgeInsets.zero,
                foregroundColor: Colors.grey,
                backgroundColor: Colors.transparent,
                pressedBackgroundColor: Colors.transparent,
                child: Icon(Icons.more_vert_rounded, size: 24.w),
              ),
            ],
          ),
          12.verticalSpace,
          WorkoutTable(
            exercise: widget.workoutExcercise.exercise,
            savedLogs: widget.workoutLogs,
            exerciseLogs: logs,
            onSave: (index) {
              final log = logs[index];
              if (widget.workoutLogs.contains(log)) return;

              final hasDuration =
                  log.duration != null && log.duration! > Duration.zero;
              final hasReps = log.reps != null && log.reps! > 0;
              final hasWeight = log.weight != null && log.weight! > 0;

              if (!hasDuration && !hasReps && !hasWeight) {
                return;
              }

              widget.onSave([...widget.workoutLogs, log]);
            },
            onUpdate: (index, log) {
              setState(() {
                logs[index] = log;
              });
            },
            onRemove: (index) {
              // // get log from the workoutlog
              // // check if the set exits then remove
              logs.removeAt(index);
              for (int i = 0; i < logs.length; i++) {
                final log = logs[i];
                if (log.sets == i + 1) continue;
                logs[i] = log.copyWith(sets: i + 1);
              }
              setState(() {});
              if (widget.workoutLogs.isNotEmpty) {
                widget.onSave(logs);
              }
            },
          ),
          12.verticalSpace,
          ShadButton(
            leading: Icon(LucideIcons.plus),
            size: ShadButtonSize.lg,
            width: double.infinity,
            backgroundColor: Colors.grey,
            decoration: ShadDecoration(
              border: ShadBorder.fromBorderSide(
                ShadBorderSide.none,
                radius: BorderRadius.circular(24.r),
              ),
            ),
            onPressed: () => setState(() {
              logs.add(
                ExerciseLogsDTO(
                  sets: logs.length + 1,
                  exerciseId: widget.workoutExcercise.exercise.exerciseId,
                ),
              );
            }),
            child: Text("Add Log"),
          ),
        ],
      ),
    );
  }
}
