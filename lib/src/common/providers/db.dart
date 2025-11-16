import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/schema/goal.dart';
import 'package:gamified/src/features/account/schema/measurement.dart';
import 'package:gamified/src/features/account/schema/preference.dart';
import 'package:gamified/src/features/account/schema/user.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

// part 'db.g.dart';

// @DriftDatabase(
//   tables: [
//     WaterIntakes,
//     User,
//     Goal,
//     Preference,
//     WorkoutPlan,
//     WorkoutExcercise,
//     WorkoutLogs,
//     ExerciseLogs,
//   ],
// )
class AppDatabase {
  static AppDatabase? _instance;
  final Isar isar;

  AppDatabase._(this.isar);

  // Schemas from your generated files
  static const List<CollectionSchema<dynamic>> schemas = [
    UserSchema,
    WorkoutPlanSchema,
    WorkoutExerciseSchema, // ✅ MUST be here
    WorkoutLogsSchema,
    ExerciseLogsSchema,
    GoalSchema,
    PreferenceSchema,
    MeasurementSchema,
  ];

  /// Initializes the singleton instance if not already created
  static Future<AppDatabase> getInstance() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(schemas, directory: dir.path, inspector: true);
    _instance = AppDatabase._(isar);
    return _instance!;
  }

  /// Accessor for the already-initialized instance
  static AppDatabase get instance {
    if (_instance == null) {
      throw Exception(
        'AppDatabase not initialized. Call await AppDatabase.getInstance() first.',
      );
    }
    return _instance!;
  }

  Future<void> close() async {
    await isar.close();
    _instance = null;
  }

  /// Clears selected collections
  Future<void> clear() async {
    await isar.writeTxn(() async {
      // await isar.users.clear();
      // await isar.workoutPlans.clear();
    });
  }
}

/// Riverpod provider for accessing the Isar instance
final dbProvider = Provider<Isar>((ref) {
  return AppDatabase.instance.isar;
});
