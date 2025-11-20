import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/features/workout_log/model/workout_history_overview.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutHistoryOverviewCard extends StatelessWidget {
  const WorkoutHistoryOverviewCard({
    super.key,
    required this.overview,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  final WorkoutHistoryOverview overview;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final monthLabel = DateFormat('MMMM yyyy').format(overview.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: 120.w,
            height: 120.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Assets.svg.flame.svg(width: 120.w, height: 120.w),
                Positioned(
                  bottom: 32.w,
                  child: Text(
                    '${overview.currentStreak}',
                    style: theme.textTheme.h2.copyWith(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        12.verticalSpace,
        Text(
          'Day streak',
          textAlign: TextAlign.center,
          style: theme.textTheme.muted.copyWith(fontSize: 14.sp),
        ),
        4.verticalSpace,
        Text(
          '${overview.currentStreak} days',
          textAlign: TextAlign.center,
          style: theme.textTheme.h3.copyWith(fontSize: 22.sp),
        ),
        24.verticalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left_rounded),
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Text(
                    monthLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.h4.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: canGoNext ? onNext : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workouts this month',
                      style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                    ),
                    6.verticalSpace,
                    Text(
                      '${overview.workoutsThisMonth}',
                      style: theme.textTheme.h3.copyWith(fontSize: 24.sp),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total workouts',
                      style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                    ),
                    6.verticalSpace,
                    Text(
                      '${overview.totalWorkouts}',
                      style: theme.textTheme.h3.copyWith(fontSize: 24.sp),
                    ),
                  ],
                ),
              ],
            ),
            20.verticalSpace,
            const WeekdayLabels(),
            8.verticalSpace,
            WorkoutCalendarGrid(days: overview.days),
          ],
        ),
      ],
    );
  }
}

class WeekdayLabels extends StatelessWidget {
  const WeekdayLabels({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final textStyle = ShadTheme.of(context)
        .textTheme
        .muted
        .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (label) => Expanded(
              child: Center(child: Text(label, style: textStyle)),
            ),
          )
          .toList(),
    );
  }
}

class WorkoutCalendarGrid extends StatelessWidget {
  const WorkoutCalendarGrid({super.key, required this.days});

  final List<WorkoutCalendarDay> days;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GridView.builder(
      itemCount: days.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final isHighlight = day.hasWorkout;
        final backgroundColor = isHighlight
            ? colors.primary
            : day.isCurrentMonth
                ? colors.surfaceContainer
                : colors.surface;
        final textColor = isHighlight
            ? colors.onPrimary
            : day.isCurrentMonth
                ? colors.onSurface
                : colors.grey400;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: day.isToday ? colors.primary : Colors.transparent,
              width: day.isToday ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '${day.date.day}',
              style: ShadTheme.of(context).textTheme.h4.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
            ),
          ),
        );
      },
    );
  }
}

