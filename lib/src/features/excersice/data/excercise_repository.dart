import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/config/environment_config.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:http/http.dart' as http;

class ExcerciseRepository {
  const ExcerciseRepository();

  Future<(Map<String, dynamic>, List<Exercise>)> getAllExercise(
    String? search, {
    int offset = 0,
  }) async {
    try {
      final result = await http.get(
        Uri.https(AppConfig.exerciseBaseUrl, "/api/v1/exercises", {
          if (search != null) "search": search,
          "offset": offset.toString(),
        }),
      );

      if (result.statusCode != 200) {
        throw Failure(
          message: "Failed to get exercises: ${result.reasonPhrase}",
        );
      }

      // First decode as List<dynamic>
      final jsonList = convert.jsonDecode(result.body) as Map<String, dynamic>;

      // Then convert each item to Map<String, dynamic>
      final List data = jsonList["data"];

      return (
        jsonList["metadata"] as Map<String, dynamic>,
        data.map((exercise) => Exercise.fromMap(exercise)).toList(),
      );
    } catch (error) {
      throw Failure(message: 'Unexpected error occurred. Try again later');
    }
  }

  Future<Exercise> getExercise(String id) async {
    final result = await http.get(
      Uri.https(AppConfig.exerciseBaseUrl, "/api/v1/exercises/$id"),
    );

    if (result.statusCode != 200) {
      throw Failure(message: "Failed to get exercise: ${result.reasonPhrase}");
    }

    final jsonList = convert.jsonDecode(result.body) as Map<String, dynamic>;

    final Map<String, dynamic> data = jsonList["data"];

    return Exercise.fromMap(data);
  }
}

final exerciseRepositoryProvider = Provider((ref) {
  return ExcerciseRepository();
});

final exerciseDetailsProvider = FutureProvider.family<Exercise, String>(
  (ref, id) => ref.read(exerciseRepositoryProvider).getExercise(id),
);
