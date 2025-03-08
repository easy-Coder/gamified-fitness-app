import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

enum WorkoutType { strength, cardio, flexibility } // Example

// WorkoutLog Model and Drift Table
extension type WorkoutLogs._(
  ({
    int? workoutLogId,
    DateTime date,
    int? planId,
    int duration,
    int caloriesBurned,
    String bodyweight,
    bool isVisible,
    List<ExerciseLogs> exerciseLogs,
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
  List<ExerciseLogs> get exerciseLogs => _.exerciseLogs;

  WorkoutLogs({
    int? workoutLogId,
    required DateTime date,
    int? planId,
    required int duration,
    required int caloriesBurned,
    required String bodyweight,
    required List<ExerciseLogs> exerciseLogs,
    bool isVisible = true,
  }) : this._((
         workoutLogId: workoutLogId,
         date: date,
         planId: planId,
         duration: duration,
         caloriesBurned: caloriesBurned,
         bodyweight: bodyweight,
         isVisible: isVisible,
         exerciseLogs: exerciseLogs,
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

  static WorkoutLogs fromMap(Map<String, dynamic> map) {
    return WorkoutLogs(
      workoutLogId: map['workoutLogId'] as int?,
      date: DateTime.parse(map['date'] as String),
      planId: map['planId'] as int?,
      duration: map['duration'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
      bodyweight: map['bodyweight'] as String,
      isVisible: map['isVisible'] as bool,
      exerciseLogs: map['exerciseLogs'] as List<ExerciseLogs>,
    );
  }

  WorkoutLogs copyWith({
    int? workoutLogId,
    DateTime? date,
    int? planId,
    int? duration,
    int? caloriesBurned,
    String? bodyweight,
    List<ExerciseLogs>? exerciseLogs,
    bool? isVisible,
  }) {
    return WorkoutLogs(
      workoutLogId: workoutLogId ?? this.workoutLogId,
      date: date ?? this.date,
      planId: planId ?? this.planId,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      bodyweight: bodyweight ?? this.bodyweight,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static WorkoutLogs fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLogs.fromMap(map);
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
