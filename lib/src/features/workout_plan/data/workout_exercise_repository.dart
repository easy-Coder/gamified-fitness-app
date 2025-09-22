import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:logger/logger.dart';

class WorkoutExerciseRepository {
  late final AppDatabase _db;
  late final Logger _logger;

  WorkoutExerciseRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

  Future<List<WorkoutExercise>> getPlanWorkoutExercises(int planId) async {
    try {
      final query = (_db.select(_db.workoutExcercise))
        ..where((row) => row.planId.equals(planId));

      final rows = await query.get();

      _logger.d(rows);

      return rows.map((row) {
        return WorkoutExercise.fromMap(row.toJson());
      }).toList();
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);
      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      _logger.e(e, error: e);
      throw Failure(message: 'An unexpected error occurred. $e');
    }
  }

  Future<void> deleteWorkoutExercise(int id) async {
    try {
      await (_db.delete(
        _db.workoutExcercise,
      )..where((t) => t.planId.equals(id))).go();
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);

      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> addWorkoutExcercise(
    List<WorkoutExercise> workoutExercises,
  ) async {
    try {
      return await _db.batch((batch) {
        batch.insertAll(
          _db.workoutExcercise,
          workoutExercises
              .map((workoutExercise) => workoutExercise.toCompanion())
              .toList(),
        );
      });
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);

      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> updateWorkoutExcercise(
    int planId,
    List<WorkoutExercise> workoutExerccises,
  ) async {
    try {
      await deleteWorkoutExercise(planId);
      await addWorkoutExcercise(workoutExerccises);
    } on DriftWrappedException catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.trace);

      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutExerciseRepoProvider = Provider(
  (ref) => WorkoutExerciseRepository(ref),
);

final workoutExercisesProvider =
    FutureProvider.family<List<WorkoutExercise>, int>(
      (ref, id) =>
          ref.read(workoutExerciseRepoProvider).getPlanWorkoutExercises(id),
    );
