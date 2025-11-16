import 'dart:convert';
import 'package:isar_community/isar.dart';

part 'excercise.g.dart';

@embedded
class Exercise {
  late final String exerciseId;
  late final String name;
  late final String gifUrl;
  late final String exerciseType;
  late final List<String> targetMuscles;
  late final List<String> bodyParts;
  late final List<String> equipments;
  late final List<String> secondaryMuscles;
  late final List<String> instructions;

  Exercise({
    this.exerciseId = '',
    this.name = '',
    this.gifUrl = '',
    this.exerciseType = '',
    this.targetMuscles = const [],
    this.bodyParts = const [],
    this.equipments = const [],
    this.secondaryMuscles = const [],
    this.instructions = const [],
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
      'exercise_type': exerciseType,
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

  String toJson() {
    return json.encode(toMap());
  }

  static Exercise fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return Exercise.fromMap(map);
  }

  @override
  String toString() {
    return 'Exercise(exerciseId: $exerciseId, name: $name, gifUrl: $gifUrl, targetMuscles: $targetMuscles, bodyParts: $bodyParts, equipments: $equipments, secondaryMuscles: $secondaryMuscles, instructions: $instructions)';
  }
}
