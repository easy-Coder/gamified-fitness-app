import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit, Preference;
import 'package:isar_community/isar.dart';

class PreferenceDTO extends Equatable {
  final Id? id;
  final WeightUnit weightUnit;
  final bool useHealth;

  const PreferenceDTO({
    this.id,
    required this.weightUnit,
    required this.useHealth,
  });

  PreferenceDTO copyWith({Id? id, WeightUnit? weightUnit, bool? useHealth}) {
    return PreferenceDTO(
      id: id ?? this.id,
      weightUnit: weightUnit ?? this.weightUnit,
      useHealth: useHealth ?? this.useHealth,
    );
  }

  Preference toSchema() {
    return Preference()
      ..id = id
      ..useHealth = useHealth
      ..weightUnit = weightUnit;
  }

  factory PreferenceDTO.fromSchema(Preference preference) {
    return PreferenceDTO(
      id: preference.id,
      weightUnit: preference.weightUnit,

      useHealth: preference.useHealth,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'weightUnit': weightUnit.index, 'useHealth': useHealth};
  }

  factory PreferenceDTO.fromMap(Map<String, dynamic> map) {
    return PreferenceDTO(
      id: map['id'] as Id?,
      weightUnit: WeightUnit.values[map['weightUnit'] as int],
      useHealth: map['useHealth'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferenceDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return PreferenceDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, weightUnit, useHealth];

  @override
  String toString() => 'PreferenceDTO(id: $id, weightUnit: $weightUnit)';
}
