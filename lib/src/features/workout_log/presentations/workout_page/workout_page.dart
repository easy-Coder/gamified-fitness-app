import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/controller/workout_log_controller.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/workout_log_duration.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key, required this.workoutPlanId});

  final int workoutPlanId;

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  Duration _duration = Duration.zero;
  bool isTimerActive = true;
  bool isDone = false;

  List<ExercisesLog> exerciseLogs = [];

  @override
  void initState() {
    super.initState();
    ref.listenManual(workoutLogControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        debugPrint((state.error! as Failure).message);
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
      } else if (!state.isLoading && state.hasValue) {
        context.showSuccessBar(
          content: const Text('Workout has been logged successfully'),
          position: FlashPosition.top,
        );
        context.goNamed(AppRouter.stats.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutPlan = ref.watch(workoutPlanProvider(widget.workoutPlanId));
    return workoutPlan.when(
      data: (data) {
        final plan = data.$1;
        return KeyboardDismissOnTap(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              scrolledUnderElevation: 0,
              title: Column(
                children: [
                  WorkoutLogDuration(
                    onDurationChanged: (duration) {
                      setState(() {
                        _duration = duration;
                      });
                    },
                    isActive: isTimerActive,
                  ),
                  Text(plan.name, style: TextStyle(fontSize: 16)),
                ],
              ),
              actions: [
                ShadButton.link(
                  child: Text("Finish"),
                  onPressed: () async {
                    setState(() {
                      isTimerActive = false;
                    });
                    setState(() {});
                    if (_duration == Duration.zero) {
                      ref.read(loggerProvider).d("Duration is zero");
                      return;
                    }
                    setState(() {
                      isDone = true;
                    });
                    ref.read(loggerProvider).d("Saving logs");
                    if (exerciseLogs.isEmpty) {
                      context.showErrorBar(
                        content: Text("Exercises logs are empty"),
                        position: FlashPosition.top,
                      );
                      return;
                    }
                    final log = WorkoutLog(
                      planId: plan.id!,
                      duration: _duration,
                      exerciseLogs: exerciseLogs,
                    );
                    ref.read(loggerProvider).d("Log: $log");
                    await ref
                        .read(workoutLogControllerProvider.notifier)
                        .addWorkoutLog(log);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                spacing: 12,
                children: plan.workoutExercise
                    .map(
                      (workoutExercise) => ExerciseCard(
                        isDone: isDone,
                        workoutExcercise: workoutExercise,
                        onSaveAll: (logs) {
                          setState(() {
                            exerciseLogs.addAll(logs);
                          });
                          context.showInfoBar(
                            content: Text(
                              "Added all sets for ${workoutExercise.exercise.name}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                        onSave: (log) {
                          ref.read(loggerProvider).d("Exercise Log: $log");
                          setState(() {
                            exerciseLogs.add(log);
                          });
                          context.showInfoBar(
                            content: Text(
                              "Added a set for ${workoutExercise.exercise.name}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
      error: (error, _) {
        return Scaffold(body: Text(error.toString()));
      },
      loading: () => CircularProgressIndicator.adaptive(),
    );
  }
}

class ExerciseCard extends ConsumerStatefulWidget {
  const ExerciseCard({
    super.key,
    required this.workoutExcercise,
    required this.onSave,
    required this.isDone,
    required this.onSaveAll,
  });

  final WorkoutExercise workoutExcercise;
  final bool isDone;
  final void Function(ExercisesLog logs) onSave;
  final void Function(List<ExercisesLog> logs) onSaveAll;

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard> {
  List<ExercisesLog> logs = [];

  @override
  void initState() {
    super.initState();
    logs = List.generate(
      1,
      (index) => ExercisesLog(
        set: index + 1,
        reps: 3,
        weight: 20,
        exerciseId: widget.workoutExcercise.exercise.exerciseId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.workoutExcercise.exercise.gifUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: widget.workoutExcercise.exercise.name.toTitleCase(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.pushNamed(
                        AppRouter.exerciseDetail.name,
                        pathParameters: {
                          "id": widget.workoutExcercise.exercise.exerciseId,
                        },
                      ),
                  ),

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              24.horizontalSpace,
              ShadButton(
                // size: ShadButtonSize.sm,
                padding: EdgeInsets.zero,
                foregroundColor: Colors.grey,
                backgroundColor: Colors.transparent,
                pressedBackgroundColor: Colors.transparent,
                child: Icon(Icons.more_vert_rounded, size: 24.w),
              ),
            ],
          ),
          12.verticalSpace,

          DataTable(
            // horizontalMargin: 48,
            columns: <DataColumn>[
              DataColumn(label: Text('Set')),
              DataColumn(label: Text('Reps')),
              DataColumn(label: Text('Weight')),
              DataColumn(
                label: Flexible(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onSaveAll(logs);
                    },
                    child: Icon(LucideIcons.check, color: Colors.green),
                  ),
                ),
                columnWidth: FlexColumnWidth(40),
                headingRowAlignment: MainAxisAlignment.center,
              ),
              DataColumn(
                label: Text(''),
                columnWidth: FlexColumnWidth(40),
                headingRowAlignment: MainAxisAlignment.center,
              ),
            ],
            rows: List.generate(
              logs.length,
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text("${index + 1}", textAlign: TextAlign.center)),
                  DataCell(
                    _dataInputField(
                      placeholder: "0",
                      onChanged: (value) => logs[index] = logs[index].copyWith(
                        reps: int.parse(value),
                      ),
                    ),
                  ),
                  DataCell(
                    _dataInputField(
                      placeholder: "kg",
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) => logs[index] = logs[index].copyWith(
                        weight: double.parse(value),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(child: Icon(LucideIcons.check, color: Colors.green)),
                    onTap: () {
                      widget.onSave(logs[index]);
                    },
                  ),
                  DataCell(
                    Center(child: Icon(LucideIcons.trash, color: Colors.red)),
                    onTap: () {
                      setState(() {
                        logs.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          ShadButton(
            leading: Icon(LucideIcons.plus),
            size: ShadButtonSize.lg,
            width: double.infinity,
            backgroundColor: Colors.grey,
            decoration: ShadDecoration(
              border: ShadBorder.fromBorderSide(
                ShadBorderSide.none,
                radius: BorderRadius.circular(24.r),
              ),
            ),
            onPressed: () => setState(() {
              logs.add(
                ExercisesLog(
                  set: logs.length + 1,
                  exerciseId: widget.workoutExcercise.exercise.exerciseId,
                ),
              );
            }),
            child: Text("Add Log"),
          ),
        ],
      ),
    );
  }

  Widget _dataInputField({
    required String placeholder,
    required void Function(String value) onChanged,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey.withAlpha(250)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
      ),
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
    );
  }
}
