import 'dart:convert';

import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';

extension type WorkoutLog._(
  ({
    int? logId,
    String? userId,
    String notes,
    int stamina,
    int endurance,
    int agility,
    int strength,
    DaysOfWeek dayOfWeek,
  })
  _
) {
  int? get logId => _.logId;
  String? get userId => _.userId;
  String get notes => _.notes;
  int get stamina => _.stamina;
  int get endurance => _.endurance;
  int get agility => _.agility;
  int get strength => _.strength;
  DaysOfWeek get dayOfWeek => _.dayOfWeek;

  WorkoutLog({
    int? logId,
    String? userId,
    String notes = '',
    required int stamina,
    required int endurance,
    required int agility,
    required int strength,
    required DaysOfWeek dayOfWeek,
  }) : this._((
         logId: logId,
         userId: userId,
         notes: notes,
         stamina: stamina,
         endurance: endurance,
         agility: agility,
         strength: strength,
         dayOfWeek: dayOfWeek,
       ));

  WorkoutLog copyWith({
    int? logId,
    String? userId,
    String? notes,
    int? stamina,
    int? endurance,
    int? agility,
    int? strength,
    DaysOfWeek? dayOfWeek,
  }) {
    return WorkoutLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      notes: notes ?? this.notes,
      stamina: stamina ?? this.stamina,
      endurance: endurance ?? this.endurance,
      agility: agility ?? this.agility,
      strength: strength ?? this.strength,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logId': logId,
      'userId': userId,
      'notes': notes,
      'stamina': stamina,
      'endurance': endurance,
      'agility': agility,
      'strength': strength,
      'dayOfWeek': dayOfWeek.index,
    };
  }

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      logId: map['logId'] as int?,
      userId: map['userId'] as String?,
      notes: map['notes'] as String,
      stamina: map['stamina'] as int,
      endurance: map['endurance'] as int,
      agility: map['agility'] as int,
      strength: map['strength'] as int,
      dayOfWeek: DaysOfWeek.values[map['dayOfWeek'] as int],
    );
  }

  static WorkoutLog fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutLog.fromMap(map);
  }

  // WorkoutLogsCompanion toCompanion() {
  //  return WorkoutLogsCompanion.insert(
  //    logId: logId != null ? Value(logId!) : const Value.absent(),
  //    userId: userId != null ? Value(userId!) : const Value.absent(),
  //    notes: Value(notes),
  //    stamina: Value(stamina),
  //    endurance: Value(endurance),
  //    agility: Value(agility),
  //    strength: Value(strength),
  //    dayOfWeek: Value(dayOfWeek),
  //  );
  //}

  //static WorkoutLog fromCompanion(WorkoutLogsData data) {
  //  return WorkoutLog(
  //    logId: data.logId,
  //    userId: data.userId,
  //    notes: data.notes,
  //    stamina: data.stamina,
  //    endurance: data.endurance,
  //    agility: data.agility,
  //    strength: data.strength,
  //    dayOfWeek: data.dayOfWeek,
  //  );
  //}
}
