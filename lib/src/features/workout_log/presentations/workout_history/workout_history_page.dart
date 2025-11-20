import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_overview_provider.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_service.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_card.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_empty_state.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_overview_card.dart';
import 'package:gamified/src/features/workout_log/presentations/workout_history/widgets/workout_history_overview_skeleton.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final _historySelectedMonthProvider = StateProvider<DateTime>((ref) {
  final today = ref.watch(workoutHistoryNowProvider);
  return DateTime(today.year, today.month, 1);
});

class WorkoutHistoryPage extends ConsumerWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final historyAsync = ref.watch(workoutHistoryProvider);
    final selectedMonth = ref.watch(_historySelectedMonthProvider);
    final today = ref.watch(workoutHistoryNowProvider).date;
    final overviewAsync = ref.watch(
      workoutHistoryOverviewProvider(selectedMonth),
    );

    DateTime _shiftMonth(DateTime base, int delta) {
      return DateTime(base.year, base.month + delta, 1);
    }

    bool canGoNextMonth(DateTime base, DateTime now) {
      return base.year < now.year ||
          (base.year == now.year && base.month < now.month);
    }

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
                    onPrevious: () =>
                        ref.read(_historySelectedMonthProvider.notifier).state =
                            _shiftMonth(selectedMonth, -1),
                    onNext: () =>
                        ref.read(_historySelectedMonthProvider.notifier).state =
                            _shiftMonth(selectedMonth, 1),
                    canGoNext: canGoNextMonth(selectedMonth, today),
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
