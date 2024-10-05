import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/leaderboard/model/leaderboard_user.dart';
import 'package:gamified/src/features/leaderboard/presentation/controller.dart/leaderboard_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (leaderboard) => RefreshIndicator(
          onRefresh: () => ref.refresh(leaderboardNotifierProvider.notifier).refreshLeaderboard(),
          child: ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              return _buildLeaderboardTile(
                  context, leaderboard[index], index + 1);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardTile(
      BuildContext context, LeaderboardUser user, int rank) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Text(
            '$rank',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${user.score}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
    );
  }
}
