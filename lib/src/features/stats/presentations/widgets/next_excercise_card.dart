import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/stats/application/service/stats_service.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NextExcerciseCard extends ConsumerWidget {
  const NextExcerciseCard({super.key});

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
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
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
                        style: ShadTheme.of(
                          context,
                        ).textTheme.muted.copyWith(color: Colors.white70),
                      ),
                      plan.$1 != null
                          ? Text(
                              plan.$1!.name,
                              style: ShadTheme.of(
                                context,
                              ).textTheme.h3.copyWith(color: Colors.white),
                            )
                          : Text(
                              'No workout plan for today.',
                              style: ShadTheme.of(
                                context,
                              ).textTheme.h3.copyWith(color: Colors.white),
                            ),
                    ],
                  ),
                ),
                if (plan.$1 != null)
                  ShadButton.secondary(
                    onPressed: plan.$2
                        ? () {
                            context.pushNamed(
                              AppRouter.workoutPlan.name,
                              pathParameters: {'id': plan.$1!.id!.toString()},
                            );
                          }
                        : null,
                    decoration: ShadDecoration(shape: BoxShape.circle),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    child: Icon(
                      plan.$2 ? LucideIcons.arrowRight : LucideIcons.check,
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
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, trace) {
        debugPrintStack(stackTrace: trace);
        return Container(
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
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              ShadButton(
                child: Text('Retry'),
                onPressed: () => ref.refresh(todayWorkoutPlanProvider),
              ),
            ],
          ),
        );
      },
    );
  }
}
