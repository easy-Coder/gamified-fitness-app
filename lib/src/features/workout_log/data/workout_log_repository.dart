import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart' hide WorkoutLog;
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogRepository {
  final Ref _ref;

  WorkoutLogRepository(this._ref);

  Future<int> addWorkoutLog(WorkoutLog log) async {
    try {
      return await (_ref.read(dbProvider).into(_ref.read(dbProvider).workoutLogs).insert(log.toCompanion()));
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.cause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      _ref.read(loggerProvider).e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutLogRepoProvider = Provider((ref) {
  return WorkoutLogRepository(ref);
});
