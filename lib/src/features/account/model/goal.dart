import 'package:drift/drift.dart';

enum FitnessGoal { loseWeight, buildMuscle, keepFit }

class Goal extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fitnessGoal => textEnum<FitnessGoal>()();
  RealColumn get targetWeight => real()();
  RealColumn get hydrationGoal => real()();
}
