import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_plan_controller.g.dart';

@riverpod
class WorkoutPlanController extends _$WorkoutPlanController {
  @override
  Future<List<WorkoutExcercise>> build(int planId) async {
    return ref.read(workoutPlanServiceProvider).getWorkOutPlan(planId);
  }
}