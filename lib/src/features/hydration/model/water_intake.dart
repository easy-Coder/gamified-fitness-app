import 'package:drift/drift.dart';

enum DrinkType {
  water,
  coffee,
  tea,
  soda,
  juice,
  sportsDrink,
  other,
}

extension HydrationFactorExt on DrinkType {
  double get hydrationFactor {
    switch (this) {
      case DrinkType.water:
        return 1.0;
      case DrinkType.coffee:
        return 0.95;
      case DrinkType.tea:
        return 0.97;
      case DrinkType.soda:
        return 0.98;
      case DrinkType.juice:
        return 0.85;
      case DrinkType.sportsDrink:
        return 0.93;
      case DrinkType.other:
        return 0.8;
    }
  }
}

class WaterIntakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  IntColumn get drinkType => intEnum<DrinkType>()();
  DateTimeColumn get time => dateTime().clientDefault(() => DateTime.now())();
}
