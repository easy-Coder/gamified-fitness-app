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
      final result = await _db.workoutPlans.get(planId);

      if (result == null) {
        throw Failure(message: "No workoutplan for the id: $planId");
      }

      await result.exercises.load();

      return result.exercises.map((row) {
        return WorkoutExerciseDTO.fromSchema(row);
      }).toList();
    } on IsarError catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.stackTrace);
      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      _logger.e(e, error: e);
      throw Failure(message: 'An unexpected error occurred. $e');
    }
  }

  Future<void> deleteWorkoutExercise(int id) async {
    try {
      _db.writeTxn(() async {
        await _db.workoutExercises.delete(id);
      });
    } on IsarError catch (e) {
      // Handle Drift-specific exceptions
      _logger.e(e.message, error: e, stackTrace: e.stackTrace);
      throw Failure(message: e.message);
    } catch (e) {
      // Handle other exceptions
      _logger.e(e, error: e);
      throw Failure(message: 'An unexpected error occurred. $e');
    }
  }

  Future<void> addWorkoutExercise(
    int planId,
    List<WorkoutExerciseDTO> exercises,
  ) async {
    try {
      await _db.writeTxn(() async {
        final plan = await _db.workoutPlans.get(planId);
        if (plan == null) throw Failure(message: 'Workout Plan not found');

        // Convert and persist exercises to assign IDs
        final saved = exercises.map((e) => e.toSchema()).toList();
        for (final exercise in saved) {
          exercise.plan.value = plan;
        }
        await _db.workoutExercises.putAll(saved);

        // Link to plan and persist links
        plan.exercises.addAll(saved);
        await plan.exercises.save();
      });
    } on IsarError catch (e, s) {
      _logger.e(e.message, error: e, stackTrace: s);
      throw Failure(message: e.message);
    } catch (_) {
      throw Failure(message: 'An unexpected error occurred');
    }
  }

  Future<void> updateWorkoutExercise(
    int planId,
    List<WorkoutExerciseDTO> exercises,
  ) async {
    try {
      final plan = await _db.workoutPlans.get(planId);
      if (plan == null) throw Failure(message: 'Workout Plan not found');

      await _db.writeTxn(() async {
        // Clear existing exercise links
        await plan.exercises.reset();

        // Convert and persist new exercises
        final saved = exercises.map((e) => e.toSchema()).toList();
        await _db.workoutExercises.putAll(saved);

        // Link and save
        plan.exercises.addAll(saved);
        await plan.exercises.save();
      });
    } on IsarError catch (e, s) {
      _logger.e(e.message, error: e, stackTrace: s);
      throw Failure(message: e.message);
    } catch (_) {
      throw Failure(message: 'An unexpected error occurred');
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
