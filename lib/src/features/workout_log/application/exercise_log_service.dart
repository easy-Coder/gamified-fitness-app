import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';

class ExerciseLogService {
  final Ref _ref;

  ExerciseLogService(this._ref);

  Future<List<ExerciseLog>> getExerciseLogs() async {
    return await _ref.read(exerciseLogRepositoryProvider).getExerciseLogs();
  }

  Future<void> addExerciseLog(ExerciseLogsCompanion entry) async {
    await _ref.read(exerciseLogRepositoryProvider).addExerciseLog(entry);
  }
}

final exerciseLogServiceProvider = Provider((ref) {
  return ExerciseLogService(ref);
});

final exerciseLogsProvider = FutureProvider<List<ExerciseLog>>((ref) {
  return ref.read(exerciseLogServiceProvider).getExerciseLogs();
});
