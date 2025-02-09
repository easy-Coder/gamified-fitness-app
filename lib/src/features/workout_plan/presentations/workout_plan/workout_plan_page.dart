// https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/shared/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan/controller/workout_plan_controller.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutPlanPage extends ConsumerStatefulWidget {
  const WorkoutPlanPage({
    super.key,
    required this.plan,
  });

  final WorkoutPlan plan;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends ConsumerState<WorkoutPlanPage> {
  List<WorkoutExcercise> workoutExercises = [];

  @override
  void initState() {
    super.initState();

    ref.listenManual(workoutPlanControllerProvider(widget.plan.planId!),
        (state, _) {
      if (!state!.isLoading && state.hasError) {
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutPlanAsync =
        ref.watch(workoutPlanControllerProvider(widget.plan.planId!));

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
            child: Icon(
              LucideIcons.x,
              color: Colors.white,
            ),
          ),
        ),
        leadingWidth: 48.w,
        actions: [
          ShadButton(
            onPressed: () => context.pushReplacementNamed(
              AppRouter.editPlan.name,
              extra: (workoutPlan: widget.plan, exercises: workoutExercises),
            ),
            icon: Icon(LucideIcons.pen),
            backgroundColor: Colors.grey.withAlpha(100),
            decoration: ShadDecoration(
              shape: BoxShape.circle,
            ),
            width: 48.w,
            height: 48.w,
          ),
        ],
        backgroundColor: Colors.transparent,
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
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.plan.name,
                    style: ShadTheme.of(context).textTheme.h1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            color: Colors.white,
                          ),
                          Text(
                            widget.plan.dayOfWeek.name,
                            style:
                                ShadTheme.of(context).textTheme.muted.copyWith(
                                      color: Colors.white,
                                    ),
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
                          Icon(
                            LucideIcons.gauge,
                            color: Colors.white,
                          ),
                          Text(
                            'Intermediate',
                            style:
                                ShadTheme.of(context).textTheme.muted.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.timer,
                        color: Colors.white,
                      ),
                      4.horizontalSpace,
                      Text(
                        'Best Time: ',
                        style: ShadTheme.of(context).textTheme.muted.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                      4.horizontalSpace,
                      Text(
                        '0 minute(s)',
                        style: ShadTheme.of(context).textTheme.muted.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (widget.plan.dayOfWeek.isToday())
                    PrimaryButton(
                      title: 'Start Workout',
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onTap: () {
                        context.pushNamed(AppRouter.workout.name,
                            extra: workoutPlanAsync.value!);
                      },
                    ),
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
          workoutPlanAsync.when(
            data: (data) {
              workoutExercises = data;
              return Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    top: 0,
                    left: 8.w,
                    right: 8.w,
                    bottom: 24.h,
                  ),
                  itemBuilder: (context, index) {
                    final workoutExcercise = data[index];

                    return WorkoutExcerciseCard(
                      exercise: workoutExcercise.exercise,
                    );
                  },
                  separatorBuilder: (context, index) => 8.verticalSpace,
                  itemCount: data.length,
                ),
              );
            },
            error: (error, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((error as Failure).message),
                ShadButton(
                  onPressed: () => ref.refresh(
                      workoutPlanControllerProvider(widget.plan.planId!)),
                  child: const Text('Retry'),
                ),
              ],
            ),
            loading: () => Flexible(
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
