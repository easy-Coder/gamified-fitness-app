import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/workout_log/schema/exercise_log.dart';
import 'package:isar_community/isar.dart';

class ExerciseLogsDTO extends Equatable {
  final Id? id;
  final String exerciseId;
  final int sets;
  final int? reps;
  final double? weight;
  final Duration? duration;
  final DateTime? createdAt;

  const ExerciseLogsDTO({
    this.id,
    required this.exerciseId,
    required this.sets,
    this.reps,
    this.weight,
    this.duration,
    this.createdAt,
  });

  ExerciseLogsDTO copyWith({
    Id? id,
    int? workoutLogId,
    String? exerciseId,
    int? sets,
    int? reps,
    double? weight,
    Duration? duration,
    DateTime? createdAt,
  }) {
    return ExerciseLogsDTO(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  ExerciseLogs toSchema() {
    return ExerciseLogs()
      ..id = id
      ..exerciseId = exerciseId
      ..sets = sets
      ..reps = reps
      ..weight = weight
      ..duration = duration?.inMilliseconds
      ..createdAt = createdAt ?? DateTime.now();
  }

  factory ExerciseLogsDTO.fromSchema(ExerciseLogs log) {
    return ExerciseLogsDTO(
      id: log.id,
      exerciseId: log.exerciseId,
      sets: log.sets,
      reps: log.reps,
      weight: log.weight,
      duration: log.duration != null
          ? Duration(milliseconds: log.duration!)
          : null,
      createdAt: log.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration?.inMilliseconds,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ExerciseLogsDTO.fromMap(Map<String, dynamic> map) {
    return ExerciseLogsDTO(
      id: map['id'] as Id?,
      exerciseId: map['exerciseId'] as String,
      sets: map['sets'] as int,
      reps: map['reps'] as int?,
      weight: map['weight'] as double?,
      duration: map['duration'] != null
          ? Duration(milliseconds: map['duration'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseLogsDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExerciseLogsDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    sets,
    reps,
    weight,
    duration,
    createdAt,
  ];

  @override
  String toString() =>
      'ExerciseLogsDTO(id: $id, exerciseId: $exerciseId, sets: $sets)';
}
