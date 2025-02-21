import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class WorkoutPlanRepository {
  final AppDatabase _db;

  WorkoutPlanRepository(this._db);

  Stream<List<WorkoutPlanData>> getUserPlans() {
    final result = _db.select(_db.workoutPlan).watch();
    return result;
  }

  Future<WorkoutPlanData?> getUserWorkoutPlanByDay(DaysOfWeek day) async {
    final result =
        await (_db.select(_db.workoutPlan)
          ..where((row) => row.dayOfWeek.isValue(day.index))).getSingleOrNull();
    return result;
  }

  Future<WorkoutPlanData> getWorkoutPlanById(int planId) async {
    final result =
        (_db.select(_db.workoutPlan)
          ..where((row) => row.id.isValue(planId))).getSingle();
    return result;
  }

  Future<int> createUserPlan(WorkoutPlanCompanion plan) async {
    final result = await (_db.into(_db.workoutPlan).insert(plan));
    return result;
  }
}

final workoutPlanRepoProvider = Provider(
  (ref) => WorkoutPlanRepository(ref.read(dbProvider)),
);

final workoutPlansProvider = StreamProvider.autoDispose<List<WorkoutPlanData>>(
  (ref) => ref.read(workoutPlanRepoProvider).getUserPlans(),
);

final workoutPlanProvider = FutureProvider.family<WorkoutPlanData, int>(
  (ref, id) => ref.read(workoutPlanRepoProvider).getWorkoutPlanById(id),
);
