import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/exercise_response.dart';

class ExcerciseController extends AsyncNotifier<ExerciseResponse> {
  // Store the current query
  String? _query;

  @override
  Future<ExerciseResponse> build() async {
    // Initial fetch with no query and offset 0
    _query = null;
    return _getAllExercises(query: null, offset: 0);
  }

  /// Fetches the next page of exercises.
  Future<void> loadMore() async {
    // Get the current state. If we are already loading more, or have no more
    // data, or are not in a success state, just return.
    final currentState = state.value;
    if (state.hasError || currentState!.loadingMore || !currentState.haveMore) {
      return;
    }

    // Set the loadingMore flag to true and update the state
    state = AsyncData(currentState.copyWith(loadingMore: true));

    try {
      // Fetch the next batch of exercises
      final newExercisesResponse = await _getAllExercises(
        query: _query,
        offset: currentState.offset,
      );

      // Append new exercises to the existing list and update the state
      state = AsyncData(
        currentState.copyWith(
          exercises: [
            ...currentState.exercises,
            ...newExercisesResponse.exercises,
          ],
          haveMore: newExercisesResponse.haveMore,
          loadingMore: false,
        ),
      );
    } catch (e, st) {
      // In case of error, revert the loadingMore flag and set state to error
      debugPrintStack(stackTrace: st);
      state = AsyncError(e, st);
    }
  }

  /// Triggers a new search, resetting the pagination.
  Future<void> search(String? query) async {
    // Set the state to loading
    state = const AsyncLoading();
    _query = query;
    // Fetch the first page with the new query
    state = await AsyncValue.guard(
      () => _getAllExercises(query: _query, offset: 0),
    );
  }

  /// Helper method to fetch data from the repository.
  Future<ExerciseResponse> _getAllExercises({
    required String? query,
    required int offset,
  }) async {
    // NOTE: Assumes your repository method accepts 'query' and 'offset'.
    // You may need to adjust this call to match your actual repository signature.
    final exercisesTuple = await ref
        .read(exerciseRepositoryProvider)
        .getAllExercise(query, offset: offset);

    // The tuple from the repository is assumed to be:
    // (Map<String, dynamic> metadata, List<Exercise> exercises)
    final metadata = exercisesTuple.$1;
    final exercises = exercisesTuple.$2;

    // The 'next' field is often a full URL or null. We check for its presence.
    final nextUrl = metadata["nextPage"] as String?;

    return ExerciseResponse(
      exercises: exercises,
      // The new offset should come from the API response for the next page
      offset: offset + exercises.length,
      haveMore: nextUrl != null && nextUrl.isNotEmpty,
    );
  }
}

final exerciseControllerProvider =
    AsyncNotifierProvider<ExcerciseController, ExerciseResponse>(
      ExcerciseController.new,
    );
