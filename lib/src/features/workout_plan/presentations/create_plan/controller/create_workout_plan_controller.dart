import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_workout_plan_controller.g.dart';

@riverpod
class CreateWorkoutPlanController extends _$CreateWorkoutPlanController {
  @override
  FutureOr<void> build() {
    //noop
  }

  Future<void> creatWorkoutPlan(WorkoutPlan plan) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(workoutPlanServiceProvider).createWorkoutPlans(plan),
    );
  }
}
