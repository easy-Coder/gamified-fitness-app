import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/pages/welcome_page.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/excersice/presentations/excercise_modal/excercise_modal.dart';
import 'package:gamified/src/features/hydration/presentation/add_hydration/add_hydration_modal.dart';
import 'package:gamified/src/features/onboarding/data/onboarding_repository.dart';
import 'package:gamified/src/features/onboarding/presentation/onboarding_page.dart';
import 'package:gamified/src/features/stats/presentations/stats_overview_page.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/workout_page.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/workout_page.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/create_plan_page.dart';
import 'package:gamified/src/features/workout_plan/presentations/edit_plan/edit_plan_page.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan/workout_plan_page.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan_list/workout_plan_list_page.dart';
import 'package:gamified/src/router/shell_scaffold/nav_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

enum AppRouter {
  stats,
  welcome,
  onboarding,
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
  editPlan,
  addWater,
  exerciseLog,
}

final goRouterProvider = Provider.family<GoRouter, GlobalKey<NavigatorState>>((
  ref,
  GlobalKey<NavigatorState> rootNavigatorKey,
) {
  final transitionObserver = NavigationSheetTransitionObserver();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    observers: [transitionObserver],
    redirect: (context, state) async {
      final path = state.uri.path;
      if (path == '/welcome') return null;

      final onboardingRepo = ref.watch(onboardingRepoProvider);

      final isOnboardingComplete = await onboardingRepo.isOnboardingComplete();

      if (isOnboardingComplete == false) {
        if (path != '/onboard') return '/onboard';
        return null;
      }

      if (isOnboardingComplete == true && path == '/onboard') {
        return '/'; // or another appropriate destination
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
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: StatsOverviewPage()),
          ),
          GoRoute(
            name: AppRouter.workoutPlans.name,
            path: '/workout-plans',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: WorkoutPlanListPage()),
          ),
        ],
      ),
      GoRoute(
        name: AppRouter.onboarding.name,
        path: '/onboard',
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(
        name: AppRouter.welcome.name,
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      // GoRoute(
      //   name: AppRouter.exerciseLog.name,
      //   path: '/exercise-log',
      //   builder: (context, state) => const WorkoutPage(),
      // ),
      GoRoute(
        name: AppRouter.createPlan.name,
        path: '/create-plan',
        builder: (context, state) => const CreatePlanPage(),
      ),
      GoRoute(
        name: AppRouter.editPlan.name,
        path: '/edit-plan/:id',
        builder:
            (context, state) =>
                EditPlanPage(planId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        name: AppRouter.workout.name,
        path: '/workout',
        builder:
            (context, state) => WorkoutPage(workoutPlanId: state.extra! as int),
      ),
      GoRoute(
        name: AppRouter.workoutPlan.name,
        path: '/workout-plan/:id',
        builder:
            (context, state) =>
                WorkoutPlanPage(plan: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        name: AppRouter.excercise.name,
        path: '/excercise',
        pageBuilder:
            (context, state) => ModalSheetPage(
              key: state.pageKey,
              swipeDismissible: false,
              barrierDismissible: false,
              child: ExcerciseModal(
                excercises: (state.extra as List<Exercise>),
              ),
            ),
      ),
      GoRoute(
        name: AppRouter.addWater.name,
        path: '/add-water',
        pageBuilder:
            (context, state) =>
                ModalSheetPage(key: state.pageKey, child: AddHydrationModal()),
      ),
    ],
    extraCodec: const MyExtraCodec(),
  );
});

class MyExtraCodec extends Codec<Object?, Object?> {
  /// Create a codec.
  const MyExtraCodec();
  @override
  Converter<Object?, Object?> get decoder => const _MyExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _MyExtraEncoder();
}

class _MyExtraDecoder extends Converter<Object?, Object?> {
  const _MyExtraDecoder();
  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'WorkoutPlan') {
      return WorkoutPlan(
        id: inputAsList[1] as int?,
        name: inputAsList[2] as String,
        dayOfWeek: inputAsList[3] as DaysOfWeek,
        workoutExercise: inputAsList[4] as List<WorkoutExercise>,
      );
    }

    return null;
  }
}

class _MyExtraEncoder extends Converter<Object?, Object?> {
  const _MyExtraEncoder();
  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    switch (input) {
      case WorkoutPlan workoutPlan:
        return <Object?>[
          'WorkoutPlan',
          workoutPlan.id,
          workoutPlan.name,
          workoutPlan.dayOfWeek,
          workoutPlan.workoutExercise,
        ];
      default:
        return null;
    }
  }
}
