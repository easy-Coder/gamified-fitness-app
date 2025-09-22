import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart' hide WorkoutLog;
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:logger/logger.dart';

class WorkoutLogRepository {
  late final Logger _logger;
  late final AppDatabase _db;

  WorkoutLogRepository(Ref ref) {
    _logger = ref.read(loggerProvider);
    _db = ref.read(dbProvider);
  }

  Stream<WorkoutLog?> getWorkoutLogByDateStream(DateTime date) {
    try {
      final result =
          (_db.select(_db.workoutLogs)..where(
                (log) => log.workoutDate.date.equalsExp(currentDate.date),
              ))
              .watchSingleOrNull();

      return result.map(
        (log) => log == null ? null : WorkoutLog.fromJson(log.toJsonString()),
      );
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<WorkoutLog?> getWorkoutLogByDate(DateTime date) async {
    try {
      final result =
          await (_db.select(_db.workoutLogs)..where(
                (log) => log.workoutDate.date.equalsExp(currentDate.date),
              ))
              .getSingleOrNull();

      return result == null ? null : WorkoutLog.fromJson(result.toJsonString());
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Stream<List<WorkoutLog>> getWorkoutLogs(WorkoutLogFilter filter) {
    try {
      _logger.d("Streaming workout logs");
      final (lower, higher) = filter.getDateRange();

      _logger.d("Lower: $lower, Higher: $higher");

      final result =
          (_db.select(
                _db.workoutLogs,
              )..where((log) => log.workoutDate.isBetweenValues(lower, higher)))
              .watch();

      result.length.then((value) {
        _logger.d("Length: $value");
      });

      return result.map(
        (logs) => logs.map((log) {
          _logger.d(log);
          return WorkoutLog.fromJson(log.toJsonString());
        }).toList(),
      );
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<int> addWorkoutLog(WorkoutLog log) async {
    try {
      return await (_db.into(_db.workoutLogs).insert(log.toCompanion()));
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e('Exception type: ${e.runtimeType}');
      _logger.e('Exception: $e');
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      _logger.e('Exception type: ${e.runtimeType}');
      _logger.e('Exception: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutLogRepoProvider = Provider((ref) {
  return WorkoutLogRepository(ref);
});
