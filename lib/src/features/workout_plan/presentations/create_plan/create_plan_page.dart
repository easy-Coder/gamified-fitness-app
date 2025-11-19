// https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/util/format_time.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/controller/create_workout_plan_controller.dart';
import 'package:gamified/src/features/workout_plan/presentations/widget/rest_timer_modal.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  const CreatePlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  final workOutNameController = TextEditingController();

  List<WorkoutExerciseDTO> workouts = [];

  @override
  void initState() {
    super.initState();

    ref.listenManual(createWorkoutPlanControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        final message = (state.error! as Failure).message;
        debugPrint(message);
        Fluttertoast.showToast(msg: message);
      } else if (!state.isLoading && state.hasValue) {
        Fluttertoast.showToast(
          msg: 'Workout plan created successfully',
        );
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final createWorkoutAsync = ref.watch(createWorkoutPlanControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          leading: Icon(LucideIcons.arrowLeft, size: 24),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          onPressed: () {
            context.pop();
          },
          decoration: ShadDecoration(shape: BoxShape.circle),
        ),
        title: const Text('Create Workout Plan'),
        titleTextStyle: ShadTheme.of(context).textTheme.large,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 56),
              child: ShadInput(
                controller: workOutNameController,
                placeholder: Text('Workout\'s Name (e.g Leg\'s Day)'),
                decoration: ShadDecoration(),
              ),
            ),
            16.verticalSpace,
            Text(
              'Excercises',
              style: ShadTheme.of(
                context,
              ).textTheme.large.copyWith(fontSize: 18.sp),
            ),
            8.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  if ((workouts.length == index)) {
                    return ShadButton.ghost(
                      onPressed: () async {
                        final excercise =
                            await context.pushNamed(
                                  AppRouter.exercise.name,
                                  extra: workouts
                                      .map((we) => we.exercise)
                                      .toList(),
                                )
                                as List<ExerciseDTO>;
                        if (excercise.isEmpty) return;
                        setState(() {
                          workouts = excercise
                              .map((e) => WorkoutExerciseDTO(exercise: e))
                              .toList();
                        });
                      },
                      leading: Icon(
                        LucideIcons.bookPlus,
                        color: Colors.grey.shade700,
                      ),
                      child: Text('Add Excercise'),
                    );
                  } else {
                    final exercise = workouts[index].exercise;
                    return Row(
                      children: [
                        ShadButton.destructive(
                          onPressed: () {
                            setState(() {
                              workouts.remove(workouts[index]);
                            });
                          },
                          decoration: ShadDecoration(shape: BoxShape.circle),
                          child: Icon(LucideIcons.trash),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              WorkoutExcerciseCard(exercise: exercise),
                              4.verticalSpace,
                              GestureDetector(
                                onTap: () async {
                                  final duration =
                                      await RestTimerModal.showModalSheet(
                                        context,
                                      );
                                  setState(() {
                                    workouts[index] = workouts[index].copyWith(
                                      restTime: duration,
                                    );
                                  });
                                },
                                child: Row(
                                  spacing: 4,
                                  children: [
                                    Icon(
                                      LucideIcons.timer,
                                      color: Colors.blueAccent,
                                    ),
                                    if (workouts[index].restTime != null)
                                      Text(
                                        "Rest Time: ${formatTime(workouts[index].restTime)}",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    else
                                      Text(
                                        "Add Rest timer",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
        child: PrimaryButton(
          onTap: () {
            if (workOutNameController.text.isEmpty) return;
            ref
                .read(createWorkoutPlanControllerProvider.notifier)
                .creatWorkoutPlan(
                  WorkoutPlanDTO(
                    name: workOutNameController.text,
                    exercises: workouts,
                  ),
                );
          },
          isLoading: createWorkoutAsync.isLoading,
          title: 'Submit',
        ),
      ),
    );
  }
}
