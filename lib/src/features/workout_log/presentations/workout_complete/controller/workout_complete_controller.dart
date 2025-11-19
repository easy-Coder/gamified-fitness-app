import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/application/workout_complete_service.dart';
import 'package:gamified/src/features/workout_log/application/workout_log_service.dart';
import 'package:gamified/src/features/workout_log/model/workout_complete_summary.dart';

final workoutCompleteSummaryProvider = FutureProvider.autoDispose<WorkoutCompleteSummary>(
  (ref) async {
    final today = DateTime.now();
    final workoutLog = await ref.read(workoutLogServiceProvider).getTodayWorkoutLog(today);
    final summary = await ref.read(workoutCompleteServiceProvider).getWorkoutCompleteSummary(workoutLog);
    return summary;
  },
);

