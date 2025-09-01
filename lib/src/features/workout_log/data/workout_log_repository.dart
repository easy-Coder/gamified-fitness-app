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
  final Ref _ref;
  late final Logger logger;
  late final AppDatabase _db;

  WorkoutLogRepository(this._ref) {
    logger = _ref.read(loggerProvider);
    _db = _ref.read(dbProvider);
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
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      logger.e(e.explanation);
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
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

      logger.d(result?.toJsonString());

      return result == null ? null : WorkoutLog.fromJson(result.toJsonString());
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      logger.e(e.explanation);
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Stream<List<WorkoutLog>> getWorkoutLogs(WorkoutLogFilter filter) {
    try {
      logger.d("Streaming workout logs");
      final (lower, higher) = filter.getDateRange();

      logger.d("Lower: $lower, Higher: $higher");

      final result =
          (_db.select(
                _db.workoutLogs,
              )..where((log) => log.workoutDate.isBetweenValues(lower, higher)))
              .watch();

      result.length.then((value) {
        logger.d("Length: $value");
      });

      return result.map(
        (logs) => logs.map((log) {
          logger.d(log);
          return WorkoutLog.fromJson(log.toJsonString());
        }).toList(),
      );
    } on DriftRemoteException catch (error) {
      logger.e(error.remoteCause);
      throw Failure(message: error.remoteCause.toString());
    } catch (error) {
      logger.e(error.toString());
      throw Failure(message: 'Something went wrong. Please try again');
    }
  }

  Future<int> addWorkoutLog(WorkoutLog log) async {
    try {
      return await (_ref
          .read(dbProvider)
          .into(_db.workoutLogs)
          .insert(log.toCompanion()));
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      _ref.read(loggerProvider).e('Exception type: ${e.runtimeType}');
      _ref.read(loggerProvider).e('Exception: $e');
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      _ref.read(loggerProvider).e('Exception type: ${e.runtimeType}');
      _ref.read(loggerProvider).e('Exception: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutLogRepoProvider = Provider((ref) {
  return WorkoutLogRepository(ref);
});
