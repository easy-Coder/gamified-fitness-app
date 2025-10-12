import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/account/schema/user.dart'
    show Gender, User;
import 'package:isar_community/isar.dart';

class UserDTO extends Equatable {
  final Id? id;
  final String name;
  final int age;
  final Gender gender;
  final double height;
  final double weight;

  const UserDTO({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  factory UserDTO.empty() => const UserDTO(
    name: '',
    age: 0,
    gender: Gender.male,
    height: 0,
    weight: 0,
  );

  bool get isEmpty => name.isEmpty || age == 0 || height == 0 || weight == 0;

  UserDTO copyWith({
    Id? id,
    String? name,
    int? age,
    Gender? gender,
    double? height,
    double? weight,
  }) {
    return UserDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  User toSchema() {
    return User()
      ..id = id
      ..name = name
      ..age = age
      ..gender = gender
      ..height = height
      ..weight = weight;
  }

  factory UserDTO.fromSchema(User user) {
    return UserDTO(
      id: user.id,
      name: user.name,
      age: user.age,
      gender: user.gender,
      height: user.height,
      weight: user.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender.index,
      'height': height,
      'weight': weight,
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'] as Id?,
      name: map['name'] as String,
      age: map['age'] as int,
      gender: Gender.values[map['gender'] as int],
      height: map['height'] as double,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return UserDTO.fromMap(map);
  }

  @override
  List<Object?> get props => [id, name, age, gender, height, weight];

  @override
  String toString() => 'UserDTO(id: $id, name: $name, age: $age)';
}
