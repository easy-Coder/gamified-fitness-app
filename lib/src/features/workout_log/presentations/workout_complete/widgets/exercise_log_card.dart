import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_complete_summary.dart';

class ExerciseLogCard extends ConsumerWidget {
  const ExerciseLogCard({super.key, required this.exerciseLog, this.progress});

  final ExerciseLogsDTO exerciseLog;
  final ExerciseProgress? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseState = ref.watch(
      exerciseDetailsProvider(exerciseLog.exerciseId),
    );
    return exerciseState.when(
      data: (exercise) => Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.appColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: context.appColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 56.w,
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: context.appColors.info,
                    image: DecorationImage(
                      image: NetworkImage(exercise.gifUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name.toTitleCase(),
                        style: AppTextTheme.h4(context),
                      ),
                      if (progress != null && progress!.hasProgress) ...[
                        4.verticalSpace,
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (progress!.setsProgress != null)
                              _ProgressBadge(
                                text: '${progress!.setsCompleted} sets',
                                progress: progress!.setsProgress!,
                              )
                            else
                              _StatChip(
                                label: '${progress!.setsCompleted} sets',
                              ),
                            if (progress!.repsProgress != null &&
                                exerciseLog.reps != null)
                              _ProgressBadge(
                                text: '${exerciseLog.reps} reps',
                                progress: progress!.repsProgress!,
                              ),
                            if (progress!.weightProgress != null &&
                                exerciseLog.weight != null)
                              _ProgressBadge(
                                text:
                                    '${exerciseLog.weight!.toStringAsFixed(1)}kg',
                                progress: progress!.weightProgress!,
                              ),
                          ],
                        ),
                      ] else ...[
                        4.verticalSpace,
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (exerciseLog.sets > 0)
                              _StatChip(label: '${exerciseLog.sets} sets'),
                            if (exerciseLog.reps != null)
                              _StatChip(label: '${exerciseLog.reps} reps'),
                            if (exerciseLog.weight != null)
                              _StatChip(
                                label:
                                    '${exerciseLog.weight!.toStringAsFixed(1)}kg',
                              ),
                            if (exerciseLog.duration != null)
                              _StatChip(
                                label: _formatDuration(exerciseLog.duration!),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      error: (error, st) => Container(),
      loading: () => Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              height: 56.w,
              width: 56.w,
              decoration: BoxDecoration(
                color: context.appColors.grey200,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 100,
                    decoration: BoxDecoration(
                      color: context.appColors.grey200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    height: 12,
                    width: 150,
                    decoration: BoxDecoration(
                      color: context.appColors.grey200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.text, required this.progress});

  final String text;
  final String progress;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isPositive = progress.startsWith('+');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isPositive
            ? appColors.success.withValues(alpha: 0.1)
            : appColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextTheme.labelSmall(context).copyWith(fontSize: 10.sp),
          ),
          4.horizontalSpace,
          Text(
            progress,
            style: AppTextTheme.labelSmall(context).copyWith(
              color: isPositive ? appColors.success : appColors.error,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: appColors.grey200,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextTheme.labelSmall(
          context,
        ).copyWith(fontSize: 10.sp, color: appColors.grey700),
      ),
    );
  }
}
