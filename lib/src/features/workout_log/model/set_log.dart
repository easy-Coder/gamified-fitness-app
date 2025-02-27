import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';

extension type SetLogData._(
  ({
    int workoutLogId,
    String exerciseName,
    String weight,
    int reps,
    int? duration,
  })
  _
) {
  int get workoutLogId => _.workoutLogId;
  String get exerciseName => _.exerciseName;
  String get weight => _.weight;
  int get reps => _.reps;
  int? get duration => _.duration;

  SetLogData({
    required int workoutLogId,
    required String exerciseName,
    required String weight,
    required int reps,
    int? duration,
  }) : this._((
         workoutLogId: workoutLogId,
         exerciseName: exerciseName,
         weight: weight,
         reps: reps,
         duration: duration,
       ));

  Map<String, dynamic> toMap() {
    return {
      'workoutLogId': workoutLogId,
      'exerciseName': exerciseName,
      'weight': weight,
      'reps': reps,
      'duration': duration,
    };
  }

  static SetLogData fromMap(Map<String, dynamic> map) {
    return SetLogData(
      workoutLogId: map['workoutLogId'] as int,
      exerciseName: map['exerciseName'] as String,
      weight: map['weight'] as String,
      reps: map['reps'] as int,
      duration: map['duration'] as int?,
    );
  }

  static SetLogData fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return SetLogData.fromMap(map);
  }

  SetLogsCompanion toCompanion() {
    return SetLogsCompanion.insert(
      exerciseName: exerciseName,
      weight: weight,
      reps: reps,
      duration: Value(duration),
      workoutLogId: workoutLogId,
    );
  }
}
