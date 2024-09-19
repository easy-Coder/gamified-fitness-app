import 'package:flutter/material.dart';
import 'package:gamified/src/common/pages/welcome_page.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/features/auth/presentations/sign_in/sign_in_page.dart';
import 'package:gamified/src/features/auth/presentations/sign_up/sign_up_page.dart';
import 'package:gamified/src/features/stats/presentations/stats_overview_page.dart';
import 'package:gamified/src/router/auth_listenable.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRouter {
  stats,
  welcome,
  workout,
  leaderboard,
  clan,
  chat,
  plan,
  signin,
  register,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final client = ref.read(supabaseProvider);
  return GoRouter(
    refreshListenable: AuthListenable(client.auth.onAuthStateChange),
    initialLocation: '/welcome',
    redirect: (context, state) {
      debugPrint('Redirect Called');
      debugPrint('Current Path: ${state.uri.path}');
      final user = client.auth.currentUser;
      if (user == null) {
        if (state.uri.path == '/register' || state.uri.path == '/signin') {
          return null;
        }
        if (state.uri.path == '/welcome') {
          return null;
        }
        return '/signin';
      }
      if (state.uri.path == '/register' || state.uri.path == '/login' || state.uri.path == '/welcome') {
        return '/stats';
      }
      return null;
    },
    routes: [
      GoRoute(
        name: AppRouter.stats.name,
        path: '/stats',
        builder: (context, state) => const StatsOverviewPage(),
      ),
      GoRoute(
        name: AppRouter.welcome.name,
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        name: AppRouter.signin.name,
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        name: AppRouter.register.name,
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
    ],
  );
}
