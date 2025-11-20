import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_history_overview.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

final workoutHistoryNowProvider = Provider<DateTime>((_) => DateTime.now());

final workoutHistoryLogsProvider =
    FutureProvider<List<WorkoutLogsDTO>>((ref) async {
      final repo = ref.read(workoutLogRepoProvider);
      return repo.getAllWorkoutLogs();
    });

final workoutHistoryOverviewProvider =
    Provider.autoDispose.family<AsyncValue<WorkoutHistoryOverview>, DateTime>(
        (ref, month) {
  final logsAsync = ref.watch(workoutHistoryLogsProvider);

  return logsAsync.whenData((logs) {
    final today = ref.watch(workoutHistoryNowProvider).date;
    final monthStart = DateTime(month.year, month.month, 1);
    final workoutDates = _extractWorkoutDates(logs, today);

    final calendarDays = _buildCalendarDays(
      monthStart: monthStart,
      today: today,
      workoutDates: workoutDates,
    );

    final currentStreak = _calculateCurrentStreak(workoutDates, today);
    final workoutsThisMonth = workoutDates.where(
      (date) => date.year == monthStart.year && date.month == monthStart.month,
    ).length;

    return WorkoutHistoryOverview(
      month: monthStart,
      days: calendarDays,
      currentStreak: currentStreak,
      workoutsThisMonth: workoutsThisMonth,
      totalWorkouts: workoutDates.length,
    );
  });
});

Set<DateTime> _extractWorkoutDates(
  List<WorkoutLogsDTO> logs,
  DateTime today,
) {
  return logs
      .where((log) => log.workoutDate != null)
      .map((log) => log.workoutDate!.date)
      .where((date) => !date.isAfter(today))
      .toSet();
}

List<WorkoutCalendarDay> _buildCalendarDays({
  required DateTime monthStart,
  required DateTime today,
  required Set<DateTime> workoutDates,
}) {
  final leadingDays = (monthStart.weekday + 6) % 7; // Monday-first
  final gridStart = monthStart.subtract(Duration(days: leadingDays));

  return List<WorkoutCalendarDay>.generate(42, (index) {
    final date = gridStart.add(Duration(days: index)).date;
    return WorkoutCalendarDay(
      date: date,
      isCurrentMonth:
          date.year == monthStart.year && date.month == monthStart.month,
      hasWorkout: workoutDates.contains(date),
      isToday: date == today,
    );
  });
}

int _calculateCurrentStreak(Set<DateTime> workoutDates, DateTime today) {
  if (workoutDates.isEmpty) return 0;

  final relevantDates = workoutDates.where((date) => !date.isAfter(today));
  if (relevantDates.isEmpty) return 0;

  final sortedDates = relevantDates.toList()
    ..sort((a, b) => b.compareTo(a));

  var streak = 1;
  var cursor = sortedDates.first.subtract(const Duration(days: 1));

  while (workoutDates.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}

