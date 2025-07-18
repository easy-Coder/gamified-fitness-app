import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/schema/user.dart' show Gender;

extension type UserModel._(
  ({int? id, String name, int age, Gender gender, double height, double weight})
  _
) {
  int? get id => _.id;
  String get name => _.name;
  int get age => _.age;
  Gender get gender => _.gender;
  double get height => _.height;
  double get weight => _.weight;

  UserModel({
    int? id,
    required String name,
    required int age,
    required Gender gender,
    required double height,
    required double weight,
  }) : this._((
         id: id,
         name: name,
         age: age,
         gender: gender,
         height: height,
         weight: weight,
       ));

  UserModel copyWith({
    int? id,
    String? name,
    int? age,
    Gender? gender,
    double? height,
    double? weight,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  bool get isEmpty => name.isEmpty || age == 0 || height == 0 || weight == 0;

  factory UserModel.empty() =>
      UserModel(name: '', age: 0, gender: Gender.male, height: 0, weight: 0);

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

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      gender: Gender.values[map['gender'] as int],
      height: map['height'] as double,
      weight: map['weight'] as double,
    );
  }

  static UserModel fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return UserModel.fromMap(map);
  }

  UserCompanion toCompanion() {
    return UserCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      name: name,
      age: age,
      gender: gender,
      height: height,
      weight: weight,
    );
  }
}
