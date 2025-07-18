import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';

class ExerciseLogRepository {
  final AppDatabase _db;

  ExerciseLogRepository(this._db);

  Future<List<ExerciseLog>> getExerciseLogs() async {
    return await _db.select(_db.exerciseLogs).get();
  }

  Future<void> addExerciseLog(ExerciseLogsCompanion entry) async {
    await _db.into(_db.exerciseLogs).insert(entry);
  }
}

final exerciseLogRepositoryProvider = Provider((ref) {
  return ExerciseLogRepository(ref.read(dbProvider));
});
