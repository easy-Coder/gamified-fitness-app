import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/stats/application/service/stats_service.dart';
import 'package:gamified/src/features/stats/presentations/widgets/overview_section.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ShadAvatar(
                  'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                  placeholder: Text('CN'),
                  size: Size.square(48),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome,",
                        style: ShadTheme.of(context).textTheme.muted.copyWith(
                              fontSize: 10,
                            ),
                      ),
                      Text(
                        user!.userMetadata!['username'],
                        style: ShadTheme.of(context).textTheme.small,
                      ),
                    ],
                  ),
                )
              ],
            ),
            8.verticalSpace,
            NextExcerciseCard(),
            12.verticalSpace,
            OverviewSection(),
            12.verticalSpace,
            HydrationCard(),
            12.verticalSpace,
            DietPlannerCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class NextExcerciseCard extends ConsumerWidget {
  const NextExcerciseCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWorkoutState = ref.watch(todayWorkoutPlanProvider);
    return todayWorkoutState.when(
      data: (plan) => Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: Assets.images.workouts.manWorkingout.provider(),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black38,
              BlendMode.darken,
            ),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Excercises',
                        style: ShadTheme.of(context).textTheme.muted.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      plan != null
                          ? Text(
                              plan.name,
                              style:
                                  ShadTheme.of(context).textTheme.h3.copyWith(
                                        color: Colors.white,
                                      ),
                            )
                          : Text(
                              'No workout plan for today.',
                              style: ShadTheme.of(context)
                                  .textTheme
                                  .h3
                                  .copyWith(color: Colors.white),
                            ),
                    ],
                  ),
                ),
                if (plan != null)
                  ShadButton.secondary(
                    onPressed: () {
                      context.pushNamed(AppRouter.workoutPlan.name,
                          extra: plan);
                    },
                    decoration: ShadDecoration(
                      shape: BoxShape.circle,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    icon: Icon(
                      LucideIcons.arrowRight,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      loading: () => Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey.shade100,
        ),
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      error: (error, _) => Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey.shade100,
        ),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (error as Failure).message,
              style:
                  ShadTheme.of(context).textTheme.p.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            ShadButton(
              child: Text('Retry'),
              onPressed: () => ref.refresh(todayWorkoutPlanProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class DietPlannerCard extends StatelessWidget {
  const DietPlannerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: Assets.images.chickenSkewers.provider(),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Next Meal',
                style: ShadTheme.of(context).textTheme.muted.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  text: '113',
                  children: [
                    TextSpan(
                      text: '/kcal',
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                            color: Colors.white60,
                          ),
                    ),
                  ],
                  style: ShadTheme.of(context).textTheme.h3.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chicken Skewer',
                      style: ShadTheme.of(context).textTheme.h3.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              ShadButton.secondary(
                decoration: ShadDecoration(
                  shape: BoxShape.circle,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                icon: Icon(
                  LucideIcons.arrowRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HydrationCard extends StatelessWidget {
  const HydrationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HydrationProgress(
            progress: 85,
            size: Size.square(70),
          ),
          20.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Daily Hydration Level',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              Text(
                '200 ml',
                style: ShadTheme.of(context).textTheme.h3,
              ),
            ],
          ),
          Spacer(),
          ShadButton.secondary(
            decoration: ShadDecoration(
              shape: BoxShape.circle,
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            icon: Icon(
              LucideIcons.plus,
            ),
          ),
        ],
      ),
    );
  }
}
