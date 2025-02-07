import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EditPlanPage extends ConsumerStatefulWidget {
  const EditPlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPlanPageState();
}

class _EditPlanPageState extends ConsumerState<EditPlanPage> {
  DaysOfWeek selected = DaysOfWeek.Monday;

  final workOutNameController = TextEditingController();

  List<WorkoutExcercise> workouts = [];

  @override
  void initState() {
    super.initState();

    // ref.listenManual(createWorkoutPlanControllerProvider, (state, _) {
    //  if (!state!.isLoading && state.hasError) {
    //    context.showErrorBar(
    //      content: Text((state.error! as Failure).message),
    //      position: FlashPosition.top,
    //    );
    //  }
    //  if (!state.isLoading && state.hasValue) {
    //    context.showSuccessBar(
    //      content: const Text('Workout plan created successfully'),
    //      position: FlashPosition.top,
    //    );
    //  }
    //});
  }

  @override
  Widget build(BuildContext context) {
    // final createWorkoutAsync = ref.watch(createWorkoutPlanControllerProvider);
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
            context.pop();
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
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 56,
              ),
              child: ShadInput(
                controller: workOutNameController,
                placeholder: Text('Workout\'s Name (e.g Leg\'s Day)'),
                decoration: ShadDecoration(),
              ),
            ),
            8.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  'Workout Day:',
                  style: ShadTheme.of(context).textTheme.small,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    DaysOfWeek.values.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() {
                        selected = DaysOfWeek.values[index];
                      }),
                      child: Container(
                        height: 32.w,
                        width: 32.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected == DaysOfWeek.values[index]
                                ? Colors.black
                                : Colors.grey.shade200,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          DaysOfWeek.values[index].name[0],
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              'Excercises',
              style: ShadTheme.of(context)
                  .textTheme
                  .large
                  .copyWith(fontSize: 18.sp),
            ),
            8.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  if ((workouts.length == index)) {
                    return ShadButton.ghost(
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
                      icon: Icon(
                        LucideIcons.bookPlus,
                        color: Colors.grey.shade700,
                      ),
                      child: Text('Add Excercise'),
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
          onPressed: () {
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
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
