import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

part 'workout_excercise.mapper.dart';

@MappableClass()
class WorkoutExcercise with WorkoutExcerciseMappable {

  final Excercise excercise;
  final int sets;
  final int reps;

  WorkoutExcercise({required this.excercise, required this.sets, required this.reps});
}