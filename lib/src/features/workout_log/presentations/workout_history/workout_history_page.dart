import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_overview_provider.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_service.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/controller/workout_history_controller.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_card.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_empty_state.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_overview_card.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_overview_skeleton.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutHistoryPage extends ConsumerWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final historyAsync = ref.watch(workoutHistoryProvider);
    final selectedMonth = ref.watch(workoutHistorySelectedMonthProvider);
    final today = ref.watch(workoutHistoryNowProvider).date;
    final overviewAsync = ref.watch(
      workoutHistoryOverviewProvider(selectedMonth),
    );
    final monthController = ref.read(
      workoutHistorySelectedMonthProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History', style: theme.textTheme.large),
        titleTextStyle: theme.textTheme.large.copyWith(
          color: context.appColors.onSurface,
        ),
      ),
      body: historyAsync.when(
        data: (history) {
          final monthStart = DateTime(
            selectedMonth.year,
            selectedMonth.month,
            1,
          );
          final monthEnd = DateTime(
            selectedMonth.year,
            selectedMonth.month + 1,
            1,
          );
          final monthlyHistory = history.where((item) {
            final date = item.workoutLog.workoutDate;
            if (date == null) return false;
            final workoutDay = date.date;
            return !workoutDay.isBefore(monthStart) &&
                workoutDay.isBefore(monthEnd);
          }).toList();

          final showEmptyMonthlyState = monthlyHistory.isEmpty;
          final itemCount = showEmptyMonthlyState
              ? 2
              : monthlyHistory.length + 1;

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == 0) {
                return overviewAsync.when(
                  data: (overview) => WorkoutHistoryOverviewCard(
                    overview: overview,
                    onPrevious: monthController.previousMonth,
                    onNext: monthController.nextMonth,
                    canGoNext: monthController.canGoNext(today),
                  ),
                  loading: () => const WorkoutHistoryOverviewSkeleton(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              }

              if (showEmptyMonthlyState) {
                return const WorkoutHistoryEmptyState(
                  subtitle: 'Complete workouts this month to see them here',
                );
              }

              final item = monthlyHistory[index - 1];
              return WorkoutHistoryCard(item: item);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
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
