import 'package:gamified/src/features/leaderboard/data/leaderboard_repository.dart';
import 'package:gamified/src/features/leaderboard/model/leaderboard_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard_controller.g.dart';

@riverpod
class LeaderboardNotifier extends _$LeaderboardNotifier {
  @override
  Future<List<LeaderboardUser>> build() async {
    final repository = ref.read(leaderboardRepositoryProvider);
    final leaderboardData = await repository.getLeaderboard();
    return leaderboardData;
  }

  Future<void> refreshLeaderboard() async {
    ref.invalidateSelf();
  }
}
