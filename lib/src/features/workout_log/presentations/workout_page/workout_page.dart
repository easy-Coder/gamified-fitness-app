import 'dart:ui';

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaimon/gaimon.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/common/util/haptic_util.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/controller/workout_log_controller.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/exercise_card.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/rest_countdown_modal.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/workout_log_duration.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';
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
  bool isTimerActive = true;
  bool isDone = false;
  late WorkoutLog log;

  Map<String, List<ExercisesLog>> exerciseLogs = {};

  Widget? countDownWidget;

  @override
  void initState() {
    super.initState();
    log = WorkoutLog(
      planId: widget.workoutPlanId,
      duration: Duration.zero,
      exerciseLogs: [],
    );
    ref.listenManual(workoutLogControllerProvider, (state, _) {
      if (!state!.isLoading && state.hasError) {
        debugPrint((state.error! as Failure).message);
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
      } else if (!state.isLoading && state.hasValue) {
        context.goNamed(AppRouter.complete.name, extra: log);
      }
    });
  }

  Widget adaptiveAction({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutPlan = ref.watch(workoutPlanProvider(widget.workoutPlanId));
    return workoutPlan.when(
      data: (data) {
        final plan = data.$1;
        return KeyboardDismissOnTap(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                // Handle the result from the popped route
              } else {
                // Show a confirmation dialog before allowing the pop
                final shouldPop = await showAdaptiveDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog.adaptive(
                    title: Text('Cancel Session'),
                    content: Text(
                      'Are you sure you want to cancel this workout session?',
                    ),
                    actions: [
                      adaptiveAction(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).pop(false); // Close dialog
                        },
                        child: Text('No'),
                      ),
                      adaptiveAction(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).pop(true); // Close dialog
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (shouldPop! == true) {
                  if (mounted) {
                    context.pop();
                  }
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                scrolledUnderElevation: 0,
                title: Column(
                  children: [
                    WorkoutLogDuration(
                      onDurationChanged: (duration) {
                        setState(() {
                          log = log.copyWith(duration: duration);
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
                      if (log.duration == Duration.zero) {
                        ref.read(loggerProvider).d("Duration is zero");
                        return;
                      }
                      setState(() {
                        isDone = true;
                      });
                      ref.read(loggerProvider).d("Saving logs");
                      if (exerciseLogs.isEmpty) {
                        context.showErrorBar(
                          content: Text("You haven't log any exercise"),
                          position: FlashPosition.top,
                        );
                        return;
                      }
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
                  children: [
                    ...plan.workoutExercise.map(
                      (workoutExercise) => ExerciseCard(
                        isDone: isDone,
                        workoutExcercise: workoutExercise,
                        workoutLogs:
                            exerciseLogs[workoutExercise.exercise.exerciseId] ??
                            [],
                        onSave: (logs) {
                          setState(() {
                            exerciseLogs[workoutExercise.exercise.exerciseId] =
                                logs;
                          });
                          playHapticFeedback(() => Gaimon.success());

                          print("Save logs");

                          _showRestCountdownModal(
                            context,
                            workoutExercise.restTime,
                          );
                        },
                      ),
                    ),
                    80.verticalSpace,
                  ],
                ),
              ),
              floatingActionButton: countDownWidget,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.noAnimation,
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

  void _showRestCountdownModal(BuildContext context, Duration? restTime) {
    if (countDownWidget != null) {
      print("Not null");
      countDownWidget = null;
      setState(() {});
    }
    countDownWidget = RestCountDownModal(
      key:
          UniqueKey(), // flutter will not use the same widget for another duration
      restDuration: restTime!,
      onClose: () {
        countDownWidget = null;
      },
    );
  }
}
