import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';

class WorkoutExerciseRepository {
  final AppDatabase _db;

  const WorkoutExerciseRepository(this._db);

  Future<List<WorkoutExercise>> getPlanWorkoutExercises(int planId) async {
    try {
      final query = (_db.select(_db.workoutExcercise))
        ..where((row) => row.planId.equals(planId));

      final rows = await query.get();

      return rows.map((row) {
        return WorkoutExercise(
          id: row.id,
          planId: row.planId,
          exercise: row.exercise, // Assign the Exercise object
        );
      }).toList();
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> deleteWorkoutExercise(int id) async {
    try {
      await (_db.delete(
        _db.workoutExcercise,
      )..where((t) => t.planId.equals(id))).go();
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
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
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
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
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}

final workoutExerciseRepoProvider = Provider(
  (ref) => WorkoutExerciseRepository(ref.read(dbProvider)),
);

final workoutExercisesProvider =
    FutureProvider.family<List<WorkoutExercise>, int>(
      (ref, id) =>
          ref.read(workoutExerciseRepoProvider).getPlanWorkoutExercises(id),
    );
