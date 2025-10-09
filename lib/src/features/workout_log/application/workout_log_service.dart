import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogService {
  final Ref _ref;
  WorkoutLogService(this._ref);

  Future<WorkoutLog> getTodayWorkoutLog(DateTime date) async {
    try {
      final workoutLog = await _ref
          .read(workoutLogRepoProvider)
          .getWorkoutLogByDate(date);
      print(workoutLog);
      if (workoutLog == null) throw Failure(message: "No log exist for today");
      // print(workoutLog == null);
      final exerciseLogs = await _ref
          .read(exerciseLogRepoProvider)
          .getExerciseLogs(workoutLog.id!);
      return workoutLog.copyWith(exerciseLogs: exerciseLogs);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addWorkoutLog(WorkoutLog log) async {
    try {
      final logs = log.exerciseLogs;
      final workoutLogId = await _ref
          .read(workoutLogRepoProvider)
          .addWorkoutLog(log);
      _ref.read(loggerProvider).d("Logs: $log");
      await _ref
          .read(exerciseLogRepoProvider)
          .addExerciseLog(
            logs
                .map((log) => log.copyWith(workoutLogId: workoutLogId))
                .toList(),
          );
    } on Failure catch (_) {
      rethrow;
    }
  }
}

final workoutLogServiceProvider = Provider((ref) {
  return WorkoutLogService(ref);
});

final todayWorkoutLog = FutureProvider((ref) {
  final today = DateTime.now();
  return ref.read(workoutLogServiceProvider).getTodayWorkoutLog(today);
});
