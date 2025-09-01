import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show FluidUnit, WeightUnit;

class PreferenceModel extends Equatable {
  final int? id;
  final WeightUnit weightUnit;
  final FluidUnit fluidUnit;

  const PreferenceModel({
    this.id,
    required this.weightUnit,
    required this.fluidUnit,
  });

  PreferenceModel copyWith({
    int? id,
    WeightUnit? weightUnit,
    FluidUnit? fluidUnit,
  }) {
    return PreferenceModel(
      id: id ?? this.id,
      weightUnit: weightUnit ?? this.weightUnit,
      fluidUnit: fluidUnit ?? this.fluidUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weightUnit': weightUnit.index,
      'fluidUnit': fluidUnit.index,
    };
  }

  static PreferenceModel fromMap(Map<String, dynamic> map) {
    return PreferenceModel(
      id: map['id'] as int?,
      weightUnit: WeightUnit.values[map['weightUnit'] as int],
      fluidUnit: FluidUnit.values[map['fluidUnit'] as int],
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static PreferenceModel fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return PreferenceModel.fromMap(map);
  }

  PreferenceCompanion toCompanion() {
    return PreferenceCompanion.insert(
      weightUnit: weightUnit,
      fluidUnit: fluidUnit,
      id: id != null ? Value(id!) : const Value.absent(),
    );
  }

  @override
  List<Object?> get props => [id, weightUnit, fluidUnit];

  @override
  String toString() {
    return 'PreferenceModel(id: $id, weightUnit: $weightUnit, fluidUnit: $fluidUnit)';
  }
}
