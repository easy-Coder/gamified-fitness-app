import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'workout_plan_repository.g.dart';

class WorkoutPlanRepository {
  final SupabaseClient _client;

  WorkoutPlanRepository(this._client);

  Future<List<WorkoutPlan>> getUserPlans(String userId) async {
    try {
      final result =
          await _client.from('workout_plans').select().eq('user_id', userId);
      return result.map(WorkoutPlanMapper.fromMap).toList();
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occured. Try again later');
    }
  }

  Future<WorkoutPlan> getWorkPlan(int planId) async {
    try {
      final result = await _client
          .from('workout_plans')
          .select()
          .eq('plan_id', planId)
          .single();
      return WorkoutPlanMapper.fromMap(result);
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occured. Try again later');
    }
  }

  Future<WorkoutPlan> createUserPlan(WorkoutPlan plan) async {
    try {
      print(plan.toJson());
      final result = await _client
          .from('workout_plans')
          .insert(plan.toMap()..remove('plan_id'))
          .select();
      return WorkoutPlanMapper.fromMap(result[0]);
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occured. Try again later');
    }
  }
}

@riverpod
WorkoutPlanRepository workoutPlanRepo(WorkoutPlanRepoRef ref) {
  return WorkoutPlanRepository(ref.read(supabaseProvider));
}
