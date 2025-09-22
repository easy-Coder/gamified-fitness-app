// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldWaterIntakesData = <v1.WaterIntakesData>[];
    final expectedNewWaterIntakesData = <v2.WaterIntakesData>[];

    final oldUserData = <v1.UserData>[];
    final expectedNewUserData = <v2.UserData>[];

    final oldGoalData = <v1.GoalData>[];
    final expectedNewGoalData = <v2.GoalData>[];

    final oldPreferenceData = <v1.PreferenceData>[];
    final expectedNewPreferenceData = <v2.PreferenceData>[];

    final oldWorkoutPlanData = <v1.WorkoutPlanData>[];
    final expectedNewWorkoutPlanData = <v2.WorkoutPlanData>[];

    final oldWorkoutExcerciseData = <v1.WorkoutExcerciseData>[];
    final expectedNewWorkoutExcerciseData = <v2.WorkoutExcerciseData>[];

    final oldWorkoutLogsData = <v1.WorkoutLogsData>[];
    final expectedNewWorkoutLogsData = <v2.WorkoutLogsData>[];

    final oldExerciseLogsData = <v1.ExerciseLogsData>[];
    final expectedNewExerciseLogsData = <v2.ExerciseLogsData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.waterIntakes, oldWaterIntakesData);
        batch.insertAll(oldDb.user, oldUserData);
        batch.insertAll(oldDb.goal, oldGoalData);
        batch.insertAll(oldDb.preference, oldPreferenceData);
        batch.insertAll(oldDb.workoutPlan, oldWorkoutPlanData);
        batch.insertAll(oldDb.workoutExcercise, oldWorkoutExcerciseData);
        batch.insertAll(oldDb.workoutLogs, oldWorkoutLogsData);
        batch.insertAll(oldDb.exerciseLogs, oldExerciseLogsData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewWaterIntakesData,
          await newDb.select(newDb.waterIntakes).get(),
        );
        expect(expectedNewUserData, await newDb.select(newDb.user).get());
        expect(expectedNewGoalData, await newDb.select(newDb.goal).get());
        expect(
          expectedNewPreferenceData,
          await newDb.select(newDb.preference).get(),
        );
        expect(
          expectedNewWorkoutPlanData,
          await newDb.select(newDb.workoutPlan).get(),
        );
        expect(
          expectedNewWorkoutExcerciseData,
          await newDb.select(newDb.workoutExcercise).get(),
        );
        expect(
          expectedNewWorkoutLogsData,
          await newDb.select(newDb.workoutLogs).get(),
        );
        expect(
          expectedNewExerciseLogsData,
          await newDb.select(newDb.exerciseLogs).get(),
        );
      },
    );
  });
}
