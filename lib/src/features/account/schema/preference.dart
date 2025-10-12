import 'package:isar_community/isar.dart';

part 'preference.g.dart';

enum WeightUnit { kg, lbs }

enum FluidUnit { millimeter, ounces }

// Preference collection
@collection
class Preference {
  Id? id;
  @enumerated
  late WeightUnit weightUnit;
  @enumerated
  late FluidUnit fluidUnit;
}
