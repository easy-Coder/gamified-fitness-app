import 'package:drift/drift.dart';

part 'user.g.dart';

enum Gender { male, female }

enum FitnessGoal { loseWeight, buildMuscle, keepFit }

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get age => integer().check(age.isBetweenValues(10, 90))();
  TextColumn get gender => textEnum<Gender>()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
}
