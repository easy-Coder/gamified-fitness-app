import 'dart:convert';

import 'package:gamified/src/common/providers/db.dart';

extension type ExerciseLog._(
  ({
    int workoutLogId,
    String exerciseName,
    String exerciseType,
    int duration,
    int intensity,
    int caloriesBurned,
  })
  _
) {
  int get workoutLogId => _.workoutLogId;
  String get exerciseName => _.exerciseName;
  String get exerciseType => _.exerciseType;
  int get duration => _.duration;
  int get intensity => _.intensity;
  int get caloriesBurned => _.caloriesBurned;

  ExerciseLog({
    required int workoutLogId,
    required String exerciseName,
    required String exerciseType,
    required int duration,
    required int intensity,
    required int caloriesBurned,
  }) : this._((
         workoutLogId: workoutLogId,
         exerciseName: exerciseName,
         exerciseType: exerciseType,
         duration: duration,
         intensity: intensity,
         caloriesBurned: caloriesBurned,
       ));

  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutLogId,
      'exerciseName': exerciseName,
      'exerciseType': exerciseType,
      'duration': duration,
      'intensity': intensity,
      'caloriesBurned': caloriesBurned,
    };
  }

  static ExerciseLog fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      workoutLogId: map['workoutId'] as int,
      exerciseName: map['exerciseName'] as String,
      exerciseType: map['exerciseType'] as String,
      duration: map['duration'] as int,
      intensity: map['intensity'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
    );
  }

  static ExerciseLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExerciseLog.fromMap(map);
  }

  ExerciseLogsCompanion toCompanion() {
    return ExerciseLogsCompanion.insert(
      workoutLogId: workoutLogId,
      exerciseName: exerciseName,
      exerciseType: exerciseType,
      duration: duration,
      intensity: intensity,
      caloriesBurned: caloriesBurned,
    );
  }
}
