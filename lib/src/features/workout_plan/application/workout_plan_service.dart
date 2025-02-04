import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/workout_excercise/data/workout_excercise_repository.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class WorkoutPlanService {
  final Ref _ref;

  WorkoutPlanService(this._ref);

  Future<void> createWorkOutPlans(
      WorkoutPlan workoutPlan, List<WorkoutExcercise> workoutExcercise) async {
    try {
      // get user id
      final user_id = _ref.read(authRepositoryProvider).currentUser()!.id;
      // create plan
      final plan = await _ref
          .read(workoutPlanRepoProvider)
          .createUserPlan(workoutPlan.copyWith(userId: user_id));
      // create workout excercise
      await _ref.read(workoutExcerciseRepoProvider).addWorkoutExcerciseToPlan(
            workoutExcercise
                .map(
                  (we) => we.copyWith(
                    planId: plan.planId,
                  ),
                )
                .toList(),
          );
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    try {
      final user = _ref.read(currentUserProvider);

      return await _ref.read(workoutPlanRepoProvider).getUserPlans(user!.id);
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<List<WorkoutExcercise>> getWorkOutPlan(int planId) async {
    try {
      final plan =
          await _ref.read(workoutPlanRepoProvider).getWorkoutPlanById(planId);
      final workoutExcercise = await _ref
          .read(workoutExcerciseRepoProvider)
          .getPlanWorkoutExcercises(plan.planId!);
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

final workoutPlansProvider = FutureProvider<List<WorkoutPlan>>(
    (ref) => ref.read(workoutPlanServiceProvider).getWorkoutPlans());
