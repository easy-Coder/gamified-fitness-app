import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'workout_log_repository.g.dart';

class WorkoutLogRepository {
  final SupabaseClient _client;

  WorkoutLogRepository(this._client);

  Future<List<WorkoutLog>> getUserWorkoutLogs(String userId) async {
    try {
      final result = await _client
          .from('workout_logs')
          .select()
          .eq('user_id', userId);
      return result.map(WorkoutLog.fromMap).toList();
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      throw Failure(message: 'Unexpected error occurred. Try Again');
    }
  }

  Future<void> addUserWorkoutLog(WorkoutLog workoutLog) async {
    try {
      await _client
          .from('workout_logs')
          .insert(
            workoutLog.toMap()
              ..remove('log_id')
              ..remove('completed_at'),
          );
    } on PostgrestException catch (error) {
      throw Failure(message: error.message);
    } catch (error) {
      throw Failure(message: 'Unexpected error occurred. Try Again');
    }
  }
}

@riverpod
WorkoutLogRepository workoutLogRepo(WorkoutLogRepoRef ref) {
  return WorkoutLogRepository(ref.read(supabaseProvider));
}
