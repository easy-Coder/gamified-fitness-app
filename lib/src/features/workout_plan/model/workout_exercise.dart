import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_exercise.dart';
import 'package:isar_community/isar.dart';

class WorkoutExerciseDTO extends Equatable {
  final int? id;
  final ExerciseDTO exercise;
  final Duration? restTime;
  final int orderInWorkout;

  const WorkoutExerciseDTO({
    this.id,
    required this.exercise,
    this.restTime,
    this.orderInWorkout = 0,
  });

  WorkoutExerciseDTO copyWith({
    ExerciseDTO? exercise,
    Duration? restTime,
    int? orderInWorkout,
  }) {
    return WorkoutExerciseDTO(
      id: id,
      exercise: exercise ?? this.exercise,
      restTime: restTime ?? this.restTime,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
    );
  }

  WorkoutExercise toSchema() {
    return WorkoutExercise()
      ..id = id
      ..exercise = exercise.toSchema()
      ..restTime = restTime?.inMilliseconds ?? 0
      ..orderInWorkout = orderInWorkout;
  }

  factory WorkoutExerciseDTO.fromSchema(WorkoutExercise we) {
    return WorkoutExerciseDTO(
      id: we.id,
      exercise: ExerciseDTO.fromSchema(we.exercise),
      restTime: we.restTime == null
          ? null
          : Duration(milliseconds: we.restTime!),
      orderInWorkout: we.orderInWorkout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise': exercise.toMap(),
      'restTime': restTime?.inMilliseconds ?? 0,
      'orderInWorkout': orderInWorkout,
    };
  }

  factory WorkoutExerciseDTO.fromMap(Map<String, dynamic> map) {
    return WorkoutExerciseDTO(
      id: map['id'] as Id?,
      exercise: ExerciseDTO.fromMap(map['exercise'] as Map<String, dynamic>),
      restTime: Duration(milliseconds: map['restTime'] as int),
      orderInWorkout: map['orderInWorkout'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutExerciseDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutExerciseDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, exercise, restTime, orderInWorkout];

  @override
  String toString() => 'WorkoutExerciseDTO(id: $id,)';
}
