import 'package:drift/drift.dart';

enum Gender { male, female }

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get age => integer().check(age.isBetweenValues(10, 90))();
  IntColumn get gender => intEnum<Gender>()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
}
