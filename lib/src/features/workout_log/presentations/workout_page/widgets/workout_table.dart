import 'package:flutter/material.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/tables/reps_table.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/tables/timed_table.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/tables/weight_table.dart';

class WorkoutTable extends StatelessWidget {
  final ExerciseDTO exercise;
  final List<ExerciseLogsDTO> exerciseLogs;
  final void Function(int index) onSave;
  final void Function(int index) onRemove;
  final void Function(int index, ExerciseLogsDTO log) onUpdate;
  final List<ExerciseLogsDTO> savedLogs;

  const WorkoutTable({
    super.key,
    required this.exercise,
    required this.exerciseLogs,
    required this.onSave,
    required this.onRemove,
    required this.onUpdate,
    required this.savedLogs,
  });

  @override
  Widget build(BuildContext context) {
    return switch (exercise.exerciseType) {
      'reps' => RepsWorkoutTable(
        exercise: exercise,
        exerciseLogs: exerciseLogs,
        onSave: onSave,
        onRemove: onRemove,
        onUpdate: onUpdate,
        savedLogs: savedLogs,
      ),
      'strength' || 'weight' => WeightWorkoutTable(
        exercise: exercise,
        exerciseLogs: exerciseLogs,
        onSave: onSave,
        onRemove: onRemove,
        onUpdate: onUpdate,
        savedLogs: savedLogs,
      ),
      'timed' || 'cardio' => TimedWorkoutTable(
        exercise: exercise,
        exerciseLogs: exerciseLogs,
        onSave: onSave,
        onRemove: onRemove,
        onUpdate: onUpdate,
        savedLogs: savedLogs,
      ),
      _ => RepsWorkoutTable(
        exercise: exercise,
        exerciseLogs: exerciseLogs,
        onSave: onSave,
        onRemove: onRemove,
        onUpdate: onUpdate,
        savedLogs: savedLogs,
      ),
    };
  }
}
