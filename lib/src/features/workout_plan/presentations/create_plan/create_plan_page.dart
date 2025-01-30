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
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  const CreatePlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  DaysOfWeek selected = DaysOfWeek.Monday;

  final workOutNameController = TextEditingController();

  List<WorkoutExcercise> workouts = [];

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
      if (!state.isLoading && state.hasValue) {
        context.showSuccessBar(
          content: const Text('Workout plan created successfully'),
          position: FlashPosition.top,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final createWorkoutAsync = ref.watch(createWorkoutPlanControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            size: 24,
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          onPressed: () {
            context.goNamed(AppRouter.stats.name);
          },
          decoration: ShadDecoration(
            shape: BoxShape.circle,
          ),
        ),
        title: const Text('Create Workout Plan'),
        titleTextStyle: ShadTheme.of(context).textTheme.large,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: workOutNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color: Colors.grey.shade900,
                  ),
                ),
                hintText: 'Workout\'s Name (e.g Leg\'s Day)',
                hintStyle: GoogleFonts.rubik(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
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
                DropdownButton(
                  value: selected,
                  underline: const SizedBox.shrink(),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: DaysOfWeek.Monday,
                      child: Text('Monday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Tuesday,
                      child: Text('Tuesday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Wednesday,
                      child: Text('Wednesday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Thursday,
                      child: Text('Thursday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Friday,
                      child: Text('Friday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Saturday,
                      child: Text('Saturday'),
                    ),
                    DropdownMenuItem(
                      value: DaysOfWeek.Sunday,
                      child: Text('Sunday'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selected = value!;
                    });
                  },
                ),
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
                  if ((workouts.length == index)) {
                    return TextButton.icon(
                      onPressed: () async {
                        final excercise = await context.pushNamed(
                            AppRouter.excercise.name,
                            extra: workouts
                                .map((we) => we.exercise)
                                .toList()) as List<Excercise>;
                        if (excercise.isEmpty) return;
                        setState(() {
                          workouts = excercise
                              .map((e) => WorkoutExcercise(
                                  exercise: e, sets: 0, reps: 0))
                              .toList();
                        });
                      },
                      label: Text(
                        'Add Excercise',
                        style: GoogleFonts.rubik(
                          color: Colors.grey.shade800,
                        ),
                      ),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedTaskAdd01,
                        color: Colors.grey.shade700,
                      ),
                    );
                  } else {
                    final workoutExcercise = workouts[index];
                    return WorkoutExcerciseEditCard(
                      workoutExcercise: workouts[index],
                      onRepsChange: (reps) {
                        if (reps.isNotEmpty) {
                          workouts[index] =
                              workoutExcercise.copyWith(reps: int.parse(reps));
                        }
                      },
                      onSetsChange: (sets) {
                        if (sets.isNotEmpty) {
                          workouts[index] =
                              workoutExcercise.copyWith(sets: int.parse(sets));
                        }
                      },
                    );
                  }
                },
                separatorBuilder: (context, index) => 8.verticalSpace,
                itemCount: workouts.length + 1,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: createWorkoutAsync.isLoading
              ? null
              : () {
                  // if (workOutNameController.text.isEmpty) return;
                  // ref
                  //     .read(createWorkoutPlanControllerProvider.notifier)
                  //     .creatWorkoutPlan(
                  //       WorkoutPlan(
                  //         null,
                  //         workOutNameController.text,
                  //         selected,
                  //         null,
                  //       ),
                  //       workouts,
                  //     );
                  workouts.forEach((e) {
                    print('${e.sets} - ${e.reps}');
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
            textStyle: GoogleFonts.rubik(
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: createWorkoutAsync.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Text('Submit'),
        ),
      ),
    );
  }
}
