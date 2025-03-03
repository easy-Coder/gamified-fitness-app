import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';

class WorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get planId => integer().nullable().references(WorkoutPlan, #id)();
  IntColumn get duration => integer()();
  IntColumn get caloriesBurned => integer()();
  TextColumn get bodyweight => text()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
}
