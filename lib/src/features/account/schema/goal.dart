import 'package:isar_community/isar.dart';

part 'goal.g.dart';

enum FitnessGoal { loseWeight, buildMuscle, keepFit }

// Goal collection

@collection
class Goal {
  Id? id;
  @enumerated
  late FitnessGoal fitnessGoal;
  late double targetWeight;
  late double hydrationGoal;
}
