import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class StatsService {
  final Ref _ref;

  const StatsService(Ref ref) : _ref = ref;

  // stat overview
  Future<WorkoutPlan?> getTodayPlan() async {
    try {
      final today = DateTime.now();

      final workoutPlan = await _ref
          .read(workoutPlanRepoProvider)
          .getUserWorkoutPlanByDay(DaysOfWeek.values[today.weekday - 1]);

      return workoutPlan;
    } on Failure catch (_) {
      rethrow;
    }
  }
}

final statServiceProvider = Provider((ref) => StatsService(ref));

final todayWorkoutPlanProvider = FutureProvider.autoDispose<WorkoutPlan?>(
  (ref) => ref.watch(statServiceProvider).getTodayPlan(),
);
