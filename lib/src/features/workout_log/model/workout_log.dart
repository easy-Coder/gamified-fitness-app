import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/schema/workout_log.dart';
import 'package:isar_community/isar.dart';

enum WorkoutType { strength, cardio, flexibility }

class WorkoutLogsDTO extends Equatable {
  final Id? id;
  final int planId;
  final Duration duration;
  final DateTime? workoutDate;
  final List<ExerciseLogsDTO> exerciseLogs;

  const WorkoutLogsDTO({
    this.id,
    required this.planId,
    required this.duration,
    this.workoutDate,
    this.exerciseLogs = const [],
  });

  WorkoutLogsDTO copyWith({
    Id? id,
    int? planId,
    Duration? duration,
    DateTime? workoutDate,
    List<ExerciseLogsDTO>? exerciseLogs,
  }) {
    return WorkoutLogsDTO(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      duration: duration ?? this.duration,
      workoutDate: workoutDate ?? this.workoutDate,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
    );
  }

  WorkoutLogs toSchema() {
    return WorkoutLogs()
      ..id = id
      ..planId = planId
      ..duration = duration.inMilliseconds
      ..workoutDate = workoutDate?.date ?? DateTime.now().date;
  }

  factory WorkoutLogsDTO.fromSchema(WorkoutLogs log) {
    return WorkoutLogsDTO(
      id: log.id,
      planId: log.planId,
      duration: Duration(milliseconds: log.duration),
      workoutDate: log.workoutDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planId': planId,
      'duration': duration.inMilliseconds,
      'workoutDate': workoutDate?.millisecondsSinceEpoch,
      'exerciseLogs': exerciseLogs.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutLogsDTO.fromMap(Map<String, dynamic> map) {
    return WorkoutLogsDTO(
      id: map['id'] as Id?,
      planId: map['planId'] as int,
      duration: Duration(milliseconds: map['duration'] as int),
      workoutDate: map['workoutDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['workoutDate'] as int)
          : null,
      exerciseLogs:
          (map['exerciseLogs'] as List<dynamic>?)
              ?.map((e) => ExerciseLogsDTO.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutLogsDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLogsDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, planId, duration, workoutDate, exerciseLogs];

  @override
  String toString() => 'WorkoutLogsDTO(id: $id, planId: $planId)';
}
