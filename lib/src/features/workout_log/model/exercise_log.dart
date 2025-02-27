import 'dart:convert';

import 'package:gamified/src/common/providers/db.dart';

extension type ExerciseLogData._(
  ({
    DateTime workoutDate,
    String exerciseName,
    String exerciseType,
    int duration,
    int intensity,
    int caloriesBurned,
  })
  _
) {
  DateTime get workoutDate => _.workoutDate;
  String get exerciseName => _.exerciseName;
  String get exerciseType => _.exerciseType;
  int get duration => _.duration;
  int get intensity => _.intensity;
  int get caloriesBurned => _.caloriesBurned;

  ExerciseLogData({
    required DateTime workoutDate,
    required String exerciseName,
    required String exerciseType,
    required int duration,
    required int intensity,
    required int caloriesBurned,
  }) : this._((
         workoutDate: workoutDate,
         exerciseName: exerciseName,
         exerciseType: exerciseType,
         duration: duration,
         intensity: intensity,
         caloriesBurned: caloriesBurned,
       ));

  Map<String, dynamic> toMap() {
    return {
      'workoutDate': workoutDate.toIso8601String(),
      'exerciseName': exerciseName,
      'exerciseType': exerciseType,
      'duration': duration,
      'intensity': intensity,
      'caloriesBurned': caloriesBurned,
    };
  }

  static ExerciseLogData fromMap(Map<String, dynamic> map) {
    return ExerciseLogData(
      workoutDate: DateTime.parse(map['workoutDate'] as String),
      exerciseName: map['exerciseName'] as String,
      exerciseType: map['exerciseType'] as String,
      duration: map['duration'] as int,
      intensity: map['intensity'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
    );
  }

  static ExerciseLogData fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExerciseLogData.fromMap(map);
  }

  ExerciseLogsCompanion toCompanion() {
    return ExerciseLogsCompanion.insert(
      workoutDate: workoutDate,
      exerciseName: exerciseName,
      exerciseType: exerciseType,
      duration: duration,
      intensity: intensity,
      caloriesBurned: caloriesBurned,
    );
  }
}
