import 'package:flutter/material.dart';
import 'package:gamified/src/common/pages/welcome_page.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/auth/presentations/confirm_email/confirm_email_page.dart';
import 'package:gamified/src/features/auth/presentations/sign_in/sign_in_page.dart';
import 'package:gamified/src/features/auth/presentations/sign_up/sign_up_page.dart';
import 'package:gamified/src/features/stats/presentations/stats_overview_page.dart';
import 'package:gamified/src/router/shell_scaffold/nav_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  confirmEmail,
}

@riverpod
GoRouter goRouter(GoRouterRef ref, GlobalKey<NavigatorState> rootNavigatorKey) {
  final authState = ref.watch(authChangeProvider);

  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      final auth = authState.valueOrNull;
      // print(auth?.session);
      if (auth != null && auth.session?.user == null) {
        if (state.uri.path == '/register' || state.uri.path == '/signin') {
          return null;
        }
        if (state.uri.path == '/welcome') {
          return null;
        }
        return '/signin';
      }

      if (state.uri.path == '/register' ||
          state.uri.path == '/login' ||
          state.uri.path == '/welcome') {
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, child) => NavScaffold(page: child),
        routes: [
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            name: AppRouter.stats.name,
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StatsOverviewPage()),
          ),
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            name: AppRouter.leaderboard.name,
            path: '/leaderboard',
            pageBuilder: (context, state) => NoTransitionPage(
              child: Container(
                child: const Text('The leaderboard page'),
              ),
            ),
          ),
        ],
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
      GoRoute(
        name: AppRouter.confirmEmail.name,
        path: '/confirm-email',
        builder: (context, state) => const ConfirmEmailPage(),
      ),
    ],
  );
}
