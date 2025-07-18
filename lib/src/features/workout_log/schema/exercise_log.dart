import 'package:drift/drift.dart';

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer()();
  RealColumn get weight => real()();
  IntColumn get duration => integer()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}