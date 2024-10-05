import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

part 'workout_log.mapper.dart';

@MappableClass()
class WorkoutLog with WorkoutLogMappable {
  @MappableField(key: 'log_id')
  final int? logId;
  @MappableField(key: 'user_id')
  final String? userId;
  final String notes;
  final int stamina;
  final int endurance;
  final int agility;
  final int strength;
  @MappableField(key: 'day_of_week')
  final DaysOfWeek dayOfWeek;

  WorkoutLog(
      {this.logId,
      this.userId,
      this.notes = '',
      required this.stamina,
      required this.endurance,
      required this.agility,
      required this.strength,
      required this.dayOfWeek});
}
