import 'package:isar_community/isar.dart';

part 'user.g.dart';

enum Gender { male, female }

// User collection
@collection
class User {
  Id? id;
  late String name;
  late int age;
  @enumerated
  late Gender gender;
  late double height;
  late double weight;

  // Validation method (since Isar doesn't have inline validation)
  bool isValid() {
    return age >= 10 && age <= 90 && name.length <= 50;
  }
}
