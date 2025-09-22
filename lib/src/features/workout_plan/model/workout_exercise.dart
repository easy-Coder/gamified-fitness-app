import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class WorkoutExercise extends Equatable {
  final int? id;
  final int? planId;
  final Exercise exercise;
  final Duration? restTime;
  final int orderInWorkout;

  const WorkoutExercise({
    this.id,
    this.planId,
    this.orderInWorkout = 0,
    this.restTime,
    required this.exercise,
  });

  WorkoutExercise copyWith({
    int? id,
    int? planId,
    Exercise? exercise,
    Duration? restTime,
    int? orderInWorkout,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      exercise: exercise ?? this.exercise,
      restTime: restTime ?? this.restTime,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planId': planId,
      'exercise': exercise.toMap(),
      'restTime': restTime!.inMilliseconds,
      'orderInWorkout': orderInWorkout,
    };
  }

  static WorkoutExercise fromMap(Map<String, dynamic> map) {
    print(map['exercise']);
    return WorkoutExercise(
      id: map['id'] as int?,
      planId: map['planId'] as int?,
      exercise: map['exercise'],
      restTime: Duration(milliseconds: map['restTime'] as int),
      orderInWorkout: map['orderInWorkout'] as int,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static WorkoutExercise fromJson(String jsonString) {
    print("Here");
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutExercise.fromMap(map);
  }

  WorkoutExcerciseCompanion toCompanion() {
    return WorkoutExcerciseCompanion.insert(
      id: id != null ? Value(id!) : Value.absent(),
      planId: planId!,
      exercise: exercise,
      orderInWorkout: orderInWorkout,
      restTime: restTime!.inMilliseconds,
    );
  }

  @override
  List<Object?> get props => [id, planId, exercise, orderInWorkout, restTime];

  @override
  String toString() {
    return 'WorkoutExercise(id: $id, planId: $planId, exercise: $exercise, orderInWorkout: $orderInWorkout)';
  }
}
