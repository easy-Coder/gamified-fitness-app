import 'package:isar_community/isar.dart';

part 'preference.g.dart';

enum WeightUnit { kg, lbs }

// Preference collection
@collection
class Preference {
  Id? id;

  @enumerated
  WeightUnit weightUnit = WeightUnit.kg;

  bool useHealth = false;

  bool workoutReminders = true;
  bool achievementNotifications = true;
  bool weeklyProgress = true;
}
