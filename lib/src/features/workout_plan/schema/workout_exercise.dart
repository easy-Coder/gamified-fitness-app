import 'package:drift/drift.dart';
import 'package:gamified/src/common/util/converter/exercise_converter.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';

class WorkoutExcercise extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId =>
      integer().references(
        WorkoutPlan,
        #id,
        onUpdate: KeyAction.cascade,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get exercise => text().map(ExerciseConverter())();
  IntColumn get orderInWorkout => integer()();
}
