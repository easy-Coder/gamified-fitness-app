import 'package:flutter_riverpod/legacy.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLog> {
  WorkoutLogNotifier(int planId)
    : super(
        WorkoutLog(planId: planId, duration: Duration.zero, exerciseLogs: []),
      );

  void updateDuration(Duration duration) {
    state = state.copyWith(duration: duration);
  }

  void addExerciseLog(ExercisesLog log) {
    state = state.copyWith(exerciseLogs: [...state.exerciseLogs, log]);
  }

  void addAllLogs(List<ExercisesLog> logs) {
    state = state.copyWith(exerciseLogs: [...state.exerciseLogs, ...logs]);
  }

  void markDone() {
    // you can add logic to finalize the log
  }
}

final workoutLogProvider =
    StateNotifierProvider.family<WorkoutLogNotifier, WorkoutLog, int>(
      (ref, planId) => WorkoutLogNotifier(planId),
    );
