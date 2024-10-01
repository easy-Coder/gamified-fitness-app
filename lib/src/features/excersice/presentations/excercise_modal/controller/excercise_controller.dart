import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'excercise_controller.g.dart';

@riverpod
class ExcerciseController extends _$ExcerciseController {
  int _offsetStart = 0;
  int _itemsPerPage = 19;
  bool _hasMoreItems = true;
  bool get hasMoreItems => _hasMoreItems;
  Map<String, dynamic> _options = const {};

  @override
  Future<List<Excercise>> build() async {
    return _getAllExcercise();
  }

  Future<List<Excercise>> _getAllExcercise() async {
    final result = await ref
        .read(excerciseRepositoryProvider)
        .getAllExcercise(_offsetStart, _itemsPerPage, _options);
    if (result.isEmpty) {
      _hasMoreItems = false;
    } else {
      _offsetStart = _itemsPerPage;
      _itemsPerPage += 20;
    }
    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMoreItems) return;

    // state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final previousState = await future;
      final newState = await _getAllExcercise();
      return [...previousState, ...newState];
    });
  }

  Future<void> search(Map<String, dynamic> query) async {
    ref.invalidateSelf();
    _options = query.isNotEmpty ? query : {};
    _offsetStart = 0;
    _itemsPerPage = 20;
    _hasMoreItems = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getAllExcercise);
  }
}
