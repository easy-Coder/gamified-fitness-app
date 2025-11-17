import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/schema/workout_plan.dart';
import 'package:isar_community/isar.dart';

class WorkoutPlanDTO extends Equatable {
  final Id? id;
  final String name;
  final bool isVisible;
  final List<WorkoutExerciseDTO> exercises;

  const WorkoutPlanDTO({
    this.id,
    required this.name,
    this.isVisible = true,
    this.exercises = const [],
  });

  WorkoutPlanDTO copyWith({
    Id? id,
    String? name,
    bool? isVisible,
    List<WorkoutExerciseDTO>? exercises,
  }) {
    return WorkoutPlanDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      exercises: exercises ?? this.exercises,
    );
  }

  WorkoutPlan toSchema() {
    return WorkoutPlan()
      ..id = id
      ..name = name
      ..isVisible = isVisible;
  }

  factory WorkoutPlanDTO.fromSchema(WorkoutPlan plan) {
    return WorkoutPlanDTO(
      id: plan.id,
      name: plan.name,
      isVisible: plan.isVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isVisible': isVisible,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutPlanDTO.fromMap(Map<String, dynamic> map) {
    return WorkoutPlanDTO(
      id: map['id'] as Id?,
      name: map['name'] as String,
      isVisible: map['isVisible'] as bool? ?? true,
      exercises:
          (map['exercises'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseDTO.fromMap(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPlanDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutPlanDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, name, isVisible, exercises];

  @override
  String toString() => 'WorkoutPlanDTO(id: $id, name: $name)';
}
