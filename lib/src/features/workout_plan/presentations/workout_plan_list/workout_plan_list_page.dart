import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutPlanListPage extends ConsumerWidget {
  const WorkoutPlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutPlanState = ref.watch(workoutPlansProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          title: Text('Workout Plans'),
          actions: [
            ShadButton(
              onPressed: () => context.pushNamed(AppRouter.createPlan.name),
              icon: Icon(Icons.add),
              decoration: ShadDecoration(shape: BoxShape.circle),
            ),
          ],
        ),
        workoutPlanState.when(
          data:
              (workoutPlans) =>
                  workoutPlans.isEmpty
                      ? SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          spacing: 8,
                          children: [
                            Assets.svg.empty.svg(height: 180, width: 180),
                            Text(
                              'You haven\'t created a plan. ',
                              style: ShadTheme.of(context).textTheme.h4,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Press the \'+\' icon to add',
                              style: ShadTheme.of(context).textTheme.muted,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList.separated(
                          itemCount: workoutPlans.length + 1,
                          itemBuilder:
                              (context, index) =>
                                  index == workoutPlans.length
                                      ? 40.verticalSpace
                                      : WorkoutPlanCard(
                                        workoutPlan: workoutPlans[index],
                                      ),
                          separatorBuilder: (context, index) => 8.verticalSpace,
                        ),
                      ),

          loading:
              () => SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
          error: (error, trace) {
            debugPrintStack(stackTrace: trace);
            return SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Text(
                    (error).toString(),
                    style: ShadTheme.of(
                      context,
                    ).textTheme.muted.copyWith(color: Colors.redAccent),
                  ),
                  ShadButton(
                    child: Text('Retry'),
                    onPressed: () => ref.refresh(workoutPlansProvider),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class WorkoutPlanCard extends StatelessWidget {
  const WorkoutPlanCard({super.key, required this.workoutPlan});

  final WorkoutPlan workoutPlan;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            AppRouter.workoutPlan.name,
            pathParameters: {'id': workoutPlan.id!.toString()},
          ),
      child: Container(
        height: 180.h,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          image: DecorationImage(
            image: Assets.images.workouts.manWorkingout.provider(),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 2,
                  children: List.generate(
                    3,
                    (index) => Assets.svg.flame.svg(width: 16, height: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withAlpha(100),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    workoutPlan.dayOfWeek.name.capitalize(),
                    style: ShadTheme.of(
                      context,
                    ).textTheme.small.copyWith(color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              workoutPlan.name,
              style: ShadTheme.of(
                context,
              ).textTheme.h3.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
