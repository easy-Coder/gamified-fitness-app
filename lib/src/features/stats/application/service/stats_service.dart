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
          // Get the first available workout plan since we no longer filter by day
          final workoutPlans = await _ref
              .read(workoutPlanRepoProvider)
              .getUserPlans()
              .first;
          final workoutPlan = workoutPlans.isNotEmpty ? workoutPlans.first : null;

          return (workoutPlan, log == null);
        });
  }
}

final statServiceProvider = Provider((ref) => StatsService(ref));

final todayWorkoutPlanProvider =
    StreamProvider.autoDispose<(WorkoutPlanDTO?, bool)>(
      (ref) => ref.watch(statServiceProvider).getTodayPlan(),
    );
