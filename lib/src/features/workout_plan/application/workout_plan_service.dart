import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/data/workout_exercise_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';

class WorkoutPlanService {
  final Ref _ref;

  WorkoutPlanService(this._ref);

  Future<void> createWorkOutPlans(
    WorkoutPlanCompanion workoutPlan,
    List<WorkoutExercise> workoutExcercise,
  ) async {
    try {
      // create plan
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .createUserPlan(workoutPlan);
      // create workout excercise
      await _ref
          .read(workoutExerciseRepoProvider)
          .addWorkoutExcerciseToPlan(
            workoutExcercise.map((we) => we.copyWith(planId: plan)).toList(),
          );
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<List<WorkoutExercise>> getWorkOutPlan(int planId) async {
    try {
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .getWorkoutPlanById(planId);
      final workoutExcercise = await _ref
          .read(workoutExerciseRepoProvider)
          .getPlanWorkoutExercises(plan.id);
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
