import 'package:drift/drift.dart';

enum Gender { male, female }

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 50)();
  // ignore: recursive_getters
  IntColumn get age => integer().check(age.isBetween(const Constant(10), const Constant(90)))();
  IntColumn get gender => intEnum<Gender>()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
}
