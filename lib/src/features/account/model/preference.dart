import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show FluidUnit, WeightUnit;

extension type PreferenceModel._(
  ({int? id, WeightUnit weightUnit, FluidUnit fluidUnit}) _
) {
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

  PreferenceModel({
    int? id,
    required WeightUnit weightUnit,
    required FluidUnit fluidUnit,
  }) : this._((id: id, weightUnit: weightUnit, fluidUnit: fluidUnit));

  int? get id => _.id;
  WeightUnit get weightUnit => _.weightUnit;
  FluidUnit get fluidUnit => _.fluidUnit;

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
}
