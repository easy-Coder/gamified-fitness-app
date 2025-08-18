import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:http/http.dart' as http;

class ExcerciseRepository {
  const ExcerciseRepository();

  Future<List<Exercise>> getAllExercise() async {
    try {
      final result = await http.get(
        Uri.parse("https://rankupfit-server.onrender.com/"),
      );
      if (result.statusCode != 200) {
        throw Failure(
          message: "Failed to get exercise: ${result.reasonPhrase}",
        );
      }

      // First decode as List<dynamic>
      final jsonList = convert.jsonDecode(result.body) as List<dynamic>;

      // Then convert each item to Map<String, dynamic>
      final data =
          jsonList.map((item) => item as Map<String, dynamic>).toList();

      return data.map((exercise) => Exercise.fromMap(exercise)).toList();
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occurred. Try again later');
    }
  }
}

final excerciseRepositoryProvider = Provider((ref) {
  return ExcerciseRepository();
});
