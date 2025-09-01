import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class WorkoutExercise extends Equatable {
  final int? id;
  final int? planId;
  final Exercise exercise;
  final int orderInWorkout;

  const WorkoutExercise({
    this.id,
    this.planId,
    this.orderInWorkout = 0,
    required this.exercise,
  });

  WorkoutExercise copyWith({
    int? id,
    int? planId,
    Exercise? exercise,
    int? orderInWorkout,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      exercise: exercise ?? this.exercise,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plan_id': planId,
      'exercise': exercise.toMap(),
      'order_in_workout': orderInWorkout,
    };
  }

  static WorkoutExercise fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'] as int?,
      planId: map['plan_id'] as int?,
      exercise: Exercise.fromMap(map['exercise'] as Map<String, dynamic>),
      orderInWorkout: map['order_in_workout'] as int,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static WorkoutExercise fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutExercise.fromMap(map);
  }

  WorkoutExcerciseCompanion toCompanion() {
    return WorkoutExcerciseCompanion.insert(
      id: id != null ? Value(id!) : Value.absent(),
      planId: planId!,
      exercise: exercise,
      orderInWorkout: orderInWorkout,
    );
  }

  @override
  List<Object?> get props => [id, planId, exercise, orderInWorkout];

  @override
  String toString() {
    return 'WorkoutExercise(id: $id, planId: $planId, exercise: $exercise, orderInWorkout: $orderInWorkout)';
  }
}
