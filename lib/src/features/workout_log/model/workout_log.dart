import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';

enum WorkoutType { strength, cardio, flexibility } // Example

// WorkoutLog Model and Drift Table
extension type WorkoutLog._(
  ({
    int planId,
    int duration,
    int caloriesBurned,
    String bodyweight,
    int? avgHeartRate,
  })
  _
) {
  int get planId => _.planId;
  int get duration => _.duration;
  int get caloriesBurned => _.caloriesBurned;
  String get bodyweight => _.bodyweight;
  int? get avgHeartRate => _.avgHeartRate;

  WorkoutLog({
    required int planId,
    required int duration,
    required int caloriesBurned,
    required String bodyweight,
    int? avgHeartRate,
  }) : this._((
         planId: planId,
         duration: duration,
         caloriesBurned: caloriesBurned,
         bodyweight: bodyweight,
         avgHeartRate: avgHeartRate,
       ));

  Map<String, dynamic> toMap() {
    return {
      'planName': planId,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'bodyweight': bodyweight,
      'avgHeartRate': avgHeartRate,
    };
  }

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      planId: map['planId'] as int,
      duration: map['duration'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
      bodyweight: map['bodyweight'] as String,
      avgHeartRate: map['avgHeartRate'] as int?,
    );
  }

  static WorkoutLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLog.fromMap(map);
  }

  WorkoutLogsCompanion toCompanion() {
    return WorkoutLogsCompanion.insert(
      planId: planId,
      duration: duration,
      caloriesBurned: caloriesBurned,
      bodyweight: bodyweight,
      avgHeartRate: Value(avgHeartRate!),
    );
  }
}
