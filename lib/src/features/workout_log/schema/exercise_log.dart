import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutLogId => integer().references(WorkoutLogs, #id)();
  TextColumn get exerciseId => text()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()();
  IntColumn get duration => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
