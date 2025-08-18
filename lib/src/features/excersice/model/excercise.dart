import 'dart:convert';

extension type Exercise._(
  ({
    int? id,
    String name,
    String? force,
    String level,
    String? mechanic,
    String? equipment,
    List<String> primaryMuscles,
    List<String> secondaryMuscles,
    List<String> instructions,
    String category,
    List<String> images,
  })
  _
) {
  int? get id => _.id;
  String get name => _.name;
  String? get force => _.force;
  String get level => _.level;
  String? get mechanic => _.mechanic;
  String? get equipment => _.equipment;
  List<String> get primaryMuscles => _.primaryMuscles;
  List<String> get secondaryMuscles => _.secondaryMuscles;
  List<String> get instructions => _.instructions;
  String get category => _.category;
  List<String> get images => _.images;

  Exercise({
    int? id,
    required String name,
    required String? force,
    required String level,
    required String? mechanic,
    required String? equipment,
    required List<String> primaryMuscles,
    required List<String> secondaryMuscles,
    required List<String> instructions,
    required String category,
    required List<String> images,
  }) : this._((
         id: id,
         name: name,
         force: force,
         level: level,
         mechanic: mechanic,
         equipment: equipment,
         primaryMuscles: primaryMuscles,
         secondaryMuscles: secondaryMuscles,
         instructions: instructions,
         category: category,
         images: images,
       ));

  Exercise copyWith({
    int? id,
    String? name,
    String? force,
    String? level,
    String? mechanic,
    String? equipment,
    List<String>? primaryMuscles,
    List<String>? secondaryMuscles,
    List<String>? instructions,
    String? category,
    List<String>? images,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      force: force ?? this.force,
      level: level ?? this.level,
      mechanic: mechanic ?? this.mechanic,
      equipment: equipment ?? this.equipment,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipment': equipment,
      'primary_muscles': primaryMuscles,
      'secondary_muscles': secondaryMuscles,
      'instructions': instructions,
      'category': category,
      'images': images,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] as String,
      force: map['force'] as String?,
      level: map['level'] as String,
      mechanic: map['mechanic'] as String?,
      equipment: map['equipment'] as String?,
      primaryMuscles:
          (map['primaryMuscles'] as List<dynamic>?)?.cast<String>() ?? [],
      secondaryMuscles:
          (map['secondaryMuscles'] as List<dynamic>?)?.cast<String>() ?? [],
      instructions:
          (map['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
      category: map['category'] as String,
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static Exercise fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return Exercise.fromMap(map);
  }
}
