import 'dart:convert';
import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String exerciseId;
  final String name;
  final String gifUrl;
  final String exerciseType;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  const Exercise({
    required this.exerciseId,
    required this.name,
    required this.gifUrl,
    required this.exerciseType,
    required this.targetMuscles,
    required this.bodyParts,
    required this.equipments,
    required this.secondaryMuscles,
    required this.instructions,
  });

  Exercise copyWith({
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
    return Exercise(
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

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'gifUrl': gifUrl,
      'exerciseType': exerciseType,
      'targetMuscles': targetMuscles,
      'bodyParts': bodyParts,
      'equipments': equipments,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      exerciseId: map['exerciseId'] as String,
      name: map['name'] as String,
      gifUrl: map['gifUrl'] as String,
      exerciseType: map['exerciseType'] as String,
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

  String toJson() {
    return json.encode(toMap());
  }

  static Exercise fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return Exercise.fromMap(map);
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
  String toString() {
    return 'Exercise(exerciseId: $exerciseId, name: $name, gifUrl: $gifUrl, targetMuscles: $targetMuscles, bodyParts: $bodyParts, equipments: $equipments, secondaryMuscles: $secondaryMuscles, instructions: $instructions)';
  }
}
