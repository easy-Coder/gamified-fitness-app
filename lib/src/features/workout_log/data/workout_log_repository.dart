import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class WorkoutLogRepository {
  late final Logger _logger;
  late final Isar _db;

  WorkoutLogRepository(Ref ref) {
    _logger = ref.read(loggerProvider);
    _db = ref.read(dbProvider);
  }

  Stream<WorkoutLogsDTO?> getWorkoutLogByDateStream(DateTime date) {
    try {
      final result = _db.workoutLogs
          .where()
          .filter()
          .workoutDateEqualTo(date.date)
          .limit(1)
          .watch(fireImmediately: true);

      return result.map(
        (log) => log.isEmpty ? null : WorkoutLogsDTO.fromSchema(log[0]),
      );
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<WorkoutLogsDTO?> getWorkoutLogByDate(DateTime date) async {
    try {
      final result = await _db.workoutLogs
          .where()
          .filter()
          .workoutDateEqualTo(date.date)
          .findFirst();

      return result == null ? null : WorkoutLogsDTO.fromSchema(result);
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<WorkoutLogsDTO>> getWorkoutLogsByDate(DateTime date) async {
    try {
      final results = await _db.workoutLogs
          .where()
          .filter()
          .workoutDateEqualTo(date.date)
          .findAll();

      return results.map((log) => WorkoutLogsDTO.fromSchema(log)).toList();
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'Failed to fetch workout logs for date.');
    }
  }

  Stream<List<WorkoutLogsDTO>> getWorkoutLogs(WorkoutLogFilter filter) {
    try {
      _logger.d("Streaming workout logs");
      final (lower, higher) = filter.getDateRange();

      _logger.d("Lower: $lower, Higher: $higher");

      final result = _db.workoutLogs
          .where()
          .filter()
          .workoutDateBetween(lower, higher)
          .watch(fireImmediately: true)
          .asBroadcastStream();

      result.length.then((value) {
        _logger.d("Length: $value");
      });

      return result.map(
        (logs) => logs.map((log) {
          _logger.d(log);
          return WorkoutLogsDTO.fromSchema(log);
        }).toList(),
      );
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<int> addWorkoutLog(WorkoutLogsDTO log) async {
    try {
      return await _db.writeTxn(() async {
        return await _db.workoutLogs.put(log.toSchema());
      });
    } catch (e) {
      // Handle other exceptions
      _logger.e('Exception type: ${e.runtimeType}');
      _logger.e('Exception: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<WorkoutLogsDTO>> getAllWorkoutLogs() async {
    try {
      final results = await _db.workoutLogs.where().findAll();
      return results.map((log) => WorkoutLogsDTO.fromSchema(log)).toList();
    } catch (e) {
      _logger.e(e);
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutLogRepoProvider = Provider((ref) {
  return WorkoutLogRepository(ref);
});
