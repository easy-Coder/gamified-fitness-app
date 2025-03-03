import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';

enum WorkoutType { strength, cardio, flexibility } // Example

// WorkoutLog Model and Drift Table
extension type WorkoutLog._(
  ({
    int? workoutLogId,
    DateTime date,
    int? planId,
    int duration,
    int caloriesBurned,
    String bodyweight,
    bool isVisible,
  })
  _
) {
  int? get workoutLogId => _.workoutLogId;
  DateTime get date => _.date;
  int? get planId => _.planId;
  int get duration => _.duration;
  int get caloriesBurned => _.caloriesBurned;
  String get bodyweight => _.bodyweight;
  bool get isVisible => _.isVisible;

  WorkoutLog({
    int? workoutLogId,
    required DateTime date,
    int? planId,
    required int duration,
    required int caloriesBurned,
    required String bodyweight,
    bool isVisible = true,
  }) : this._((
         workoutLogId: workoutLogId,
         date: date,
         planId: planId,
         duration: duration,
         caloriesBurned: caloriesBurned,
         bodyweight: bodyweight,
         isVisible: isVisible,
       ));

  Map<String, dynamic> toMap() {
    return {
      'workoutLogId': workoutLogId,
      'date': date.toIso8601String(),
      'planId': planId,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'bodyweight': bodyweight,
      'isVisible': isVisible,
    };
  }

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      workoutLogId: map['workoutLogId'] as int?,
      date: DateTime.parse(map['date'] as String),
      planId: map['planId'] as int?,
      duration: map['duration'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
      bodyweight: map['bodyweight'] as String,
      isVisible: map['isVisible'] as bool,
    );
  }

  static WorkoutLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLog.fromMap(map);
  }

  WorkoutLogsCompanion toCompanion() {
    return WorkoutLogsCompanion.insert(
      id: workoutLogId != null ? Value(workoutLogId!) : const Value.absent(),
      date: date,
      planId: planId != null ? Value(planId!) : const Value.absent(),
      duration: duration,
      caloriesBurned: caloriesBurned,
      bodyweight: bodyweight,
      isVisible: Value(isVisible),
    );
  }
}
