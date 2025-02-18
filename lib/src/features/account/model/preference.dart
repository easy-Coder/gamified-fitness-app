import 'package:drift/drift.dart';

enum WeightUnit { kg, lbs }

enum FluidUnit { millimeter, ounces }

class Preference extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weightUnit => intEnum<WeightUnit>()();
  IntColumn get fluidUnit => intEnum<FluidUnit>()();
}
