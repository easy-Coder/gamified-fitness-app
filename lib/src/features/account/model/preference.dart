import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit, Preference;
import 'package:isar_community/isar.dart';

class PreferenceDTO extends Equatable {
  final Id? id;
  final WeightUnit weightUnit;
  final bool useHealth;
  final bool workoutReminders;
  final bool achievementNotifications;
  final bool weeklyProgress;

  const PreferenceDTO({
    this.id,
    required this.weightUnit,
    required this.useHealth,
    required this.workoutReminders,
    required this.achievementNotifications,
    required this.weeklyProgress,
  });

  PreferenceDTO copyWith({
    Id? id,
    WeightUnit? weightUnit,
    bool? useHealth,
    bool? workoutReminders,
    bool? achievementNotifications,
    bool? weeklyProgress,
  }) {
    return PreferenceDTO(
      id: id ?? this.id,
      weightUnit: weightUnit ?? this.weightUnit,
      useHealth: useHealth ?? this.useHealth,
      workoutReminders: workoutReminders ?? this.workoutReminders,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
    );
  }

  Preference toSchema() {
    return Preference()
      ..id = id
      ..useHealth = useHealth
      ..weightUnit = weightUnit
      ..workoutReminders = workoutReminders
      ..achievementNotifications = achievementNotifications
      ..weeklyProgress = weeklyProgress;
  }

  factory PreferenceDTO.fromSchema(Preference preference) {
    return PreferenceDTO(
      id: preference.id,
      weightUnit: preference.weightUnit,
      useHealth: preference.useHealth,
      workoutReminders: preference.workoutReminders,
      achievementNotifications: preference.achievementNotifications,
      weeklyProgress: preference.weeklyProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weightUnit': weightUnit.index,
      'useHealth': useHealth,
      'workoutReminders': workoutReminders,
      'achievementNotifications': achievementNotifications,
      'weeklyProgress': weeklyProgress,
    };
  }

  factory PreferenceDTO.fromMap(Map<String, dynamic> map) {
    return PreferenceDTO(
      id: map['id'] as Id?,
      weightUnit: WeightUnit.values[map['weightUnit'] as int],
      useHealth: map['useHealth'],
      workoutReminders: map['workoutReminders'],
      achievementNotifications: map['achievementNotifications'],
      weeklyProgress: map['weeklyProgress'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferenceDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return PreferenceDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [
        id,
        weightUnit,
        useHealth,
        workoutReminders,
        achievementNotifications,
        weeklyProgress,
      ];

  @override
  @override
  String toString() => 'PreferenceDTO(id: $id, weightUnit: $weightUnit)';
}
