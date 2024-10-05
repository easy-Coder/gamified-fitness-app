import 'package:dart_mappable/dart_mappable.dart';

part 'user_attributes.mapper.dart';

@MappableClass()
class UserAttribute with UserAttributeMappable {
  const UserAttribute({
    required this.userId,
    required this.agility,
    required this.endurance,
    required this.strength,
    required this.stamina,
  });

  @MappableField(key: 'user_id')
  final String userId;
  final int agility;
  final int endurance;
  final int strength;
  final int stamina;
}
