import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/shared/workout_excercise/model/workout_excercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'workout_excercise_repository.g.dart';

class WorkoutExcerciseRepository {
  final SupabaseClient _client;

  WorkoutExcerciseRepository(this._client);

  Future<List<WorkoutExcercise>> getPlanWorkoutExcercises(int planId) async {
    try {
      final result = await _client.from('workout_exercises').select('''
            *,
            exercise:exercises(*)
          ''').eq('plan_id', planId);
      print(result);
      return result.map(WorkoutExcerciseMapper.fromMap).toList();
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occured. Try again later');
    }
  }

  Future<void> addWorkoutExcerciseToPlan(
      List<WorkoutExcercise> workoutExcercises) async {
    try {
      await _client.from('workout_exercises').insert(
            workoutExcercises.map((we) {
              print(we.toBody());
              return we.toBody()..remove('workout_exercise_id');
            }).toList(),
          );
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occure. Try again later');
    }
  }

  Future<void> deleteWorkoutExcercise(int workoutExcerciseId) async {
    try {
      await _client.from('workout_exercises').delete().eq(
            'workout_excercise_id',
            workoutExcerciseId,
          );
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occure. Try again later');
    }
  }
}

@riverpod
WorkoutExcerciseRepository workoutExcerciseRepo(WorkoutExcerciseRepoRef ref) {
  return WorkoutExcerciseRepository(ref.read(supabaseProvider));
}
