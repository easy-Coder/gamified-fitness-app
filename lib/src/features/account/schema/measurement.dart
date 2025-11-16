import 'package:isar_community/isar.dart';

part 'measurement.g.dart';

@collection
class Measurement {
  Id? id;
  late DateTime date;
  late double weight;
  late double height;

  Measurement({
    this.id,
    required this.date,
    required this.weight,
    required this.height,
  });
}

