import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/goal.dart' show FitnessGoal;

class GoalModel extends Equatable {
  final int? id;
  final FitnessGoal fitnessGoal;
  final double targetWeight;
  final double hydrationGoal;

  const GoalModel({
    this.id,
    required this.fitnessGoal,
    required this.targetWeight,
    required this.hydrationGoal,
  });

  factory GoalModel.empty() => const GoalModel(
        fitnessGoal: FitnessGoal.keepFit,
        targetWeight: 0.0,
        hydrationGoal: 0.0,
      );

  bool get isEmpty => targetWeight == 0 || hydrationGoal == 0;

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
      targetWeight: (map['targetWeight'] as num).toDouble(),
      hydrationGoal: (map['hydrationGoal'] as num).toDouble(),
    );
  }

  String toJson() {
    return json.encode(toMap());
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

  @override
  List<Object?> get props => [
        id,
        fitnessGoal,
        targetWeight,
        hydrationGoal,
      ];

  @override
  String toString() {
    return 'GoalModel(id: $id, fitnessGoal: $fitnessGoal, targetWeight: $targetWeight, hydrationGoal: $hydrationGoal)';
  }
}