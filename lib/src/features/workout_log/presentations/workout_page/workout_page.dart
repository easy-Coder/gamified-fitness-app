import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/shared/workout_excercise/model/workout_excercise.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/controller/workout_log_controller.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_page/widgets/gif_emulator.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key, required this.workoutExercise});

  final List<WorkoutExcercise> workoutExercise;

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  int index = 0;
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 10));
    ref.listenManual(workoutLogControllerProvider, (state, _) {
      if (!state!.isLoading && !state.hasValue && state.hasError) {
        context.showErrorBar(
          content: Text((state.error! as Failure).message),
          position: FlashPosition.top,
        );
      }
      if (!state.isLoading && !state.hasError && state.hasValue) {
        context.showSuccessBar(
          content: const Text('Workout log successfully'),
          position: FlashPosition.top,
        );
        _controller.play();
        _controller.addListener(navigateWhenDone);
      }
    });
  }

  void navigateWhenDone() {
    if (_controller.state == ConfettiControllerState.stopped) {
      context.goNamed(AppRouter.stats.name);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(navigateWhenDone);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutLog = ref.watch(workoutLogControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: Column(
              children: [
                // title and view instruction
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.workoutExercise[index].exercise.name,
                        style: GoogleFonts.rubik(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade800,
                        textStyle: GoogleFonts.rubik(),
                      ),
                      child: const Text('View Instructions'),
                    ),
                  ],
                ),
                24.verticalSpace,
                // images
                GifEmulator(
                  imagePaths: widget.workoutExercise[index].exercise.images,
                ),
                24.verticalSpace,
                // reps and set
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${widget.workoutExercise[index].reps.toString()} reps',
                        style: GoogleFonts.rubik(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' X ',
                        style: GoogleFonts.rubik(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${widget.workoutExercise[index].sets.toString()} sets',
                        style: GoogleFonts.rubik(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _controller,
            blastDirection: -pi / 2,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: index == widget.workoutExercise.length - 1
              ? () {
                  final today = DateTime.now();
                  WorkoutLog log = WorkoutLog(
                    stamina: 0,
                    endurance: 0,
                    agility: 0,
                    strength: 0,
                    dayOfWeek: DaysOfWeek.values[today.weekday - 1],
                  );
                  for (var we in widget.workoutExercise) {
                    final exercise = classifyExercise(we.exercise.category);
                    if (exercise == 'strength') {
                      log = log.copyWith(
                        strength: log.strength + (we.reps * we.sets) * 10,
                      );
                    }
                    if (exercise == 'endurance') {
                      log = log.copyWith(
                        endurance: log.endurance + (we.reps * we.sets) * 10,
                      );
                    }
                    if (exercise == 'agility') {
                      log = log.copyWith(
                        agility: log.agility + (we.reps * we.sets) * 10,
                      );
                    }
                    if (exercise == 'stamina') {
                      log = log.copyWith(
                        stamina: log.stamina + (we.reps * we.sets) * 10,
                      );
                    }
                  }
                  ref
                      .read(workoutLogControllerProvider.notifier)
                      .addWorkoutLog(log);
                }
              : () {
                  setState(() {
                    index++;
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
          child: index == widget.workoutExercise.length - 1
              ? workoutLog.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('End Workout')
              : const Text('Next'),
        ),
      ),
    );
  }

  String classifyExercise(String category) {
    switch (category.toLowerCase()) {
      case 'strength':
      case 'powerlifting':
      case 'strongman':
      case 'olympic weightlifting':
        return 'strength';

      case 'cardio':
        return 'endurance';

      case 'plyometrics':
        return 'agility';

      case 'stretching':
        return 'stamina';

      default:
        return 'other';
    }
  }
}
