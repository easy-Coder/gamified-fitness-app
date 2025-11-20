import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/stats/model/weekly_workout_summary.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

const _weekdayLabels = ['M', 'T', 'W', 'Th', 'F', 'S', 'S'];

final weeklyWorkoutSummaryProvider =
    StreamProvider.autoDispose<WeeklyWorkoutSummary>((ref) {
      final repo = ref.read(workoutLogRepoProvider);

      return repo.getWorkoutLogs(WorkoutLogFilter.week).asyncMap((
        weeklyLogs,
      ) async {
        final today = DateTime.now().date;
        final mondayThisWeek = today.subtract(
          Duration(days: today.weekday - 1),
        );

        final allLogs = await repo.getAllWorkoutLogs();
        final allWorkoutDates = _extractWorkoutDates(allLogs, today);
        final weeklyWorkoutDates = _extractWorkoutDates(weeklyLogs, today);

        final weeklyDays = _buildWeeklyDays(
          startOfWeek: mondayThisWeek,
          today: today,
          completedDates: weeklyWorkoutDates,
        );

        final streak = _calculateCurrentStreak(allWorkoutDates, today);

        return WeeklyWorkoutSummary(days: weeklyDays, currentStreak: streak);
      });
    });

Set<DateTime> _extractWorkoutDates(List<WorkoutLogsDTO> logs, DateTime today) {
  return logs
      .where((log) => log.workoutDate != null)
      .map((log) => log.workoutDate!.date)
      .where((date) => !date.isAfter(today))
      .toSet();
}

List<WeeklyWorkoutDay> _buildWeeklyDays({
  required DateTime startOfWeek,
  required DateTime today,
  required Set<DateTime> completedDates,
}) {
  return List<WeeklyWorkoutDay>.generate(7, (index) {
    final date = startOfWeek.add(Duration(days: index)).date;
    return WeeklyWorkoutDay(
      date: date,
      label: _weekdayLabels[index],
      hasWorkout: completedDates.contains(date),
      isToday: date == today,
    );
  });
}

int _calculateCurrentStreak(Set<DateTime> workoutDates, DateTime today) {
  if (workoutDates.isEmpty) return 0;

  final relevantDates = workoutDates.where((date) => !date.isAfter(today));
  if (relevantDates.isEmpty) return 0;

  final sortedDates = relevantDates.toList()
    ..sort((a, b) => b.compareTo(a)); // descending order

  var streak = 1;
  var cursor = sortedDates.first.subtract(const Duration(days: 1));

  while (workoutDates.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}
