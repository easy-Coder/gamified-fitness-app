import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:logger/logger.dart';

class WorkoutPlanRepository {
  late final AppDatabase _db;
  late final Logger _logger;

  WorkoutPlanRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

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
    } on DriftWrappedException catch (error) {
      _logger.e(error.message, error: error, stackTrace: error.trace);

      throw Failure(message: error.message);
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
    } on DriftWrappedException catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.trace);

      throw Failure(message: e.message);
    } catch (error) {
      throw Failure(message: 'Something went wrong. Please try again');
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
    } on DriftWrappedException catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.trace);

      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e.toString(), error: e);

      throw Failure(message: 'Something went wrong. Please try again');
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

final workoutPlanRepoProvider = Provider((ref) => WorkoutPlanRepository(ref));

final workoutPlansProvider = StreamProvider.autoDispose<List<WorkoutPlan>>(
  (ref) => ref.read(workoutPlanRepoProvider).getUserPlans(),
);
