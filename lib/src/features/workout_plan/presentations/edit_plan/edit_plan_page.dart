import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/compare_list.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/shared/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

typedef EditPlanRecord = ({
  WorkoutPlan workoutPlan,
  List<WorkoutExcercise> exercises,
});

class EditPlanPage extends ConsumerStatefulWidget {
  const EditPlanPage({super.key, required this.editPlanRecord});

  final EditPlanRecord editPlanRecord;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPlanPageState(
        editPlanRecord.workoutPlan,
        editPlanRecord.exercises,
      );
}

class _EditPlanPageState extends ConsumerState<EditPlanPage> {
  _EditPlanPageState(this.workoutPlan, this.workouts);
  WorkoutPlan workoutPlan;

  List<WorkoutExcercise> workouts = [];

  bool nameIsDirty = false;
  bool dayIsDirty = false;
  bool exerciseIsDirty = false;
  DaysOfWeek selected = DaysOfWeek.Monday;

  late final TextEditingController workOutNameController;
  @override
  void initState() {
    super.initState();

    selected = workoutPlan.dayOfWeek;

    workOutNameController = TextEditingController(
      text: workoutPlan.name,
    );

    workOutNameController.addListener(() {
      if (workoutPlan.name == workOutNameController.text) {
        setState(() {
          nameIsDirty = false;
        });
        return;
      }
      setState(() {
        nameIsDirty = true;
      });
    });

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
        title: const Text('Edit Workout Plan'),
        titleTextStyle: ShadTheme.of(context).textTheme.large,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
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
                        workoutPlan = workoutPlan.copyWith(
                          dayOfWeek: DaysOfWeek.values[index],
                        );
                        dayIsDirty = selected != DaysOfWeek.values[index];
                      }),
                      child: Container(
                        height: 32.w,
                        width: 32.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: workoutPlan.dayOfWeek ==
                                    DaysOfWeek.values[index]
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
                  .small
                  .copyWith(fontSize: 18.sp),
            ),
            8.verticalSpace,
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 80.h),
                itemBuilder: (context, index) {
                  if ((workouts.length == index)) {
                    return ShadButton.ghost(
                      onPressed: () async {
                        final excercise = await context.pushNamed(
                            AppRouter.excercise.name,
                            extra: workouts
                                .map((we) => we.exercise)
                                .toList()) as List<Excercise>;

                        final workoutsExercises = excercise
                            .map((e) =>
                                WorkoutExcercise(exercise: e, sets: 0, reps: 0))
                            .toList();
                        if (workoutsExercises.containsAll(
                            workouts, (e, o) => e.exercise == o.exercise)) {
                          setState(() {
                            exerciseIsDirty = false;
                          });
                          return;
                        }
                        setState(() {
                          workouts = workoutsExercises;
                          exerciseIsDirty = true;
                        });
                      },
                      icon: Icon(
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
                            final currWorkouts = workouts;
                            workouts.remove(workouts[index]);
                            if (workouts.containsAll(
                                    currWorkouts, (e, o) => e == o) ||
                                widget.editPlanRecord.exercises
                                    .containsAll(workouts, (e, o) => e == o)) {
                              exerciseIsDirty = false;
                              setState(() {});
                              return;
                            }
                            exerciseIsDirty = true;
                            setState(() {});
                          },
                          icon: Icon(
                            LucideIcons.trash,
                          ),
                          decoration: ShadDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: WorkoutExcerciseCard(
                            exercise: exercise,
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
      floatingActionButton: (nameIsDirty || dayIsDirty || exerciseIsDirty)
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(width: 320.w, height: 56.h),
              child: PrimaryButton(
                onTap: () {},
                title: 'Submit',
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
