import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';

class WorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(WorkoutPlan, #id)();
  IntColumn get duration => integer()();
  DateTimeColumn get workoutDate =>
      dateTime().withDefault(currentDate).nullable()();
}
