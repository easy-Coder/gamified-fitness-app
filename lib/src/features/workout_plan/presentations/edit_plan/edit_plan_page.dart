import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/util/compare_list.dart';
import 'package:gamified/src/common/util/format_time.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/edit_plan/controller/edit_plan_controller.dart';
import 'package:gamified/src/features/workout_plan/presentations/widget/rest_timer_modal.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EditPlanPage extends ConsumerStatefulWidget {
  const EditPlanPage({super.key, required this.planId});

  final int planId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPlanPageState();
}

class _EditPlanPageState extends ConsumerState<EditPlanPage> {
  List<WorkoutExercise>? workouts = [];
  WorkoutPlan? workoutPlan;

  String? namePlan;

  bool nameIsDirty = false;
  bool dayIsDirty = false;
  bool exerciseIsDirty = false;
  DaysOfWeek? selected;

  @override
  void initState() {
    super.initState();

    ref.listenManual(editPlanControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
        return;
      }
      if (!state.isLoading && state.hasValue) {
        context.pushReplacementNamed(AppRouter.workoutPlans.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutPlanState = ref.watch(workoutPlanProvider(widget.planId));
    final editPlanState = ref.watch(editPlanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          onPressed: () {
            context.pop();
          },
          decoration: ShadDecoration(shape: BoxShape.circle),
          child: Icon(LucideIcons.arrowLeft, size: 24),
        ),
        title: const Text('Edit Workout Plan'),
        titleTextStyle: ShadTheme.of(context).textTheme.large,
        actions: [
          ShadButton(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            onPressed: () {
              ref
                  .read(editPlanControllerProvider.notifier)
                  .deleteWorkoutPlan(workoutPlan!);
              context.showSuccessBar(
                content: const Text('Workout plan deleted successfully'),
                position: FlashPosition.top,
              );
            },
            child: Icon(LucideIcons.trash, size: 24),
          ),
        ],
      ),
      body: workoutPlanState.when(
        data: (data) {
          workoutPlan ??= data.$1;
          final plan = data.$1;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 56),
                  child: ShadInput(
                    initialValue: plan.name,
                    onChanged: (value) {
                      if (plan.name == value) {
                        setState(() {
                          nameIsDirty = false;
                        });
                        return;
                      }
                      setState(() {
                        nameIsDirty = true;
                        namePlan = value;
                      });
                    },
                    placeholder: Text('Workout\'s Name (e.g Leg\'s Day)'),
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
                            dayIsDirty = selected != plan.dayOfWeek;
                          }),
                          child: Container(
                            height: 32.w,
                            width: 32.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    selected != null &&
                                        selected == DaysOfWeek.values[index]
                                    ? Colors.black
                                    : plan.dayOfWeek == DaysOfWeek.values[index]
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade200,
                              ),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              DaysOfWeek.values[index].name[0].toUpperCase(),
                              style: ShadTheme.of(
                                context,
                              ).textTheme.small.copyWith(fontSize: 10),
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
                  style: ShadTheme.of(
                    context,
                  ).textTheme.small.copyWith(fontSize: 18.sp),
                ),
                8.verticalSpace,
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemBuilder: (context, index) {
                      // Use workoutPlan consistently throughout the code
                      if ((workoutPlan!.workoutExercise.length == index)) {
                        return ShadButton.ghost(
                          onPressed: () async {
                            final excercise =
                                await context.pushNamed(
                                      AppRouter.exercise.name,
                                      extra: workoutPlan!.workoutExercise
                                          .map((we) => we.exercise)
                                          .toList(),
                                    )
                                    as List<Exercise>;

                            final workoutsExercises = excercise.map((e) {
                              final workoutExercise = workoutPlan!
                                  .workoutExercise
                                  .firstWhere(
                                    (element) =>
                                        element.exercise.exerciseId ==
                                        e.exerciseId,
                                    orElse: () => WorkoutExercise(exercise: e),
                                  );
                              if (workoutExercise.id != null ||
                                  workoutExercise.restTime != null) {
                                return workoutExercise;
                              }
                              return WorkoutExercise(exercise: e);
                            }).toList();

                            // Check if the exercises have changed
                            if (workoutsExercises.containsAll(
                              workoutPlan!.workoutExercise,
                              (e, o) => e.exercise == o.exercise,
                            )) {
                              setState(() {
                                exerciseIsDirty = false;
                              });
                              return;
                            }

                            // Update workoutPlan with new exercises
                            setState(() {
                              workoutPlan = workoutPlan!.copyWith(
                                workoutExercise: workoutsExercises,
                              );
                              exerciseIsDirty = true;
                            });
                          },
                          leading: Icon(
                            LucideIcons.bookPlus,
                            color: Colors.grey.shade700,
                          ),
                          child: Text('Add Excercise'),
                        );
                      } else {
                        // Access exercise from workoutPlan
                        final exercise =
                            workoutPlan!.workoutExercise[index].exercise;
                        return Row(
                          children: [
                            ShadButton.destructive(
                              onPressed: () {
                                setState(() {
                                  // Create a new list without the exercise to remove
                                  final updatedExercises =
                                      List<WorkoutExercise>.from(
                                        workoutPlan!.workoutExercise,
                                      );
                                  updatedExercises.removeAt(index);

                                  // Check if the exercises have changed from original plan
                                  final hasChanged = !updatedExercises
                                      .containsAll(
                                        plan.workoutExercise,
                                        (e, o) => e.exercise == o.exercise,
                                      );

                                  // Update state
                                  workoutPlan = workoutPlan!.copyWith(
                                    workoutExercise: updatedExercises,
                                  );
                                  exerciseIsDirty = hasChanged;
                                });
                              },
                              decoration: ShadDecoration(
                                shape: BoxShape.circle,
                              ),
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
                                        if (workouts != null) {
                                          workoutPlan?.workoutExercise[index] =
                                              workoutPlan!
                                                  .workoutExercise[index]
                                                  .copyWith(restTime: duration);
                                        }
                                      });
                                    },
                                    child: Row(
                                      spacing: 4,
                                      children: [
                                        Icon(
                                          LucideIcons.timer,
                                          color: Colors.blueAccent,
                                        ),
                                        if (workoutPlan!
                                                .workoutExercise[index]
                                                .restTime !=
                                            null)
                                          Text(
                                            "Rest Time: ${formatTime(workoutPlan!.workoutExercise[index].restTime)}",
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
                    itemCount: workoutPlan!.workoutExercise.length + 1,
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => SizedBox(),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      ),
      floatingActionButton: (nameIsDirty || dayIsDirty || exerciseIsDirty)
          ? PrimaryButton(
              onTap: () {
                ref
                    .read(editPlanControllerProvider.notifier)
                    .editWorkoutPlan(
                      workoutPlan!.copyWith(
                        name: namePlan,
                        dayOfWeek: selected,
                      ),
                    );
                context.showSuccessBar(
                  content: const Text('Workout plan edited successfully'),
                  position: FlashPosition.top,
                );
              },
              isLoading: editPlanState.isLoading,
              title: 'Submit',
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
    );
  }
}
