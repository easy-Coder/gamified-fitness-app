import 'dart:convert';
import 'package:gamified/src/features/account/schema/measurement.dart'
    show Measurement;
import 'package:isar_community/isar.dart';

class MeasurementDTO {
  final Id? id;
  final DateTime date;
  final double weight;
  final double height;

  const MeasurementDTO({
    this.id,
    required this.date,
    required this.weight,
    required this.height,
  });

  MeasurementDTO copyWith({
    Id? id,
    DateTime? date,
    double? weight,
    double? height,
  }) {
    return MeasurementDTO(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  Measurement toSchema() {
    return Measurement(id: id, date: date, weight: weight, height: height);
  }

  factory MeasurementDTO.fromSchema(Measurement measurement) {
    return MeasurementDTO(
      id: measurement.id,
      date: measurement.date,
      weight: measurement.weight,
      height: measurement.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'weight': weight,
      'height': height,
    };
  }

  factory MeasurementDTO.fromMap(Map<String, dynamic> map) {
    return MeasurementDTO(
      id: map['id'] as Id?,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeasurementDTO.fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return MeasurementDTO.fromMap(map);
  }

  @override
  String toString() =>
      'MeasurementDTO(id: $id, date: $date, weight: $weight, height: $height)';
}
