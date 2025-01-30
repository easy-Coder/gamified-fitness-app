import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/today_workout.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/stats/presentations/controller/stat_overview_controller.dart';
import 'package:gamified/src/features/stats/presentations/widgets/hydration_progress.dart';
import 'package:gamified/src/features/stats/presentations/widgets/overview_section.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(statOverviewControllerProvider);
    ref.listen(statOverviewControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasValue) {
        final workoutplans = state.value!.workoutPlans;
        final plan = workoutplans.where((workoutPlan) {
          final today = DaysOfWeek.values[DateTime.now().weekday - 1];
          return workoutPlan.dayOfWeek == today;
        }).toList();
        print(plan);
        if (plan.isNotEmpty) {
          ref.read(todayWorkoutProvider.notifier).setTodayPlan(plan[0]);
        }
      }
    });
    return SafeArea(
      child: overviewState.when(
        data: (data) => SingleChildScrollView(
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
                          data.user.userMetadata!['username'],
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
        error: (error, st) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((error as Failure).message),
              // button for retry,
              PrimaryButton(
                title: 'Retry',
                onTap: () => ref.invalidate(statOverviewControllerProvider),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  Widget _buildNextWorkoutCard(List<WorkoutPlan> workoutPlans) {
    final today = DateTime.now();
    // check for logs
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: DaysOfWeek.values.map((day) {
        final isToday = day.index == today.weekday - 1;
        return Column(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.r,
                ),
                border: Border.all(
                  color: Colors.grey.shade800,
                  width: isToday ? 2 : 1,
                ),
                color: Colors.grey.shade300,
              ),
            ),
            4.verticalSpace,
            Text(
              day.name[0],
            ),
          ],
        );
      }).toList(),
    );
  }
}

class NextExcerciseCard extends StatelessWidget {
  const NextExcerciseCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: Assets.images.manWorkingout.provider(),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
        ),
      ),
      padding: EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
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
                    Text(
                      'Hamstring\'s Day',
                      style: ShadTheme.of(context).textTheme.h3.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              ShadButton.secondary(
                onPressed: () {
                  context.go(AppRouter.workout.name);
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
            progress: 0,
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

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
