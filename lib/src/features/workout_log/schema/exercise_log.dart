import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutLogId => integer().references(WorkoutLogs, #id)();
  TextColumn get exerciseName => text()();
}
