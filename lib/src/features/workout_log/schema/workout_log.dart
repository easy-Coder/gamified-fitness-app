import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';

class WorkoutLogs extends Table {
  IntColumn get workoutLogId => integer().autoIncrement()();
  IntColumn get planId => integer().references(WorkoutPlan, #id)();
  IntColumn get duration => integer()();
  IntColumn get caloriesBurned => integer()();
  TextColumn get bodyweight => text()();
  IntColumn get avgHeartRate => integer().nullable()();
  DateTimeColumn get workoutDate =>
      dateTime().withDefault(currentDateAndTime)();
}
