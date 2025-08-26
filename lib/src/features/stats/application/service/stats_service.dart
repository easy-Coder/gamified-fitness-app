import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class StatsService {
  final Ref _ref;

  const StatsService(Ref ref) : _ref = ref;

  Stream<(WorkoutPlan?, bool)> getTodayPlan() async* {
    while (true) {
      try {
        final today = DateTime.now();

        final workoutPlan = await _ref
            .read(workoutPlanRepoProvider)
            .getUserWorkoutPlanByDay(DaysOfWeek.values[today.weekday - 1]);

        final log = await _ref
            .read(workoutLogRepoProvider)
            .getWorkoutLogByDate(today);

        yield (workoutPlan, log == null);

        // Wait for 2 seconds before next emission
        await Future.delayed(const Duration(seconds: 2));
      } on Failure catch (_) {
        rethrow;
      }
    }
  }
}

final statServiceProvider = Provider((ref) => StatsService(ref));

final todayWorkoutPlanProvider =
    StreamProvider.autoDispose<(WorkoutPlan?, bool)>(
      (ref) => ref.watch(statServiceProvider).getTodayPlan(),
    );
