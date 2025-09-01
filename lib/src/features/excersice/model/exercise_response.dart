import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class ExerciseResponse extends Equatable {
  final List<Exercise> exercises;
  final int offset;
  final bool haveMore;
  final bool loadingMore;

  const ExerciseResponse({
    required this.exercises,
    required this.offset,
    required this.haveMore,
    this.loadingMore = false,
  });

  ExerciseResponse copyWith({
    List<Exercise>? exercises,
    int? offset,
    bool? haveMore,
    bool? loadingMore,
  }) {
    return ExerciseResponse(
      exercises: exercises ?? this.exercises,
      offset: offset ?? this.offset,
      haveMore: haveMore ?? this.haveMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [exercises, offset, haveMore, loadingMore];

  @override
  String toString() {
    return 'ExerciseResponse(exercises: ${exercises.length} items, offset: $offset, haveMore: $haveMore, loadingMore: $loadingMore)';
  }
}
