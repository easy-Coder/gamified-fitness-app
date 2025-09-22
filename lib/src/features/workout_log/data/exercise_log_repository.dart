import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:logger/logger.dart';

class ExerciseLogRepository {
  late final AppDatabase _db;
  late final Logger _logger;

  ExerciseLogRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

  Future<List<ExercisesLog>> getExerciseLogs(int workoutLogsId) async {
    try {
      final result = await (_db.select(
        _db.exerciseLogs,
      )..where((log) => log.workoutLogId.equals(workoutLogsId))).get();

      return result
          .map((log) => ExercisesLog.fromJson(log.toJsonString()))
          .toList();
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> addExerciseLog(List<ExercisesLog> log) async {
    try {
      _logger.d("Exercise Logs: $log");
      return await _db.batch((batch) {
        batch.insertAll(
          _db.exerciseLogs,
          log.map((exerciseLog) => exerciseLog.toCompanion()).toList(),
        );
      });
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final exerciseLogRepoProvider = Provider((ref) {
  return ExerciseLogRepository(ref);
});
