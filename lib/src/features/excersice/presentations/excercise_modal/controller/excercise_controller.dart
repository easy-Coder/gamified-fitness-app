import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class ExcerciseController extends AsyncNotifier {
  @override
  Future<List<Exercise>> build() async {
    return _getAllExercises();
  }

  Future<void> searchExercise(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Handle empty query - return all exercises
      if (query.trim().isEmpty) {
        return await _getAllExercises();
      }

      // Perform the search - this could be from various sources
      final results = await _performSearch(query);
      return results;
    });
  }

  // Helper method to perform the actual search
  Future<List<Exercise>> _performSearch(String query) async {
    final allExercises = await _getAllExercises();
    return allExercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
          exercise.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Additional helper method if searching from cached data
  Future<List<Exercise>> _getAllExercises() async {
    final exercises =
        await ref.read(excerciseRepositoryProvider).getAllExercise();
    print(exercises);
    return exercises; // Replace with actual data source
  }
}

final exerciseControllerProvider = AsyncNotifierProvider(
  ExcerciseController.new,
);
