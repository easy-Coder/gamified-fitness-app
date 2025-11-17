import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class WorkoutPlanRepository {
  late final Isar _db;
  late final Logger _logger;

  WorkoutPlanRepository(Ref ref) {
    _db = ref.read(dbProvider);
    _logger = ref.read(loggerProvider);
  }

  Stream<List<WorkoutPlanDTO>> getUserPlans() {
    try {
      final result = _db.workoutPlans.where().watch(fireImmediately: true);
      return result.map(
        (workoutPlans) => workoutPlans
            .map((workoutPlan) => WorkoutPlanDTO.fromSchema(workoutPlan))
            .toList(),
      );
    } catch (error) {
      throw Failure(message: 'Something went wrong. Please try again');
    }
  }


  Future<WorkoutPlanDTO> getWorkoutPlanById(int planId) async {
    final result = await _db.workoutPlans.get(planId);
    if (result == null) {
      throw Failure(message: "No Workout Plan here");
    }
    return WorkoutPlanDTO.fromSchema(result);
  }

  Future<int> createUserPlan(WorkoutPlanDTO plan) async {
    try {
      return await _db.writeTxn(() async {
        return await _db.workoutPlans.put(plan.toSchema());
      });
    } on IsarError catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.stackTrace);

      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e.toString(), error: e);

      throw Failure(message: 'Something went wrong. Please try again');
    }
  }

  Future<void> updateWorkoutPlan(WorkoutPlanDTO updatedPlan) async {
    try {
      await _db.writeTxn(() async {
        await _db.workoutPlans.put(updatedPlan.toSchema());
      });
    } on IsarError catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.stackTrace);

      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e.toString(), error: e);

      throw Failure(message: 'Something went wrong. Please try again');
    }
  }

  Future<bool> deleteWorkoutPlan(WorkoutPlanDTO plan) async {
    try {
      return await _db.writeTxn(() async {
        return await _db.workoutPlans.delete(plan.id!);
      });
    } on IsarError catch (e) {
      _logger.e(e.message, error: e, stackTrace: e.stackTrace);

      throw Failure(message: e.message);
    } catch (e) {
      _logger.e(e.toString(), error: e);

      throw Failure(message: 'Something went wrong. Please try again');
    }
  }
}

final workoutPlanRepoProvider = Provider((ref) => WorkoutPlanRepository(ref));

final workoutPlansProvider = StreamProvider.autoDispose<List<WorkoutPlanDTO>>(
  (ref) => ref.read(workoutPlanRepoProvider).getUserPlans(),
);
