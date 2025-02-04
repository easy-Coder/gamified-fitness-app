import 'package:flutter/material.dart';
import 'package:gamified/src/common/pages/welcome_page.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/auth/presentations/confirm_email/confirm_email_page.dart';
import 'package:gamified/src/features/auth/presentations/sign_in/sign_in_page.dart';
import 'package:gamified/src/features/auth/presentations/sign_up/sign_up_page.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/excersice/presentations/excercise_modal/excercise_modal.dart';
import 'package:gamified/src/features/stats/presentations/stats_overview_page.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page.dart/workout_page.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/create_plan_page.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan/workout_plan_page.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan_list/workout_plan_list_page.dart';
import 'package:gamified/src/router/shell_scaffold/nav_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

part 'app_router.g.dart';

enum AppRouter {
  stats,
  welcome,
  workoutPlan,
  clan,
  chat,
  plan,
  signin,
  register,
  confirmEmail,
  createPlan,
  excercise,
  workout,
  workoutPlans,
}

@riverpod
GoRouter goRouter(GoRouterRef ref, GlobalKey<NavigatorState> rootNavigatorKey) {
  final authState = ref.watch(authChangeProvider);

  final transitionObserver = NavigationSheetTransitionObserver();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    observers: [transitionObserver],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return '/welcome';

      final auth = authState.valueOrNull;

      if (auth != null && auth.session?.user == null) {
        if (state.uri.path == '/register' || state.uri.path == '/signin') {
          return null;
        }
        if (state.uri.path == '/welcome') {
          return null;
        }
        return '/welcome';
      }

      if (state.uri.path == '/register' ||
          state.uri.path == '/signin' ||
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
            name: AppRouter.workoutPlans.name,
            path: '/workout-plans',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WorkoutPlanListPage()),
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
      GoRoute(
        name: AppRouter.createPlan.name,
        path: '/create-plan',
        builder: (context, state) => const CreatePlanPage(),
      ),
      GoRoute(
        name: AppRouter.workout.name,
        path: '/workout',
        builder: (context, state) => WorkoutPage(
          workoutExercise: state.extra! as List<WorkoutExcercise>,
        ),
      ),
      GoRoute(
        name: AppRouter.workoutPlan.name,
        path: '/workout-plan',
        builder: (context, state) =>
            WorkoutPlanPage(plan: state.extra as WorkoutPlan),
      ),
      GoRoute(
        name: AppRouter.excercise.name,
        path: '/excercise',
        pageBuilder: (context, state) => ModalSheetPage(
          key: state.pageKey,
          swipeDismissible: false,
          barrierDismissible: false,
          child: ExcerciseModal(excercises: (state.extra as List<Excercise>)),
        ),
      ),
    ],
  );
}
