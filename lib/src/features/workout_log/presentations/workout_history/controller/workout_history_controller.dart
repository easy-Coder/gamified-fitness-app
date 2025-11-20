import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_overview_provider.dart';

class WorkoutHistorySelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final today = ref.watch(workoutHistoryNowProvider);
    return DateTime(today.year, today.month, 1);
  }

  void previousMonth() {
    final current = state;
    state = DateTime(current.year, current.month - 1, 1);
  }

  void nextMonth() {
    final current = state;
    state = DateTime(current.year, current.month + 1, 1);
  }

  bool canGoNext(DateTime now) {
    final current = state;
    return current.year < now.year ||
        (current.year == now.year && current.month < now.month);
  }
}

final workoutHistorySelectedMonthProvider =
    NotifierProvider<WorkoutHistorySelectedMonthNotifier, DateTime>(
      WorkoutHistorySelectedMonthNotifier.new,
    );
