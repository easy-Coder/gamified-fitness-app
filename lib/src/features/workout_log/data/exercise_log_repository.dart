import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

class ExerciseLogRepository {
  final Ref _ref;

  ExerciseLogRepository(this._ref);

  Future<List<ExercisesLog>> getExerciseLogs() async {
    final result = await _ref
        .read(dbProvider)
        .select(_ref.read(dbProvider).exerciseLogs)
        .get();

    return result
        .map((log) => ExercisesLog.fromJson(log.toJsonString()))
        .toList();
  }

  Future<void> addExerciseLog(List<ExercisesLog> log) async {
    try {
      _ref.read(loggerProvider).d("Exercise Logs: $log");
      return await _ref.read(dbProvider).batch((batch) {
        batch.insertAll(
          _ref.read(dbProvider).exerciseLogs,
          log.map((exerciseLog) => exerciseLog.toCompanion()).toList(),
        );
      });
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      _ref.read(loggerProvider).d(e);
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final exerciseLogRepoProvider = Provider((ref) {
  return ExerciseLogRepository(ref);
});
