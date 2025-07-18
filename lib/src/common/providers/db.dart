import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/util/converter/exercise_converter.dart';
import 'package:gamified/src/features/account/schema/goal.dart';
import 'package:gamified/src/features/account/schema/preference.dart';
import 'package:gamified/src/features/account/schema/user.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart'
    show Exercise;
import 'package:gamified/src/features/hydration/model/water_intake.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart'
    show DaysOfWeek;
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db.g.dart';

@DriftDatabase(
  tables: [
    WaterIntakes,
    User,
    Goal,
    Preference,
    WorkoutPlan,
    WorkoutExcercise,
    WorkoutLogs,
    ExerciseLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'rankupfit_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

final dbProvider = Provider((ref) => AppDatabase());
