import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class CreateWorkoutPlanController extends AsyncNotifier {
  @override
  FutureOr<void> build() {
    //noop
  }

  Future<void> creatWorkoutPlan(WorkoutPlanDTO plan) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(workoutPlanServiceProvider).createWorkoutPlans(plan),
    );
  }
}

final createWorkoutPlanControllerProvider = AsyncNotifierProvider(
  CreateWorkoutPlanController.new,
);
