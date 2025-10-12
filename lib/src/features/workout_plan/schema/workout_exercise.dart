// import 'package:drift/drift.dart';
import 'package:gamified/src/features/excersice/schema/excercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';

part 'workout_exercise.g.dart';

@collection
class WorkoutExercise {
  Id? id;
  late Exercise exercise; 
  late int? restTime;
  late int orderInWorkout;

  // Reference to WorkoutPlan
  @Index()
  final plan = IsarLink<WorkoutPlan>();
}
