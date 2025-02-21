import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

part 'workout_exercise.mapper.dart';

@MappableClass()
class WorkoutExercise with WorkoutExerciseMappable {
  @MappableField(key: 'workout_exercise_id')
  final int? id;
  @MappableField(key: 'plan_id')
  final int? planId;
  final Exercise exercise;
  @MappableField(key: 'order_in_workout')
  final int orderInWorkout;

  WorkoutExercise({
    this.id,
    this.planId,
    this.orderInWorkout = 0,
    required this.exercise,
  });

  Map<String, dynamic> toBody() {
    return toMap()
      ..remove('exercise')
      ..addAll({'exercise_id': exercise.exerciseId});
  }

  WorkoutExcerciseCompanion toCompanion() {
    return WorkoutExcerciseData.fromJson(toBody()).toCompanion(true);
  }
}
