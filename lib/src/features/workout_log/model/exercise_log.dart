import 'dart:convert';

import 'package:gamified/src/common/providers/db.dart';

extension type ExerciseLog._(
  ({int? id, int workoutLogId, String exerciseName}) _
) {
  int? get id => _.id;
  int get workoutLogId => _.workoutLogId;
  String get exerciseName => _.exerciseName;

  ExerciseLog({
    int? id,
    required int workoutLogId,
    required String exerciseName,
  }) : this._((id: id, workoutLogId: workoutLogId, exerciseName: exerciseName));

  Map<String, dynamic> toMap() {
    return {'id': id, 'workoutId': workoutLogId, 'exerciseName': exerciseName};
  }

  ExerciseLog copyWith({int? id, int? workoutLogId, String? exerciseName}) =>
      ExerciseLog(
        id: id ?? this.id,
        workoutLogId: workoutLogId ?? this.workoutLogId,
        exerciseName: exerciseName ?? this.exerciseName,
      );

  static ExerciseLog fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      id: map['id'] as int?,
      workoutLogId: map['workoutId'] as int,
      exerciseName: map['exerciseName'] as String,
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
    );
  }
}
