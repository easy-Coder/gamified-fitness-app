import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class EditPlanController extends AsyncNotifier {
  @override
  FutureOr build() {}

  Future<void> editWorkoutPlan(WorkoutPlan plan) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(workoutPlanServiceProvider).updateWorkoutPlans(plan),
    );
  }
}

final editPlanControllerProvider = AsyncNotifierProvider(
  EditPlanController.new,
);
