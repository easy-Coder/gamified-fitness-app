import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

enum WorkoutType { strength, cardio, flexibility }

extension type WorkoutLog._(
  ({
    int? id,
    int planId,
    Duration duration,
    DateTime? workoutDate,
    List<ExercisesLog> exerciseLogs,
  })
  _
) {
  int? get id => _.id;
  int get planId => _.planId;
  Duration get duration => _.duration;
  DateTime? get workoutDate => _.workoutDate;
  List<ExercisesLog> get exerciseLogs => _.exerciseLogs;

  WorkoutLog({
    int? id,
    required int planId,
    required Duration duration,
    DateTime? workoutDate,
    required List<ExercisesLog> exerciseLogs,
  }) : this._((
         id: id,
         planId: planId,
         duration: duration,
         workoutDate: workoutDate,
         exerciseLogs: exerciseLogs,
       ));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planName': planId,
      'duration': duration,
      'workoutDate': workoutDate,
      'exerciseLogs': exerciseLogs,
    };
  }

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'] as int?,
      planId: map['planId'] as int,
      duration: map['duration'] as Duration,
      exerciseLogs: map['exerciseLogs'] as List<ExercisesLog>,
      workoutDate: map['workoutDate'] as DateTime,
    );
  }

  static WorkoutLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLog.fromMap(map);
  }

  WorkoutLogsCompanion toCompanion() {
    return WorkoutLogsCompanion.insert(
      planId: planId,
      duration: duration.inMilliseconds,
      workoutDate: Value.absent(),
    );
  }
}
