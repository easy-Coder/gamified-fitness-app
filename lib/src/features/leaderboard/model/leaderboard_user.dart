import 'package:dart_mappable/dart_mappable.dart';

part 'leaderboard_user.mapper.dart';

@MappableClass()
class LeaderboardUser with LeaderboardUserMappable {
  final String id;
  final String username;
  final int score;

  LeaderboardUser(
      {required this.id, required this.username, required this.score});
}
