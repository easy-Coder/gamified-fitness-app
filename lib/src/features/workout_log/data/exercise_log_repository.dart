import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class ExerciseLogRepository {
  late final Isar _db;
  late final Logger _logger;

  ExerciseLogRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

  Future<List<ExerciseLogsDTO>> getExerciseLogs(int workoutLogsId) async {
    try {
      final workoutLog = await _db.workoutLogs.get(workoutLogsId);

      if (workoutLog == null) {
        return [];
      }

      final result = workoutLog.exercises;

      return result.map((log) => ExerciseLogsDTO.fromSchema(log)).toList();
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> addExerciseLog(
    int workoutLogsId,
    List<ExerciseLogsDTO> logs,
  ) async {
    try {
      _logger.d("Exercise Logs: $logs");
      final workoutLog = await _db.workoutLogs.get(workoutLogsId);
      if (workoutLog == null) {
        throw Failure(message: "No workout log added");
      }
      workoutLog.exercises.addAll(logs.map((log) => log.toSchema()).toList());
      await _db.writeTxn(() async {
        await workoutLog.exercises.save();
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
