import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/util/converter/exercise_converter.dart';
import 'package:gamified/src/features/account/schema/goal.dart';
import 'package:gamified/src/features/account/schema/preference.dart';
import 'package:gamified/src/features/account/schema/user.dart';
import 'package:gamified/src/features/excersice/schema/excercise.dart'
    show Exercise;
import 'package:gamified/src/features/hydration/model/water_intake.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart'
    show DaysOfWeek;
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db.g.dart';

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
  late final Isar isar;

  AppDatabase({required this.isar});

  // Schemas from your generated files
  static const List<CollectionSchema<dynamic>> schemas = [
    // Add all your collection schemas here
    UserSchema,
    WorkoutPlanSchema,
    WorkoutLogsSchema,
    ExerciseLogsSchema,
    WorkoutExerciseSchema,
    GoalSchema,
    PreferenceSchema,
  ];

  static Future<AppDatabase> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = Isar.openSync(
      schemas,
      directory: dir.path,
      inspector: true, // Enable inspector for debugging
    );
    return AppDatabase(isar: isar);
  }

  Future<void> close() async {
    await isar.close();
  }

  // Add helper methods for common operations
  Future<void> clear() async {
    await isar.writeTxn(() async {
      // Add your collections to clear
      // await isar.users.clear();
      // await isar.workoutPlans.clear();
    });
  }
}

// Easy access to Isar instance
final dbProvider = Provider<Isar>((ref) {
  AppDatabase? db;
  AppDatabase.create().then((d) => db = d);
  return db!.isar;
});
