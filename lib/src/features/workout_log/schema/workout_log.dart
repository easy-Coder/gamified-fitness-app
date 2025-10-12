// import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';

part 'workout_log.g.dart';

@collection
class WorkoutLogs {
  Id? id;
  late int planId;
  late int duration;
  late DateTime? workoutDate;

  // Reference to WorkoutPlan
  @Index()
  final plan = IsarLink<WorkoutPlan>();

  // Backlink to exercise logs
  @Backlink(to: 'workoutLog')
  final exercises = IsarLinks<ExerciseLogs>();

  WorkoutLogs() {
    workoutDate = DateTime.now();
  }
}
