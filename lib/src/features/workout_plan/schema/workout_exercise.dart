import 'package:drift/drift.dart';
import 'package:gamified/src/features/excersice/schema/exercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';

class WorkoutExcercise extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().nullable().references(WorkoutPlan, #id)();
  IntColumn get excerciseId => integer().references(Exercise, #id)();
  IntColumn get orderInWorkout => integer()();
}
