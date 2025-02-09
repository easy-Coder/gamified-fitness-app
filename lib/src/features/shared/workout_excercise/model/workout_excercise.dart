import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

part 'workout_excercise.mapper.dart';

@MappableClass()
class WorkoutExcercise with WorkoutExcerciseMappable {
  @MappableField(key: 'workout_exercise_id')
  final int? workoutExcerciseId;
  @MappableField(key: 'plan_id')
  final int? planId;
  final Excercise exercise;
  final int sets;
  final int reps;
  @MappableField(key: 'order_in_workout')
  final int orderInWorkout;

  WorkoutExcercise(
      {this.workoutExcerciseId,
      this.planId,
      this.orderInWorkout = 0,
      required this.exercise,
      required this.sets,
      required this.reps});

  Map<String, dynamic> toBody() {
    return toMap()
      ..remove('exercise')
      ..addAll({
        'exercise_id': exercise.exerciseId,
      });
  }
}
