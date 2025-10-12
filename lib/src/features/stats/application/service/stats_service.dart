import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class StatsService {
  final Ref _ref;

  const StatsService(Ref ref) : _ref = ref;

  Stream<(WorkoutPlanDTO?, bool)> getTodayPlan() {
    final today = DateTime.now();

    return _ref
        .read(workoutLogRepoProvider)
        .getWorkoutLogByDateStream(today)
        .asyncMap((log) async {
          final workoutPlan = await _ref
              .read(workoutPlanRepoProvider)
              .getUserWorkoutPlanByDay(DaysOfWeek.values[today.weekday - 1]);

          return (workoutPlan, log == null);
        });
  }
}

final statServiceProvider = Provider((ref) => StatsService(ref));

final todayWorkoutPlanProvider =
    StreamProvider.autoDispose<(WorkoutPlanDTO?, bool)>(
      (ref) => ref.watch(statServiceProvider).getTodayPlan(),
    );
