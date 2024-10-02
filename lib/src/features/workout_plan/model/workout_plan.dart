import 'package:dart_mappable/dart_mappable.dart';

part 'workout_plan.mapper.dart';

@MappableEnum()
enum DaysOfWeek {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

@MappableClass()
class WorkoutPlan with WorkoutPlanMappable {
  @MappableField(key: 'plan_id')
  final int? planId;
  @MappableField(key: 'user_id')
  final String? userId;
  final String name;
  @MappableField(key: 'day_of_week')
  final DaysOfWeek dayOfWeek;

  WorkoutPlan(this.planId, this.name, this.dayOfWeek, this.userId);
}
