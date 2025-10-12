import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

extension DatetimeExt on DateTime {
  DateTime get date => DateTime(year, month, day);
}

extension IsTodayExt on DaysOfWeek {
  bool isToday() {
    final today = DateTime.now().weekday - 1;
    return DaysOfWeek.values[today] == this;
  }
}
