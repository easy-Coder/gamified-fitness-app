import 'package:gamified/src/features/excersice/model/excercise.dart';

extension type ExerciseResponse._(
  ({List<Exercise> exercises, int offset, bool haveMore, bool loadingMore}) _
) {
  List<Exercise> get exercises => _.exercises;
  int get offset => _.offset;
  bool get haveMore => _.haveMore;
  bool get loadingMore => _.loadingMore;

  ExerciseResponse({
    required List<Exercise> exercises,
    required int offset,
    required bool haveMore,
    bool loadingMore = false,
  }) : this._((
         exercises: exercises,
         offset: offset,
         haveMore: haveMore,
         loadingMore: loadingMore,
       ));

  ExerciseResponse copyWith({
    List<Exercise>? exercises,
    int? offset,
    bool? haveMore,
    bool? loadingMore,
  }) => ExerciseResponse(
    exercises: exercises ?? this.exercises,
    offset: offset ?? this.offset,
    haveMore: haveMore ?? this.haveMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}
