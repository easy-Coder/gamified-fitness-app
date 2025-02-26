import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

extension type WorkoutExercise._(
  ({int? id, int? planId, Exercise exercise, int orderInWorkout}) _
) {
  int? get id => _.id;
  int? get planId => _.planId;
  Exercise get exercise => _.exercise;
  int get orderInWorkout => _.orderInWorkout;

  WorkoutExercise({
    int? id,
    int? planId,
    int orderInWorkout = 0,
    required Exercise exercise,
  }) : this._((
         id: id,
         planId: planId,
         exercise: exercise,
         orderInWorkout: orderInWorkout,
       ));

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

  static WorkoutExercise fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutExercise.fromMap(map);
  }

  WorkoutExcerciseCompanion toCompanion() {
    return WorkoutExcerciseCompanion.insert(
      id: id != null ? Value(id!) : Value.absent(),
      planId: planId!,
      exercise: exercise,
      // Store exercise as json string
      orderInWorkout: orderInWorkout,
    );
  }
}
