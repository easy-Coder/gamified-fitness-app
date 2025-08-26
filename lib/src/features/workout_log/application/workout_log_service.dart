import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogService {
  final Ref _ref;
  WorkoutLogService(this._ref);

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
