import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';

class SetLogs extends Table {
  IntColumn get workoutLogId =>
      integer().references(ExerciseLogs, #workoutLogId)();
  TextColumn get exerciseName =>
      text().references(ExerciseLogs, #exerciseName)();
  TextColumn get weight => text()();
  IntColumn get reps => integer()();
  IntColumn get duration => integer().nullable()();

  @override
  Set<Column> get primaryKey => {exerciseName, weight, reps};
}
