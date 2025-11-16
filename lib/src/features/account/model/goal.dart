import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/account/schema/goal.dart'
    show FitnessGoal, Goal;
import 'package:isar_community/isar.dart';

class GoalDTO extends Equatable {
  final Id? id;
  final FitnessGoal fitnessGoal;
  final double targetWeight;
  final double hydrationGoal;

  const GoalDTO({
    this.id,
    required this.fitnessGoal,
    required this.targetWeight,
    required this.hydrationGoal,
  });

  factory GoalDTO.empty() => const GoalDTO(
    fitnessGoal: FitnessGoal.keepFit,
    targetWeight: 0.0,
    hydrationGoal: 0.0,
  );

  bool get isEmpty => targetWeight == 0 || hydrationGoal == 0;

  GoalDTO copyWith({
    Id? id,
    FitnessGoal? fitnessGoal,
    double? targetWeight,
    double? hydrationGoal,
  }) {
    return GoalDTO(
      id: id ?? this.id,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      targetWeight: targetWeight ?? this.targetWeight,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
    );
  }

  Goal toSchema() {
    return Goal()
      ..id = id
      ..fitnessGoal = fitnessGoal
      ..targetWeight = targetWeight
      ..hydrationGoal = hydrationGoal;
  }

  factory GoalDTO.fromSchema(Goal goal) {
    return GoalDTO(
      id: goal.id,
      fitnessGoal: goal.fitnessGoal,
      targetWeight: goal.targetWeight,
      hydrationGoal: goal.hydrationGoal,
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

  factory GoalDTO.fromMap(Map<String, dynamic> map) {
    return GoalDTO(
      id: map['id'] as Id?,
      fitnessGoal: FitnessGoal.values[map['fitnessGoal'] as int],
      targetWeight: (map['targetWeight'] as num).toDouble(),
      hydrationGoal: (map['hydrationGoal'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return GoalDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, fitnessGoal, targetWeight, hydrationGoal];

  @override
  String toString() => 'GoalDTO(id: $id, fitnessGoal: $fitnessGoal)';
}
