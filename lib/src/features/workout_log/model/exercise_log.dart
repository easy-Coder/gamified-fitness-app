import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';

class ExercisesLog extends Equatable {
  final int? id;
  final Duration? duration;
  final int set;
  final int? reps;
  final double? weight;
  final int? workoutLogId;
  final String exerciseId;

  const ExercisesLog({
    this.id,
    this.duration,
    required this.set,
    this.reps,
    this.weight,
    this.workoutLogId,
    required this.exerciseId,
  });

  ExercisesLog copyWith({
    int? id,
    Duration? duration,
    int? set,
    int? reps,
    double? weight,
    int? workoutLogId,
    String? exerciseId,
  }) {
    return ExercisesLog(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      set: set ?? this.set,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  static ExercisesLog fromMap(Map<String, dynamic> map) {
    return ExercisesLog(
      id: map['id'] as int?,
      duration: map['duration'] as Duration?,
      set: map['set'] as int,
      reps: map['reps'] as int?,
      weight: map['weight'] as double?,
      workoutLogId: map['workoutLogId'] as int?,
      exerciseId: map['exerciseId'] as String,
    );
  }

  static ExercisesLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExercisesLog.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duration': duration?.inMilliseconds,
      'set': set,
      'reps': reps,
      'weight': weight,
      'workoutLogId': workoutLogId,
      'exerciseId': exerciseId,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  ExerciseLogsCompanion toCompanion() {
    return ExerciseLogsCompanion.insert(
      workoutLogId: workoutLogId!,
      exerciseId: exerciseId,
      duration: Value.absentIfNull(duration?.inMilliseconds),
      sets: set,
      weight: Value(weight),
      reps: Value(reps),
    );
  }

  @override
  List<Object?> get props => [
    id,
    duration,
    set,
    reps,
    weight,
    workoutLogId,
    exerciseId,
  ];

  @override
  String toString() {
    return 'ExercisesLog(id: $id, duration: $duration, set: $set, reps: $reps, weight: $weight, workoutLogId: $workoutLogId, exerciseId: $exerciseId)';
  }
}
