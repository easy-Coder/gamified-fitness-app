import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class WorkoutExerciseRepository {
  late final Isar _db;
  late final Logger _logger;

  WorkoutExerciseRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

  Future<List<WorkoutExerciseDTO>> getPlanWorkoutExercises(int planId) async {
    try {
      final result = await _db.workoutExercises
          .where()
          .filter()
          .planIdEqualTo(planId)
          .findAll();

      _logger.d(result);

      return result.map((row) {
        return WorkoutExerciseDTO.fromSchema(row);
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
      await _db.workoutExercises.where().filter().planIdEqualTo(id).deleteAll();
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> addWorkoutExcercise(
    int planId,
    List<WorkoutExerciseDTO> workoutExercises,
  ) async {
    try {
      final workputPlan = await _db.workoutPlans.get(planId);
      if (workputPlan == null) {
        throw Failure(message: "No Workout Plan here");
      }
      return await _db.writeTxn(() async {
        workputPlan.exercises.addAll(
          workoutExercises
              .map((workoutExercise) => workoutExercise.toSchema())
              .toList(),
        );
        workputPlan.exercises.save();
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
    List<WorkoutExerciseDTO> workoutExerccises,
  ) async {
    try {
      await deleteWorkoutExercise(planId);
      await addWorkoutExcercise(planId, workoutExerccises);
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
    FutureProvider.family<List<WorkoutExerciseDTO>, int>(
      (ref, id) =>
          ref.read(workoutExerciseRepoProvider).getPlanWorkoutExercises(id),
    );
