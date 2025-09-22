// https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaimon/gaimon.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/workout_exercise_card.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/features/workout_plan/presentations/create_plan/controller/create_workout_plan_controller.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  const CreatePlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  DaysOfWeek selected = DaysOfWeek.monday;

  final workOutNameController = TextEditingController();

  List<WorkoutExercise> workouts = [];

  @override
  void initState() {
    super.initState();

    ref.listenManual(createWorkoutPlanControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        debugPrint((state.error! as Failure).message);
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
      } else if (!state.isLoading && state.hasValue) {
        context.showSuccessBar(
          content: const Text('Workout plan created successfully'),
          position: FlashPosition.top,
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
                                as List<Exercise>;
                        if (excercise.isEmpty) return;
                        setState(() {
                          workouts = excercise
                              .map((e) => WorkoutExercise(exercise: e))
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
                                  final duration = await _showModalSheet(
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
                  WorkoutPlan(
                    name: workOutNameController.text,
                    dayOfWeek: selected,
                    workoutExercise: workouts,
                  ),
                );
          },
          isLoading: createWorkoutAsync.isLoading,
          title: 'Submit',
        ),
      ),
    );
  }

  Future<Duration?> _showModalSheet(BuildContext context) {
    // Use ModalSheetRoute to show a modal sheet with imperative Navigator API.
    // It works with any *Sheet provided by this package!
    final modalRoute = ModalSheetRoute<Duration>(
      // Enable the swipe-to-dismiss behavior.
      swipeDismissible: false,
      // Use `SwipeDismissSensitivity` to tweak the sensitivity of the swipe-to-dismiss behavior.
      builder: (context) => RestTimerModal(),
    );

    return Navigator.push<Duration>(context, modalRoute);
  }
}

class RestTimerModal extends StatefulWidget {
  const RestTimerModal({super.key});

  @override
  State<RestTimerModal> createState() => _RestTimerModalState();
}

class _RestTimerModalState extends State<RestTimerModal> {
  int seconds = 0;
  int minutes = 0;
  @override
  Widget build(BuildContext context) {
    return Sheet(
      snapGrid: const SheetSnapGrid.single(snap: SheetOffset(0.3)),
      initialOffset: const SheetOffset(0.3),
      decoration: MaterialSheetDecoration(
        size: SheetSize.fit,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              "Add Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            20.verticalSpace,
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.5,
                          onSelectedItemChanged: (index) {
                            Gaimon.selection();
                            setState(() {
                              minutes = index;
                            });
                          },
                          physics: FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) => Center(
                              child: Text(
                                (index).toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                      SizedBox(
                        width: 40,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.5,
                          onSelectedItemChanged: (index) {
                            Gaimon.selection();
                            setState(() {
                              seconds = index;
                            });
                          },
                          physics: FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) => Center(
                              child: Text(
                                (index).toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            PrimaryButton(
              title: "Add Rest Timer",
              onTap: () {
                Gaimon.selection();
                final duration = Duration(seconds: seconds, minutes: minutes);
                context.pop(duration);
              },
            ),
          ],
        ),
      ),
    );
  }
}

String formatTime(Duration? restTime) {
  if (restTime == null) return "00:00";

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final hours = restTime.inHours;
  final minutes = restTime.inMinutes.remainder(60);
  final seconds = restTime.inSeconds.remainder(60);

  final buffer = StringBuffer();

  if (hours > 0) {
    buffer.write(twoDigits(hours));
    if (hours > 1) {
      buffer.write('hrs ');
    } else {
      buffer.write('hr ');
    }
  }

  if (minutes > 0) {
    buffer.write(twoDigits(minutes));
    if (minutes > 1) {
      buffer.write('mins ');
    } else {
      buffer.write('min ');
    }
  }

  if (seconds > 0) {
    buffer.write(twoDigits(seconds));
    if (seconds > 1) {
      buffer.write('secs');
    } else {
      buffer.write('sec');
    }
  }

  return buffer.toString();
}
