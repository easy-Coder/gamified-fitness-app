import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show FluidUnit, WeightUnit, Preference;
import 'package:isar_community/isar.dart';

class PreferenceDTO extends Equatable {
  final Id? id;
  final WeightUnit weightUnit;
  final FluidUnit fluidUnit;

  const PreferenceDTO({
    this.id,
    required this.weightUnit,
    required this.fluidUnit,
  });

  PreferenceDTO copyWith({
    Id? id,
    WeightUnit? weightUnit,
    FluidUnit? fluidUnit,
  }) {
    return PreferenceDTO(
      id: id ?? this.id,
      weightUnit: weightUnit ?? this.weightUnit,
      fluidUnit: fluidUnit ?? this.fluidUnit,
    );
  }

  Preference toSchema() {
    return Preference()
      ..id = id
      ..weightUnit = weightUnit
      ..fluidUnit = fluidUnit;
  }

  factory PreferenceDTO.fromSchema(Preference preference) {
    return PreferenceDTO(
      id: preference.id,
      weightUnit: preference.weightUnit,
      fluidUnit: preference.fluidUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weightUnit': weightUnit.index,
      'fluidUnit': fluidUnit.index,
    };
  }

  factory PreferenceDTO.fromMap(Map<String, dynamic> map) {
    return PreferenceDTO(
      id: map['id'] as Id?,
      weightUnit: WeightUnit.values[map['weightUnit'] as int],
      fluidUnit: FluidUnit.values[map['fluidUnit'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferenceDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return PreferenceDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, weightUnit, fluidUnit];

  @override
  String toString() => 'PreferenceDTO(id: $id, weightUnit: $weightUnit)';
}
