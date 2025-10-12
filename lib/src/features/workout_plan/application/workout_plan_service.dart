import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_exercise_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class WorkoutPlanService {
  final Ref _ref;

  WorkoutPlanService(this._ref);

  Future<(WorkoutPlanDTO, bool)> getWorkoutPlanById(int id) async {
    try {
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .getWorkoutPlanById(id);
      final workoutExercise = await _ref
          .read(workoutExerciseRepoProvider)
          .getPlanWorkoutExercises(id);

      final log = await _ref
          .read(workoutLogRepoProvider)
          .getWorkoutLogByDate(DateTime.now());

      return (plan.copyWith(exercises: workoutExercise), log == null);
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    }
  }

  Future<void> createWorkoutPlans(WorkoutPlanDTO workoutPlan) async {
    try {
      // create plan
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .createUserPlan(workoutPlan);
      // create workout excercise
      await _ref
          .read(workoutExerciseRepoProvider)
          .addWorkoutExcercise(
            plan,
            workoutPlan.exercises.map((we) => we.copyWith(id: plan)).toList(),
          );
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<void> updateWorkoutPlans(WorkoutPlanDTO workoutPlan) async {
    if (workoutPlan.id == null) {
      throw Failure(message: 'Cannot update workout plan without ID');
    }

    try {
      await _ref.read(workoutPlanRepoProvider).updateWorkoutPlan(workoutPlan);
    } catch (e) {
      throw Failure(message: 'Failed to update workout plan: $e');
    }
  }

  Future<List<WorkoutExerciseDTO>> getWorkOutExercises(int planId) async {
    try {
      final workoutExcercise = await _ref
          .read(workoutExerciseRepoProvider)
          .getPlanWorkoutExercises(planId);
      return workoutExcercise;
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<void> deleteWorkoutPlans(WorkoutPlanDTO plan) async {
    try {
      await _ref.read(workoutPlanRepoProvider).deleteWorkoutPlan(plan);
    } on Failure catch (_) {
      rethrow;
    }
  }
}

final workoutPlanServiceProvider = Provider((ref) {
  return WorkoutPlanService(ref);
});

final workoutPlanProvider = FutureProvider.autoDispose
    .family<(WorkoutPlanDTO, bool), int>(
      (ref, id) => ref.read(workoutPlanServiceProvider).getWorkoutPlanById(id),
    );
