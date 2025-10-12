import 'package:flutter_riverpod/legacy.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

class WorkoutLogNotifier extends StateNotifier<WorkoutLogsDTO> {
  WorkoutLogNotifier(int planId)
    : super(
        WorkoutLogsDTO(
          planId: planId,
          duration: Duration.zero,
          exerciseLogs: [],
        ),
      );

  void updateDuration(Duration duration) {
    state = state.copyWith(duration: duration);
  }

  void addExerciseLog(ExerciseLogsDTO log) {
    state = state.copyWith(exerciseLogs: [...state.exerciseLogs, log]);
  }

  void addAllLogs(List<ExerciseLogsDTO> logs) {
    state = state.copyWith(exerciseLogs: [...state.exerciseLogs, ...logs]);
  }

  void markDone() {
    // you can add logic to finalize the log
  }
}

final workoutLogProvider =
    StateNotifierProvider.family<WorkoutLogNotifier, WorkoutLogsDTO, int>(
      (ref, planId) => WorkoutLogNotifier(planId),
    );
