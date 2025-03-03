import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';

class SetLogs extends Table {
  IntColumn get setLogId => integer().autoIncrement()();
  IntColumn get exerciseLogId => integer().references(ExerciseLogs, #id)();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get duration => integer().nullable()();
}
