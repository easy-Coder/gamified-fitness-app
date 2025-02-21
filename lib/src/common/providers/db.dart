import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/model/preference.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/excersice/schema/exercise.dart';
import 'package:gamified/src/features/hydration/model/water_intake.dart';
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
    Exercise,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
