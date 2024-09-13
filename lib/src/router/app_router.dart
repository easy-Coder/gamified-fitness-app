import 'package:gamified/src/features/stats/presentations/stats_overview_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRouter {
  stats,
  workout,
  leaderboard,
  clan,
  chat,
  plan,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(initialLocation: '/stats', routes: [
    GoRoute(
      name: AppRouter.stats.name,
      path: '/stats',
      builder: (context, state) => const StatsOverviewPage(),
    ),
  ]);
}
