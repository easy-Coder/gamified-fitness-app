import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift/remote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

class WorkoutPlanRepository {
  final AppDatabase _db;

  WorkoutPlanRepository(this._db);

  Stream<List<WorkoutPlan>> getUserPlans() {
    try {
      final result = _db.select(_db.workoutPlan).watch();
      return result.map(
        (workoutPlans) => workoutPlans
            .map(
              (workoutPlan) => WorkoutPlan.fromJson(workoutPlan.toJsonString()),
            )
            .toList(),
      );
    } on DriftRemoteException catch (error) {
      throw Failure(message: error.remoteCause.toString());
    } catch (error) {
      throw Failure(message: 'Something went wrong. Please try again');
    }
  }

  Future<WorkoutPlan?> getUserWorkoutPlanByDay(DaysOfWeek day) async {
    try {
      final result = await (_db.select(
        _db.workoutPlan,
      )..where((row) => row.dayOfWeek.isValue(day.index))).getSingleOrNull();
      return result != null
          ? WorkoutPlan.fromJson(result.toJsonString())
          : null;
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<WorkoutPlan> getWorkoutPlanById(int planId) async {
    final result = await (_db.select(
      _db.workoutPlan,
    )..where((row) => row.id.equals(planId))).getSingle();

    return WorkoutPlan.fromJson(result.toJsonString());
  }

  Future<int> createUserPlan(WorkoutPlan plan) async {
    try {
      return await (_db.into(_db.workoutPlan).insert(plan.toCompanion()));
    } on DriftRemoteException catch (e) {
      // Handle Drift-specific exceptions
      throw Failure(message: 'Database error: ${e.remoteCause}');
    } on SqliteException catch (e) {
      throw Failure(message: 'Sqlite Error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> updateWorkoutPlan(WorkoutPlan updatedPlan) async {
    await (_db.update(_db.workoutPlan)
          ..where((tbl) => tbl.id.equals(updatedPlan.id!)))
        .write(updatedPlan.toCompanion());
  }

  Future<void> deleteWorkoutPlan(WorkoutPlan plan) async {
    await (_db.delete(
      _db.workoutPlan,
    )..where((tbl) => tbl.id.equals(plan.id!))).go();
  }
}

final workoutPlanRepoProvider = Provider(
  (ref) => WorkoutPlanRepository(ref.read(dbProvider)),
);

final workoutPlansProvider = StreamProvider.autoDispose<List<WorkoutPlan>>(
  (ref) => ref.read(workoutPlanRepoProvider).getUserPlans(),
);
