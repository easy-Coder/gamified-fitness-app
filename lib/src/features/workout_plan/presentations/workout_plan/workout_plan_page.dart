import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/data/workout_exercise_repository.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutPlanPage extends ConsumerWidget {
  const WorkoutPlanPage({super.key, required this.plan});

  final int plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutExerciseState = ref.watch(workoutPlanProvider(plan));
    return workoutExerciseState.when(
      data: (data) {
        final plan = data.$1;
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withAlpha(100),
                ),
                alignment: Alignment.center,
                child: Icon(LucideIcons.x, color: Colors.white),
              ),
            ),
            leadingWidth: 48.w,
            actions: [
              ShadButton(
                onPressed: () => context.pushReplacementNamed(
                  AppRouter.editPlan.name,
                  pathParameters: {'id': plan.id!.toString()},
                ),
                backgroundColor: Colors.grey.withAlpha(100),
                decoration: ShadDecoration(shape: BoxShape.circle),
                width: 48.w,
                height: 48.w,
                child: Icon(LucideIcons.pen, size: 18),
              ),
            ],
            backgroundColor: Colors.transparent,
            // flexibleSpace: Flexib,
          ),
          extendBodyBehindAppBar: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 280.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Assets.images.workouts.manWorkingout.provider(),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black38,
                      BlendMode.darken,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        plan.name,
                        style: ShadTheme.of(
                          context,
                        ).textTheme.h1.copyWith(color: Colors.white),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Row(
                            spacing: 4,
                            children: [
                              Icon(LucideIcons.calendar, color: Colors.white),
                              Text(
                                plan.dayOfWeek.name.capitalize(),
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.muted.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(LucideIcons.gauge, color: Colors.white),
                              Text(
                                'Intermediate',
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.muted.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(LucideIcons.timer, color: Colors.white),
                          4.horizontalSpace,
                          Text(
                            'Best Time: ',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.muted.copyWith(color: Colors.white60),
                          ),
                          4.horizontalSpace,
                          Text(
                            '0 minute(s)',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.muted.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      if (plan.dayOfWeek.isToday() && data.$2) ...[
                        16.verticalSpace,
                        PrimaryButton(
                          title: 'Start Workout',
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            context.pushNamed(
                              AppRouter.workout.name,
                              extra: plan.id,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              8.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Excercises',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
              ),
              4.verticalSpace,

              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    top: 0,
                    left: 8.w,
                    right: 8.w,
                    bottom: 24.h,
                  ),
                  itemBuilder: (context, index) {
                    final workoutExcercise = plan.exercises[index];

                    return WorkoutExcerciseCard(
                      exercise: workoutExcercise.exercise,
                    );
                  },
                  separatorBuilder: (context, index) => 8.verticalSpace,
                  itemCount: plan.exercises.length,
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text((error as Failure).message, textAlign: TextAlign.center),
            24.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                onTap: () => ref.refresh(workoutExercisesProvider(plan)),
                title: 'Retry',
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
