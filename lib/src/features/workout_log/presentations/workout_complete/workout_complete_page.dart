import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/app_text_theme.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/custom_decoder.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_complete_summary.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_complete/controller/workout_complete_controller.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_complete/widgets/exercise_log_card.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

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
    final summaryState = ref.watch(workoutCompleteSummaryProvider);
    return summaryState.when(
      data: (summary) => Scaffold(
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
                      height: 200.h,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  SliverToBoxAdapter(child: 48.verticalSpace),
                  SliverToBoxAdapter(
                    child: Text(
                      "Congratulations!",
                      textAlign: TextAlign.center,
                      style: AppTextTheme.h1(context),
                    ),
                  ),
                  SliverToBoxAdapter(child: 4.verticalSpace),
                  SliverToBoxAdapter(
                    child: Text(
                      summary.workoutName,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyMedium(
                        context,
                      ).copyWith(color: context.appColors.grey600),
                    ),
                  ),
                  SliverToBoxAdapter(child: 16.verticalSpace),
                  // Main stats row
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _MainStatsRow(summary: summary),
                    ),
                  ),
                  SliverToBoxAdapter(child: 16.verticalSpace),
                  // Detailed stats
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _DetailedStatsCard(summary: summary),
                    ),
                  ),
                  SliverToBoxAdapter(child: 16.verticalSpace),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        "Exercise Details",
                        style: AppTextTheme.h3(context),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: 8.verticalSpace),
                  // Exercise progress cards
                  SliverList.separated(
                    itemCount: summary.groupedExercises.length,
                    itemBuilder: (context, index) {
                      final groupedExercise = summary.groupedExercises[index];
                      final progress = summary.exerciseProgress.firstWhere(
                        (p) => p.exerciseId == groupedExercise.exerciseId,
                        orElse: () => ExerciseProgress(
                          exerciseId: groupedExercise.exerciseId,
                          exerciseName: 'Unknown',
                          setsCompleted: 0,
                        ),
                      );
                      // Create a representative exercise log for display
                      final representativeLog = ExerciseLogsDTO(
                        exerciseId: groupedExercise.exerciseId,
                        sets: groupedExercise.totalSets,
                        reps: groupedExercise.totalReps,
                        weight:
                            groupedExercise.maxWeight ??
                            groupedExercise.averageWeight,
                        duration: groupedExercise.totalDuration,
                      );
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: ExerciseLogCard(
                          exerciseLog: representativeLog,
                          progress: progress,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 8.verticalSpace,
                  ),
                  SliverToBoxAdapter(child: 16.verticalSpace),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  blastDirection: pi / 2,
                  particleDrag: 0.05,
                  emissionFrequency: 0.05,
                  gravity: 0.01,
                  shouldLoop: false,
                  maxBlastForce: 5,
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
          padding: EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  (error as Failure).message,
                  style: AppTextTheme.bodyMedium(context),
                ),
                8.verticalSpace,
                Text(st.toString(), style: AppTextTheme.bodySmall(context)),
              ],
            ),
          ),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _MainStatsRow extends StatelessWidget {
  const _MainStatsRow({required this.summary});

  final WorkoutCompleteSummary summary;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: appColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: appColors.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'Duration',
              value: _formatDurationShort(summary.workoutLog.duration),
              progress: summary.durationProgress,
              icon: Icons.timer_outlined,
            ),
          ),
          Container(width: 1, height: 50, color: appColors.grey200),
          Expanded(
            child: _StatItem(
              label: 'Calories',
              value: summary.caloriesBurned != null
                  ? '${summary.caloriesBurned!.toInt()}'
                  : '--',
              unit: 'kcal',
              icon: Icons.local_fire_department_outlined,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    this.progress,
    this.color,
  });

  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final String? progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.iconMd, color: color ?? appColors.grey600),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: AppTextTheme.h2(context).copyWith(color: color)),
            if (unit != null) ...[
              4.horizontalSpace,
              Text(
                unit!,
                style: AppTextTheme.bodySmall(
                  context,
                ).copyWith(color: appColors.grey600),
              ),
            ],
          ],
        ),
        if (progress != null) ...[
          4.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: progress!.startsWith('+')
                  ? appColors.success.withValues(alpha: 0.1)
                  : appColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              progress!,
              style: AppTextTheme.labelSmall(context).copyWith(
                color: progress!.startsWith('+')
                    ? appColors.success
                    : appColors.error,
                fontSize: 10.sp,
              ),
            ),
          ),
        ] else
          4.verticalSpace,
        Text(
          label,
          style: AppTextTheme.bodySmall(
            context,
          ).copyWith(color: appColors.grey600),
        ),
      ],
    );
  }
}

class _DetailedStatsCard extends StatelessWidget {
  const _DetailedStatsCard({required this.summary});

  final WorkoutCompleteSummary summary;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: appColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: appColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workout Summary', style: AppTextTheme.h4(context)),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Total Sets',
                  value: summary.totalSets.toString(),
                  progress: summary.setsProgress,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: _SummaryItem(
                  label: 'Total Reps',
                  value: summary.totalReps.toString(),
                  progress: summary.repsProgress,
                ),
              ),
            ],
          ),
          if (summary.totalVolume > 0) ...[
            16.verticalSpace,
            _SummaryItem(
              label: 'Total Volume',
              value: '${summary.totalVolume.toStringAsFixed(1)} kg',
              progress: summary.volumeProgress,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value, this.progress});

  final String label;
  final String value;
  final String? progress;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: AppTextTheme.h3(context)),
            if (progress != null) ...[
              8.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: progress!.startsWith('+')
                      ? appColors.success.withValues(alpha: 0.1)
                      : appColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  progress!,
                  style: AppTextTheme.labelSmall(context).copyWith(
                    color: progress!.startsWith('+')
                        ? appColors.success
                        : appColors.error,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
        4.verticalSpace,
        Text(
          label,
          style: AppTextTheme.bodySmall(
            context,
          ).copyWith(color: appColors.grey600),
        ),
      ],
    );
  }
}
