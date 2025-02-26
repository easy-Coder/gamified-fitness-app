import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'excercise_controller.g.dart';

@riverpod
class ExcerciseController extends _$ExcerciseController {
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
