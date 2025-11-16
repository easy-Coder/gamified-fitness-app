import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/format_time.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutHistoryPage extends ConsumerWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          leading: Icon(LucideIcons.arrowLeft, size: AppSpacing.iconMd),
          backgroundColor: Colors.transparent,
          foregroundColor: context.appColors.onSurface,
          onPressed: () => context.pop(),
          decoration: ShadDecoration(shape: BoxShape.circle),
        ),
        title: Text('Workout History', style: theme.textTheme.large),
        titleTextStyle: theme.textTheme.large,
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.dumbbell,
                    size: 64,
                    color: context.appColors.grey400,
                  ),
                  16.verticalSpace,
                  Text(
                    'No workout history yet',
                    style: theme.textTheme.muted.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Complete your first workout to see it here',
                    style: theme.textTheme.muted.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return _WorkoutHistoryCard(
                item: item,
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.appColors.error,
              ),
              16.verticalSpace,
              Text(
                'Error loading workout history',
                style: theme.textTheme.muted.copyWith(fontSize: 16.sp),
              ),
              16.verticalSpace,
              TextButton(
                onPressed: () => ref.refresh(workoutHistoryProvider),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final WorkoutHistoryItem item;

  const _WorkoutHistoryCard({required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final workoutDay = DateTime(date.year, date.month, date.day);

    if (workoutDay == today) {
      return 'Today';
    } else if (workoutDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.workoutName,
                    style: theme.textTheme.h4.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _formatDate(item.workoutLog.workoutDate),
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  formatTime(item.workoutLog.duration),
                  "Duration",
                  LucideIcons.timer,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: context.appColors.grey200,
                ),
                _buildStatItem(
                  context,
                  item.totalWeight > 0
                      ? '${item.totalWeight.toStringAsFixed(0)} kg'
                      : 'N/A',
                  "Total Weight",
                  LucideIcons.dumbbell,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: context.appColors.grey200,
                ),
                _buildStatItem(
                  context,
                  item.totalReps > 0 ? item.totalReps.toString() : 'N/A',
                  "Total Reps",
                  LucideIcons.rotateCw,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: context.appColors.grey200,
                ),
                _buildStatItem(
                  context,
                  item.totalSets.toString(),
                  "Total Sets",
                  LucideIcons.check,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = ShadTheme.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSm,
            color: context.appColors.grey600,
          ),
          6.verticalSpace,
          Text(
            value,
            style: theme.textTheme.h4.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Text(
            label,
            style: theme.textTheme.muted.copyWith(fontSize: 10.sp),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

