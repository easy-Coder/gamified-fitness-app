import 'package:equatable/equatable.dart';

class WorkoutCalendarDay extends Equatable {
  const WorkoutCalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.hasWorkout,
    required this.isToday,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool hasWorkout;
  final bool isToday;

  @override
  List<Object?> get props => [date, isCurrentMonth, hasWorkout, isToday];
}

class WorkoutHistoryOverview extends Equatable {
  const WorkoutHistoryOverview({
    required this.month,
    required this.days,
    required this.currentStreak,
    required this.workoutsThisMonth,
    required this.totalWorkouts,
  });

  final DateTime month;
  final List<WorkoutCalendarDay> days;
  final int currentStreak;
  final int workoutsThisMonth;
  final int totalWorkouts;

  @override
  List<Object?> get props =>
      [month, days, currentStreak, workoutsThisMonth, totalWorkouts];
}

