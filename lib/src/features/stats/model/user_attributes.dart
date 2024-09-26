import 'package:dart_mappable/dart_mappable.dart';

part 'user_attributes.mapper.dart';

@MappableClass()
class UserAttribute with UserAttributeMappable {
  const UserAttribute(
    this.user_id,
    this.updated_at,
    this.agility,
    this.endurance,
    this.strength,
    this.stamina,
  );

  final String user_id;
  final int agility;
  final int endurance;
  final int strength;
  final int stamina;
  final DateTime updated_at;
}
