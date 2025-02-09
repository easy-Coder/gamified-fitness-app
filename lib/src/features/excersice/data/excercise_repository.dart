import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'excercise_repository.g.dart';

class ExcerciseRepository {
  final SupabaseClient _client;

  const ExcerciseRepository(this._client);

  Future<List<Excercise>> getAllExcercise(
    String query, [
    Map<String, dynamic> options = const {},
  ]) async {
    try {
      final result = await _client.from('exercises').select().textSearch(
            'name',
            query,
            config: 'english',
          );
      print(result);
      return result
          .map(
            (excercise) => ExcerciseMapper.fromMap(excercise),
          )
          .toList();
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
ExcerciseRepository excerciseRepository(ExcerciseRepositoryRef ref) {
  return ExcerciseRepository(ref.read(supabaseProvider));
}
