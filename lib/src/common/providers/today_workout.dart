import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_workout.g.dart';

@riverpod
class TodayWorkout extends _$TodayWorkout {
  @override
  WorkoutPlan? build() {
    return null;
  }

  void setTodayPlan(WorkoutPlan? plan) {
    state = plan;
  }
}
