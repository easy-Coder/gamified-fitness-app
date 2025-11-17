// import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:isar_community/isar.dart';

part 'workout_plan.g.dart';

@collection
class WorkoutPlan {
  Id? id;
  late String name;
  late bool isVisible;

  // Validation for name length
  bool isValid() {
    return name.length >= 10 && name.length <= 50;
  }

  // Backlink to workout exercises
  @Backlink(to: 'plan')
  final exercises = IsarLinks<WorkoutExercise>();
}
