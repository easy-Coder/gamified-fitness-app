// https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/controller/create_workout_plan_controller.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/widgets/workout_excercise_card.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan/controller/workout_plan_controller.dart';
import 'package:gamified/src/features/workout_plan/presentations/workout_plan/widget/workout_excercise_card.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class WorkoutPlanPage extends ConsumerStatefulWidget {
  const WorkoutPlanPage({
    super.key,
    required this.plan,
  });

  final WorkoutPlan? plan;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<WorkoutPlanPage> {
  bool editMode = false;
  @override
  void initState() {
    super.initState();

    ref.listenManual(createWorkoutPlanControllerProvider, (state, _) {
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
        ref.watch(workoutPlanControllerProvider(widget.plan!.planId!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan'),
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 18.sp,
          color: Colors.black,
        ),
        actions: [
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {

          //     });
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.grey[900],
          //     foregroundColor: Colors.white,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 8.w,
          //       vertical: 4.h,
          //     ),
          //     textStyle: GoogleFonts.rubik(
          //       fontSize: 16,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //   ),
          //   child: const Text('Edit Plan'),
          // ),
        ],
      ),
      body: widget.plan == null
          ? const Center(
              child: Text('Today is your rest day.'),
            )
          : workoutPlanAsync.when(
              data: (data) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.plan!.name,
                      style: GoogleFonts.rubik(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Workout Day:'),
                        Text(widget.plan!.dayOfWeek.name),
                      ],
                    ),
                    16.verticalSpace,
                    Text(
                      'Excercises',
                      style: GoogleFonts.pressStart2p(
                          color: Colors.black, fontSize: 14.sp),
                    ),
                    8.verticalSpace,
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final workoutExcercise = data[index];
                          return WorkoutExcerciseCard(
                            workoutExcercise: workoutExcercise,
                          );
                        },
                        separatorBuilder: (context, index) => 8.verticalSpace,
                        itemCount: data.length,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((error as Failure).message),
                  ElevatedButton(
                    onPressed: () {
                      ref.refresh(workoutPlanControllerProvider(1));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      textStyle: GoogleFonts.rubik(
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      bottomNavigationBar: widget.plan == null
          ? null
          : BottomAppBar(
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(AppRouter.workout.name,
                      extra: workoutPlanAsync.value!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
                  textStyle: GoogleFonts.rubik(
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Start Workout'),
              ),
            ),
    );
  }
}
