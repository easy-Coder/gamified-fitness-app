import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/goal.dart'
    show FitnessGoal;

extension type GoalModel._(
  ({
    int? id,
    FitnessGoal fitnessGoal,
    double targetWeight,
    double hydrationGoal,
  })
  _
) {
  int? get id => _.id;
  FitnessGoal get fitnessGoal => _.fitnessGoal;
  double get targetWeight => _.targetWeight;
  double get hydrationGoal => _.hydrationGoal;

  GoalModel({
    int? id,
    required FitnessGoal fitnessGoal,
    required double targetWeight,
    required double hydrationGoal,
  }) : this._((
         id: id,
         fitnessGoal: fitnessGoal,
         targetWeight: targetWeight,
         hydrationGoal: hydrationGoal,
       ));

  GoalModel copyWith({
    int? id,
    FitnessGoal? fitnessGoal,
    double? targetWeight,
    double? hydrationGoal,
  }) {
    return GoalModel(
      id: id ?? this.id,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      targetWeight: targetWeight ?? this.targetWeight,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fitnessGoal': fitnessGoal.index,
      'targetWeight': targetWeight,
      'hydrationGoal': hydrationGoal,
    };
  }

  static GoalModel fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] as int?,
      fitnessGoal: FitnessGoal.values[map['fitnessGoal'] as int],
      targetWeight: map['targetWeight'] as double,
      hydrationGoal: map['hydrationGoal'] as double,
    );
  }

  static GoalModel fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return GoalModel.fromMap(map);
  }

  GoalCompanion toCompanion() {
    return GoalCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      fitnessGoal: fitnessGoal,
      targetWeight: targetWeight,
      hydrationGoal: hydrationGoal,
    );
  }
}
