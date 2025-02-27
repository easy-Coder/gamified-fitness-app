import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';

class ExerciseLogs extends Table {
  IntColumn get workoutLogId =>
      integer().references(WorkoutLogs, #workoutLogId)();
  TextColumn get exerciseName => text()();
  TextColumn get exerciseType => text()();
  IntColumn get duration => integer()();
  IntColumn get intensity => integer()();
  IntColumn get caloriesBurned => integer()();

  @override
  Set<Column> get primaryKey => {exerciseName};
}
