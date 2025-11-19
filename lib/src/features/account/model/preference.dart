import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit;

class PreferenceDTO extends Equatable {
  static const int _defaultId = 1;
  static const PreferenceDTO defaultPreference = PreferenceDTO(
    id: _defaultId,
    weightUnit: WeightUnit.kg,
    useHealth: false,
    workoutReminders: false,
    achievementNotifications: false,
    weeklyProgress: false,
  );

  final int id;
  final WeightUnit weightUnit;
  final bool useHealth;
  final bool workoutReminders;
  final bool achievementNotifications;
  final bool weeklyProgress;

  const PreferenceDTO({
    this.id = _defaultId,
    required this.weightUnit,
    required this.useHealth,
    required this.workoutReminders,
    required this.achievementNotifications,
    required this.weeklyProgress,
  });

  PreferenceDTO copyWith({
    int? id,
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
      id: map['id'] as int? ?? _defaultId,
      weightUnit: WeightUnit.values[map['weightUnit'] as int? ?? 0],
      useHealth: map['useHealth'] as bool? ?? false,
      workoutReminders: map['workoutReminders'] as bool? ?? false,
      achievementNotifications:
          map['achievementNotifications'] as bool? ?? false,
      weeklyProgress: map['weeklyProgress'] as bool? ?? false,
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

  String toString() => 'PreferenceDTO(id: $id, weightUnit: $weightUnit)';
}
