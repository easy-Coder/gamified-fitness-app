import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

class ExerciseLogService {
  final Ref _ref;

  ExerciseLogService(this._ref);

  Future<List<ExercisesLog>> getExerciseLogs() async {
    return await _ref.read(exerciseLogRepoProvider).getExerciseLogs();
  }
}

final exerciseLogServiceProvider = Provider((ref) {
  return ExerciseLogService(ref);
});

final exerciseLogsProvider = FutureProvider<List<ExercisesLog>>((ref) {
  return ref.read(exerciseLogServiceProvider).getExerciseLogs();
});
