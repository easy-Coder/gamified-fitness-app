import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';

extension type SetLogs._(
  ({
    int? setLogId,
    int exerciseLogId,
    int setNumber,
    double? weight,
    int? reps,
    int? duration,
  })
  _
) {
  int? get setLogId => _.setLogId;
  int get exerciseLogId => _.exerciseLogId;
  int get setNumber => _.setNumber;
  double? get weight => _.weight;
  int? get reps => _.reps;
  int? get duration => _.duration;

  SetLogs({
    int? setLogId,
    required int exerciseLogId,
    required int setNumber,
    double? weight,
    int? reps,
    int? duration,
  }) : this._((
         setLogId: setLogId,
         exerciseLogId: exerciseLogId,
         setNumber: setNumber,
         weight: weight,
         reps: reps,
         duration: duration,
       ));

  Map<String, dynamic> toMap() {
    return {
      'setLogId': setLogId,
      'exerciseLogId': exerciseLogId,
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'duration': duration,
    };
  }

  static SetLogs fromMap(Map<String, dynamic> map) {
    return SetLogs(
      setLogId: map['setLogId'] as int?,
      exerciseLogId: map['exerciseLogId'] as int,
      setNumber: map['setNumber'] as int,
      weight: map['weight'] as double?,
      reps: map['reps'] as int?,
      duration: map['duration'] as int?,
    );
  }

  static SetLogs fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return SetLogs.fromMap(map);
  }

  SetLogs copyWith({
    int? setLogId,
    int? exerciseLogId,
    int? setNumber,
    double? weight,
    int? reps,
    int? duration,
  }) => SetLogs(
    setLogId: setLogId ?? this.setLogId,
    exerciseLogId: exerciseLogId ?? this.exerciseLogId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    duration: duration ?? this.duration,
  );

  SetLogsCompanion toCompanion() {
    return SetLogsCompanion.insert(
      setLogId: setLogId != null ? Value(setLogId!) : const Value.absent(),
      exerciseLogId: exerciseLogId,
      setNumber: setNumber,
      weight: Value(weight),
      reps: Value(reps),
      duration: Value(duration),
    );
  }
}
