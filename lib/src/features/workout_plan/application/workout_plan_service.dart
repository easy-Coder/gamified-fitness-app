import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/data/workout_exercise_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class WorkoutPlanService {
  final Ref _ref;

  WorkoutPlanService(this._ref);

  Future<WorkoutPlan> getWorkoutPlanById(int id) async {
    try {
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .getWorkoutPlanById(id);
      final workoutExercise = await _ref
          .read(workoutExerciseRepoProvider)
          .getPlanWorkoutExercises(id);
      return plan.copyWith(workoutExercise: workoutExercise);
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<void> createWorkoutPlans(WorkoutPlan workoutPlan) async {
    try {
      // create plan
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .createUserPlan(workoutPlan);
      // create workout excercise
      await _ref
          .read(workoutExerciseRepoProvider)
          .addWorkoutExcercise(
            workoutPlan.workoutExercise
                .map((we) => we.copyWith(planId: plan))
                .toList(),
          );
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<void> updateWorkoutPlans(WorkoutPlan workoutPlan) async {
    if (workoutPlan.id == null) {
      throw Failure(message: 'Cannot update workout plan without ID');
    }

    // Make sure workoutExercise list has the correct planId
    final exercisesWithCorrectPlanId =
        workoutPlan.workoutExercise
            .map((we) => we.copyWith(planId: workoutPlan.id!))
            .toList();

    try {
      await _ref.read(dbProvider).transaction(() async {
        // Step 1: Update the workout plan
        await _ref.read(workoutPlanRepoProvider).updateWorkoutPlan(workoutPlan);

        // Step 2: Delete existing exercises
        await _ref
            .read(workoutExerciseRepoProvider)
            .deleteWorkoutExercise(workoutPlan.id!);

        // Step 3: Add all exercises (both updated and new ones)
        await _ref
            .read(workoutExerciseRepoProvider)
            .addWorkoutExcercise(exercisesWithCorrectPlanId);

        print('Transaction completed successfully');
      });
    } catch (e) {
      print('Transaction failed: $e');
      throw Failure(message: 'Failed to update workout plan: $e');
    }
  }

  Future<List<WorkoutExercise>> getWorkOutPlan(int planId) async {
    try {
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .getWorkoutPlanById(planId);
      final workoutExcercise = await _ref
          .read(workoutExerciseRepoProvider)
          .getPlanWorkoutExercises(plan.id!);
      print(workoutExcercise);
      return workoutExcercise;
    } on Failure catch (_) {
      rethrow;
    }
  }
}

final workoutPlanServiceProvider = Provider((ref) {
  return WorkoutPlanService(ref);
});

final workoutPlanProvider = FutureProvider.autoDispose.family<WorkoutPlan, int>(
  (ref, id) => ref.read(workoutPlanServiceProvider).getWorkoutPlanById(id),
);
