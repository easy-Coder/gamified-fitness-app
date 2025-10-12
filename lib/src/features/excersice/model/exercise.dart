import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/excersice/schema/excercise.dart';

class ExerciseDTO extends Equatable {
  final String exerciseId;
  final String name;
  final String gifUrl;
  final String exerciseType;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  const ExerciseDTO({
    required this.exerciseId,
    required this.name,
    required this.gifUrl,
    required this.exerciseType,
    this.targetMuscles = const [],
    this.bodyParts = const [],
    this.equipments = const [],
    this.secondaryMuscles = const [],
    this.instructions = const [],
  });

  ExerciseDTO copyWith({
    String? exerciseId,
    String? name,
    String? gifUrl,
    String? exerciseType,
    List<String>? targetMuscles,
    List<String>? bodyParts,
    List<String>? equipments,
    List<String>? secondaryMuscles,
    List<String>? instructions,
  }) {
    return ExerciseDTO(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      gifUrl: gifUrl ?? this.gifUrl,
      exerciseType: exerciseType ?? this.exerciseType,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      bodyParts: bodyParts ?? this.bodyParts,
      equipments: equipments ?? this.equipments,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
    );
  }

  Exercise toSchema() {
    return Exercise(
      exerciseId: exerciseId,
      name: name,
      gifUrl: gifUrl,
      exerciseType: exerciseType,
      targetMuscles: targetMuscles,
      bodyParts: bodyParts,
      equipments: equipments,
      secondaryMuscles: secondaryMuscles,
      instructions: instructions,
    );
  }

  factory ExerciseDTO.fromSchema(Exercise exercise) {
    return ExerciseDTO(
      exerciseId: exercise.exerciseId,
      name: exercise.name,
      gifUrl: exercise.gifUrl,
      exerciseType: exercise.exerciseType,
      targetMuscles: exercise.targetMuscles,
      bodyParts: exercise.bodyParts,
      equipments: exercise.equipments,
      secondaryMuscles: exercise.secondaryMuscles,
      instructions: exercise.instructions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'gifUrl': gifUrl,
      'exercise_type': exerciseType,
      'targetMuscles': targetMuscles,
      'bodyParts': bodyParts,
      'equipments': equipments,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }

  factory ExerciseDTO.fromMap(Map<String, dynamic> map) {
    return ExerciseDTO(
      exerciseId: map['exerciseId'] as String,
      name: map['name'] as String,
      gifUrl: map['gifUrl'] as String,
      exerciseType: map['exercise_type'] as String,
      targetMuscles:
          (map['targetMuscles'] as List<dynamic>?)?.cast<String>() ?? [],
      bodyParts: (map['bodyParts'] as List<dynamic>?)?.cast<String>() ?? [],
      equipments: (map['equipments'] as List<dynamic>?)?.cast<String>() ?? [],
      secondaryMuscles:
          (map['secondaryMuscles'] as List<dynamic>?)?.cast<String>() ?? [],
      instructions:
          (map['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return ExerciseDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [
    exerciseId,
    name,
    gifUrl,
    exerciseType,
    targetMuscles,
    bodyParts,
    equipments,
    secondaryMuscles,
    instructions,
  ];

  @override
  String toString() =>
      'ExerciseDTO(exerciseId: $exerciseId, name: $name, gifUrl: $gifUrl)';
}
