// import 'package:drift/drift.dart';
import 'package:gamified/src/common/util/converter/exercise_converter.dart';
import 'package:gamified/src/features/excersice/schema/excercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';

part 'workout_exercise.g.dart';

@collection
class WorkoutExercise {
  Id? id;
  late int planId;
  late Exercise exercise; // Stores the JSON/serialized Exercise
  late int restTime;
  late int orderInWorkout;

  // Reference to WorkoutPlan
  @Index()
  final plan = IsarLink<WorkoutPlan>();
  // // Helper methods for Exercise conversion
  // Exercise getExerciseObject() {
  //   // Parse your exercise from the string/JSON
  //   // This depends on how ExerciseConverter() works in your Drift code
  //   return Exercise(id: exercise, name: exercise);
  // }

  // void setExerciseObject(Exercise exerciseObj) {
  //   // Serialize Exercise back to string
  //   exercise = exerciseObj.id;
  // }
}
