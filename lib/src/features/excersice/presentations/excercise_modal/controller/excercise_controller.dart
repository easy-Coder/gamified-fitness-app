import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class ExcerciseController extends AsyncNotifier {
  final Map<String, dynamic> _options = const {};

  @override
  Future<List<Exercise>> build() async {
    return [];
  }

  Future<void> searchExcercise(String query) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async => ref
          .read(excerciseRepositoryProvider)
          .getAllExcercise(query, _options),
    );
  }
}

final exerciseControllerProvider = AsyncNotifierProvider(
  ExcerciseController.new,
);
