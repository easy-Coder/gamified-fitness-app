import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:isar_community/isar.dart';

part 'exercise_log.g.dart';

@collection
class ExerciseLogs {
  Id? id;
  late String exerciseId;
  late int sets;
  late int? reps;
  late double? weight;
  late int? duration;
  late DateTime createdAt;

  // Reference to WorkoutLogs
  @Index()
  final workoutLog = IsarLink<WorkoutLogs>();

  ExerciseLogs() {
    createdAt = DateTime.now();
  }
}
