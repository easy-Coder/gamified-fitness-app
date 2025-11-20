import 'package:equatable/equatable.dart';

class WeeklyWorkoutDay extends Equatable {
  const WeeklyWorkoutDay({
    required this.date,
    required this.label,
    required this.hasWorkout,
    required this.isToday,
  });

  final DateTime date;
  final String label;
  final bool hasWorkout;
  final bool isToday;

  @override
  List<Object?> get props => [date, label, hasWorkout, isToday];
}

class WeeklyWorkoutSummary extends Equatable {
  const WeeklyWorkoutSummary({required this.days, required this.currentStreak});

  final List<WeeklyWorkoutDay> days;
  final int currentStreak;

  @override
  List<Object?> get props => [days, currentStreak];
}
