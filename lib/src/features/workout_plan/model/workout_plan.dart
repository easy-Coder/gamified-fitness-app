import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';

part 'workout_plan.mapper.dart';

@MappableEnum()
enum DaysOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

@MappableClass()
class WorkoutPlan with WorkoutPlanMappable {
  @MappableField(key: 'id')
  final int? id;
  final String name;
  @MappableField(key: 'day_of_week')
  final DaysOfWeek dayOfWeek;
  final List<WorkoutExcercise> workoutExercise;

  WorkoutPlan(this.id, this.name, this.dayOfWeek, this.workoutExercise);
}

extension IsTodayExt on DaysOfWeek {
  bool isToday() {
    final today = DateTime.now().weekday - 1;
    return DaysOfWeek.values[today] == this;
  }
}
