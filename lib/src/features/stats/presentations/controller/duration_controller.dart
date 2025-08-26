import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';

class WorkoutLogFilterNotifier extends Notifier<WorkoutLogFilter> {
  @override
  WorkoutLogFilter build() {
    return WorkoutLogFilter.week;
  }

  void changeFilter(WorkoutLogFilter filter) {
    state = filter;
  }
}

final workoutLogFilter =
    NotifierProvider<WorkoutLogFilterNotifier, WorkoutLogFilter>(
      WorkoutLogFilterNotifier.new,
    );

final durationController = StreamProvider((ref) {
  final filter = ref.watch(workoutLogFilter);
  return ref.read(workoutLogRepoProvider).getWorkoutLogs(filter);
});
