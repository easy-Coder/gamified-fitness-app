import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

enum WorkoutType { strength, cardio, flexibility }

class WorkoutLog extends Equatable {
  final int? id;
  final int planId;
  final Duration duration;
  final DateTime? workoutDate;
  final List<ExercisesLog> exerciseLogs;

  const WorkoutLog({
    this.id,
    required this.planId,
    required this.duration,
    this.workoutDate,
    required this.exerciseLogs,
  });

  WorkoutLog copyWith({
    int? id,
    int? planId,
    Duration? duration,
    DateTime? workoutDate,
    List<ExercisesLog>? exerciseLogs,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      duration: duration ?? this.duration,
      workoutDate: workoutDate ?? this.workoutDate,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planId': planId, // Fixed: was 'planName' but should be 'planId'
      'duration': duration.inMilliseconds,
      'workoutDate': workoutDate?.millisecondsSinceEpoch,
      'exerciseLogs': exerciseLogs.map((e) => e.toMap()).toList(),
    };
  }

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'] as int?,
      planId: map['planId'] as int,
      duration: Duration(milliseconds: map['duration'] as int),
      workoutDate: map['workoutDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['workoutDate'] as int)
          : null,
      exerciseLogs:
          (map['exerciseLogs'] as List<dynamic>?)
              ?.map((e) => ExercisesLog.fromMap(e as Map<String, dynamic>))
              .toList() ??
          <ExercisesLog>[],
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static WorkoutLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLog.fromMap(map);
  }

  WorkoutLogsCompanion toCompanion() {
    return WorkoutLogsCompanion.insert(
      planId: planId,
      duration: duration.inMilliseconds,
      workoutDate: Value(workoutDate ?? DateTime.now()),
    );
  }

  @override
  List<Object?> get props => [id, planId, duration, workoutDate, exerciseLogs];

  @override
  String toString() {
    return 'WorkoutLog(id: $id, planId: $planId, duration: $duration, workoutDate: $workoutDate, exerciseLogs: $exerciseLogs)';
  }
}
