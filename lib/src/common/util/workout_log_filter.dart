import 'package:shadcn_ui/shadcn_ui.dart';

enum WorkoutLogFilter { week, month, year }

// Extension to get date ranges for each filter
extension WorkoutLogFilterExtension on WorkoutLogFilter {
  (DateTime lower, DateTime upper) getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Start of today

    switch (this) {
      case WorkoutLogFilter.week:
        // Get the Monday of current week
        final currentWeekday = now.weekday; // Monday = 1, Sunday = 7
        final mondayOfCurrentWeek = today.subtract(
          Duration(days: currentWeekday - 1),
        );
        // Get the Sunday of current week (end of week)
        final sundayOfCurrentWeek = mondayOfCurrentWeek.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        return (mondayOfCurrentWeek, sundayOfCurrentWeek);

      case WorkoutLogFilter.month:
        // First day of current month
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        // Last day of current month
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return (firstDayOfMonth, lastDayOfMonth);

      case WorkoutLogFilter.year:
        // First day of current year
        final firstDayOfYear = DateTime(now.year, 1, 1);
        // Last day of current year
        final lastDayOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
        return (firstDayOfYear, lastDayOfYear);
    }
  }
}
