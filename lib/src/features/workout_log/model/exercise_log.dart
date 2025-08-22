import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';

extension type ExercisesLog._(
  ({
    int? id,
    Duration? duration,
    int set,
    int? reps,
    double? weight,
    int? workoutLogId,
    String exerciseId,
  })
  _
) {
  int? get id => _.id;
  Duration? get duration => _.duration;
  int get set => _.set;
  double? get weight => _.weight;
  int? get reps => _.reps;
  int? get workoutLogId => _.workoutLogId;
  String get exerciseId => _.exerciseId;

  ExercisesLog({
    int? workoutLogId,
    Duration? duration,
    required int set,
    required String exerciseId,
    double? weight,
    int? reps,
    int? id,
  }) : this._((
         id: id,
         duration: duration,
         set: set,
         weight: weight,
         reps: reps,
         workoutLogId: workoutLogId,
         exerciseId: exerciseId,
       ));

  ExercisesLog copyWith({
    int? workoutLogId,
    String? exerciseId,
    Duration? duration,
    int? set,
    double? weight,
    int? reps,
    int? id,
  }) => ExercisesLog(
    workoutLogId: workoutLogId ?? this.workoutLogId,
    exerciseId: exerciseId ?? this.exerciseId,
    duration: duration ?? this.duration,
    set: set ?? this.set,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
  );

  static ExercisesLog fromMap(Map<String, dynamic> map) {
    return ExercisesLog(
      id: map['id'] as int?,
      duration: map['duration'] as Duration,
      set: map['set'] as int,
      exerciseId: map['exerciseId'],
    );
  }

  static ExercisesLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExercisesLog.fromMap(map);
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
}
