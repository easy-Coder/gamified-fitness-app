import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExcerciseRepository {
  final SupabaseClient _client;

  const ExcerciseRepository(this._client);

  Future<List<Exercise>> getAllExcercise(
    String query, [
    Map<String, dynamic> options = const {},
  ]) async {
    try {
      final result = await _client
          .from('exercises')
          .select()
          .textSearch('name', query, config: 'english');
      print(result);
      return result.map((excercise) => Exercise.fromMap(excercise)).toList();
    } on PostgrestException catch (error) {
      print(error);
      throw Failure(message: error.message);
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occure. Try again later');
    }
  }
}

final excerciseRepositoryProvider = Provider((ref) {
  return ExcerciseRepository(ref.read(supabaseProvider));
});
