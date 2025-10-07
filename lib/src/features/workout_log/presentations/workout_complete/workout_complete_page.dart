import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/util/custom_decoder.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/workout_log/application/workout_log_service.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_complete/widgets/exercise_log_card.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

typedef TotalLogs = ({int set, int? reps, double? weight, Duration? duration});

class WorkoutCompleteScreen extends ConsumerStatefulWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  ConsumerState<WorkoutCompleteScreen> createState() =>
      _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends ConsumerState<WorkoutCompleteScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(duration: Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logState = ref.watch(todayWorkoutLog);
    return logState.when(
      data: (log) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: LottieBuilder.asset(
                      Assets.animation.trophy,
                      decoder: customDecoder,
                      repeat: false,
                      height: 240.h,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  SliverToBoxAdapter(child: 12.verticalSpace),
                  SliverToBoxAdapter(
                    child: Text(
                      "Congratulations",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: 12.verticalSpace),
                  SliverToBoxAdapter(
                    child: Container(
                      // height: 80.h,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Icon(LucideIcons.clock, size: 24.0),
                                    Text(
                                      'Duration',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                    children: _formatDuration(log.duration),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(30),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Calories Burned',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "324",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      TextSpan(text: "kcal"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: 12.verticalSpace),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Text(
                        "Workouts details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: 8.verticalSpace),
                  // the exercise and
                  SliverList.separated(
                    itemCount: log.exerciseLogs.length,

                    itemBuilder: (context, index) =>
                        ExerciseLogCard(exerciseLog: log.exerciseLogs[index]),
                    separatorBuilder: (context, index) => 8.verticalSpace,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  blastDirection: pi / 2, // radial value - LEFT
                  particleDrag: 0.05, // apply drag to the confetti
                  emissionFrequency: 0.05, // how often it should emit
                  gravity: 0.01, // gravity - or fall speed
                  shouldLoop: false,
                  maxBlastForce: 5, // set a lower max blast force
                  minBlastForce: 2,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: PrimaryButton(
            title: "Done",
            onTap: () => context.goNamed(AppRouter.stats.name),
          ),
        ),
      ),
      error: (error, st) => SafeArea(
        child: Container(
          child: SingleChildScrollView(child: Text(st.toString())),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  List<TextSpan> _formatDuration(Duration duration) {
    List<TextSpan> widgets = [];

    // Extract time components directly from Duration
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    // Format hours
    if (hours > 0) {
      widgets.addAll([
        TextSpan(
          text: hours.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        TextSpan(text: hours == 1 ? 'hr ' : 'hrs '),
      ]);
    }

    // Format minutes
    if (minutes > 0) {
      widgets.addAll([
        TextSpan(
          text: minutes.toString().padLeft(2, '0'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        TextSpan(text: minutes == 1 ? 'min ' : 'mins '),
      ]);
    }

    // Format seconds
    if (seconds > 0) {
      widgets.addAll([
        TextSpan(
          text: seconds.toString().padLeft(2, '0'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        TextSpan(text: seconds == 1 ? 'sec' : 'secs'),
      ]);
    }

    return widgets;
  }
}
