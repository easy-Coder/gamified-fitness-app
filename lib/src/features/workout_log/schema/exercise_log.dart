import 'package:drift/drift.dart';

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
