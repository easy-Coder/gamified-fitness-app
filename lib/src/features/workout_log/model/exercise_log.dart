import 'dart:convert';

import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/model/set_log.dart';

extension type ExerciseLogs._(
  ({int? id, int? workoutLogId, String exerciseName, List<SetLogs> setLogs}) _
) {
  int? get id => _.id;
  int? get workoutLogId => _.workoutLogId;
  String get exerciseName => _.exerciseName;
  List<SetLogs> get setLogs => _.setLogs;

  ExerciseLogs({
    int? id,
    int? workoutLogId,
    required String exerciseName,
    List<SetLogs> setLogs = const <SetLogs>[],
  }) : this._((
         id: id,
         workoutLogId: workoutLogId,
         exerciseName: exerciseName,
         setLogs: setLogs,
       ));

  Map<String, dynamic> toMap() {
    return {'id': id, 'workoutId': workoutLogId, 'exerciseName': exerciseName};
  }

  ExerciseLogs copyWith({
    int? id,
    int? workoutLogId,
    String? exerciseName,
    List<SetLogs>? setLogs,
  }) => ExerciseLogs(
    id: id ?? this.id,
    workoutLogId: workoutLogId ?? this.workoutLogId,
    exerciseName: exerciseName ?? this.exerciseName,
    setLogs: setLogs ?? this.setLogs,
  );

  static ExerciseLogs fromMap(Map<String, dynamic> map) {
    return ExerciseLogs(
      id: map['id'] as int?,
      workoutLogId: map['workoutId'] as int,
      exerciseName: map['exerciseName'] as String,
      setLogs: map['setLogs'] as List<SetLogs>,
    );
  }

  static ExerciseLogs fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExerciseLogs.fromMap(map);
  }

  ExerciseLogsCompanion toCompanion() {
    return ExerciseLogsCompanion.insert(
      workoutLogId: workoutLogId!,
      exerciseName: exerciseName,
    );
  }
}
