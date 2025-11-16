import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/app_text_theme.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/features/account/data/measurement_repository.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/account/presentation/measurements/controller/measurements_controller.dart';
import 'package:gamified/src/features/account/presentation/measurements/widgets/bmi_card.dart';
import 'package:gamified/src/features/account/presentation/measurements/widgets/weight_stats_card.dart';
import 'package:gamified/src/features/account/presentation/profile/widgets/profile_item.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:gamified/src/common/util/format_time.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Activity Stats Provider
class ActivityStats {
  final Duration totalDuration;
  final int totalSessions;

  ActivityStats({required this.totalDuration, required this.totalSessions});
}

final activityStatsProvider = FutureProvider<ActivityStats>((ref) async {
  final workoutLogs = await ref
      .read(workoutLogRepoProvider)
      .getAllWorkoutLogs();

  final totalDuration = workoutLogs.fold<Duration>(
    Duration.zero,
    (sum, log) => sum + log.duration,
  );

  return ActivityStats(
    totalDuration: totalDuration,
    totalSessions: workoutLogs.length,
  );
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  double titleVisibility = 0.0;

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final userAsync = ref.watch(userProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          double progress =
              notification.metrics.pixels /
              (notification.metrics.maxScrollExtent > 0
                  ? notification.metrics.maxScrollExtent
                  : 1);

          if (!progress.isNaN && notification.metrics.maxScrollExtent > 0) {
            setState(() {
              if (progress <= 0.2) {
                titleVisibility = 0.0;
              } else if (progress >= 0.6) {
                titleVisibility = 1.0;
              } else {
                // Linear interpolation between 0.2 and 0.6
                titleVisibility = ((progress - 0.2) / 0.4).clamp(0.0, 1.0);
              }
            });
          } else {
            setState(() {
              titleVisibility = 0.0;
            });
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Opacity(
              opacity: titleVisibility,
              child: userAsync.when(
                data: (user) {
                  if (user == null) return SizedBox.shrink();
                  final initials = _getInitials(user.name);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: AppSpacing.sizeLg.r,
                        backgroundColor: context.appColors.grey400,
                        child: Text(
                          initials,
                          style: AppTextTheme.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.appColors.onPrimary,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalSm.horizontalSpace,
                      Flexible(
                        child: Text(
                          user.name.isNotEmpty ? user.name : "User",
                          style: theme.textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => SizedBox.shrink(),
                error: (error, stack) => SizedBox.shrink(),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(LucideIcons.settings, size: 20),
                onPressed: () => context.pushNamed(AppRouter.settings.name),
                tooltip: 'Settings',
              ),
            ],
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: context.appColors.surface,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: userAsync.when(
                data: (user) {
                  if (user == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Text(
                          'No user data found',
                          style: theme.textTheme.muted,
                        ),
                      ),
                    );
                  }
                  final initials = _getInitials(user.name);
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: context.appColors.grey400,
                        child: Text(
                          initials,
                          style: AppTextTheme.h1(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.appColors.onPrimary,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalLg.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name.isNotEmpty ? user.name : "User",
                                    style: theme.textTheme.large.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                8.horizontalSpace,
                                IconButton(
                                  icon: Icon(
                                    LucideIcons.pen,
                                    size: AppSpacing.iconSm,
                                    color: context.appColors.grey600,
                                  ),
                                  onPressed: () async {
                                    await context.pushNamed(
                                      AppRouter.editProfile.name,
                                    );
                                    // Refresh user data when returning from edit page
                                    ref.invalidate(userProvider);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  tooltip: 'Edit profile',
                                ),
                              ],
                            ),
                            Text(
                              'Age: ${user.age > 0 ? user.age : "N/A"}',
                              style: theme.textTheme.muted.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Text(
                      'Error loading user data',
                      style: theme.textTheme.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: 8.verticalSpace),

          ProfileItem(
            leading: Icon(
              LucideIcons.dumbbell,
              color: context.appColors.grey700,
            ),
            title: 'Activity',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.appColors.grey400,
            ),
            onTap: () {
              context.pushNamed(AppRouter.workoutHistory.name);
            },
            child: _buildActivitySection(),
          ),
          ProfileItem(
            leading: Icon(
              LucideIcons.rulerDimensionLine,
              color: context.appColors.grey700,
            ),
            title: 'Measurements',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.appColors.grey400,
            ),
            onTap: () {
              context.pushNamed(AppRouter.measurements.name);
            },
            child: _buildMeasurementsSection(),
          ),
          SliverToBoxAdapter(child: 80.verticalSpace),
        ],
      ),
    );
  }

  Widget _buildMeasurementsSection() {
    final userAsync = ref.watch(measurementsControllerProvider);
    final measurementsAsync = ref.watch(measurementsProvider);

    return userAsync.when(
      data: (user) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // BMI Section
          if (user.weight != 0 && user.height != 0) ...[
            16.verticalSpace,
            BMICard(user: user),
          ],
          8.verticalSpace,
          // Weight Statistics Section
          measurementsAsync.when(
            data: (measurements) =>
                WeightStatsCard(measurements: measurements, user: user),
            loading: () => SizedBox.shrink(),
            error: (error, stack) => SizedBox.shrink(),
          ),
          // Charts Section
          measurementsAsync.when(
            data: (measurements) {
              if (measurements.isEmpty) {
                return SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  8.verticalSpace,
                  _WeightChart(measurements: measurements),
                ],
              );
            },
            loading: () => SizedBox.shrink(),
            error: (error, stack) => SizedBox.shrink(),
          ),
        ],
      ),
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => SizedBox.shrink(),
    );
  }

  Widget _buildActivitySection() {
    final activityStatsAsync = ref.watch(activityStatsProvider);
    final theme = ShadTheme.of(context);

    return activityStatsAsync.when(
      data: (stats) {
        if (stats.totalSessions == 0) {
          return Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              children: [
                Icon(
                  LucideIcons.dumbbell,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                16.verticalSpace,
                Text(
                  'No workouts yet',
                  style: theme.textTheme.muted.copyWith(fontSize: 14.sp),
                ),
                8.verticalSpace,
                Text(
                  'Start your first workout to track activity',
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildActivityStat(
                  context,
                  formatTime(stats.totalDuration),
                  "Total Duration",
                  LucideIcons.timer,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: context.appColors.grey200,
              ),
              Expanded(
                child: _buildActivityStat(
                  context,
                  stats.totalSessions.toString(),
                  "Total Sessions",
                  LucideIcons.check,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(
          'Error loading activity data',
          style: theme.textTheme.muted.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActivityStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = ShadTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.iconMd, color: context.appColors.grey600),
        8.verticalSpace,
        Text(
          value,
          style: theme.textTheme.h4.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        4.verticalSpace,
        Text(
          label,
          style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class WorkoutHistoryCard extends StatefulWidget {
  final String workoutName;
  final String duration;
  final String totalWeight;
  final String totalSets;
  final String date;

  const WorkoutHistoryCard({
    super.key,
    required this.workoutName,
    required this.duration,
    required this.totalWeight,
    required this.totalSets,
    required this.date,
  });

  @override
  State<WorkoutHistoryCard> createState() => _WorkoutHistoryCardState();
}

class _WorkoutHistoryCardState extends State<WorkoutHistoryCard> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Card.outlined(
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.workoutName,
                    style: theme.textTheme.h4.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  widget.date,
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  widget.duration,
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
                  widget.totalWeight,
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
                  widget.totalSets,
                  "Total Sets",
                  LucideIcons.check,
                ),
              ],
            ),
            if (_buildExerciseHistory().isNotEmpty) ...[
              16.verticalSpace,
              Divider(height: 1, color: context.appColors.grey200),
              12.verticalSpace,
              ..._buildExerciseHistory(),
            ],
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
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            label,
            style: theme.textTheme.muted.copyWith(fontSize: 11.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseHistory() {
    final theme = ShadTheme.of(context);
    final exercises = [
      _ExerciseItem(name: "Bench Press", sets: "4 sets × 80kg"),
      _ExerciseItem(name: "Squats", sets: "4 sets × 100kg"),
      _ExerciseItem(name: "Deadlift", sets: "3 sets × 120kg"),
      _ExerciseItem(name: "Overhead Press", sets: "4 sets × 60kg"),
    ];

    final visibleExercises = showAll || exercises.length <= 2
        ? exercises
        : exercises.sublist(0, 2);

    return [
      ...visibleExercises.map(
        (exercise) => _buildExerciseItem(exercise, theme),
      ),
      if (exercises.length > 2)
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showAll ? "Show Less" : "Show More",
                      style: theme.textTheme.muted.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      showAll ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ];
  }

  Widget _buildExerciseItem(_ExerciseItem exercise, ShadThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Icon(
              LucideIcons.dumbbell,
              size: 18,
              color: Colors.grey.shade600,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.h4.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                2.verticalSpace,
                Text(
                  exercise.sets,
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  final measurements;

  const _WeightChart({required this.measurements});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Sort measurements by date (oldest first) for chart
    final sortedMeasurements = List.from(measurements)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedMeasurements.length < 2) {
      return Container(
        height: 200.h,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            'Add at least 2 measurements to see weight chart',
            style: theme.textTheme.muted,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final spots = sortedMeasurements.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();

    final minWeight = sortedMeasurements
        .map((m) => m.weight)
        .reduce((a, b) => a < b ? a : b);
    final maxWeight = sortedMeasurements
        .map((m) => m.weight)
        .reduce((a, b) => a > b ? a : b);
    final weightRange = maxWeight - minWeight;
    final minY = (minWeight - weightRange * 0.1).clamp(0, double.infinity);
    final maxY = maxWeight + weightRange * 0.1;

    return Container(
      height: 250.h,
      // padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Progress',
            style: theme.textTheme.h4.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          16.verticalSpace,
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.blue.shade100,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final measurement =
                            sortedMeasurements[barSpot.x.toInt()];
                        return LineTooltipItem(
                          '${measurement.weight.toStringAsFixed(1)} kg\n${DateFormat('MMM d').format(measurement.date)}',
                          TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (sortedMeasurements.length - 1) / 4,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < sortedMeasurements.length) {
                          final measurement = sortedMeasurements[value.toInt()];
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              DateFormat('MMM d').format(measurement.date),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: (maxY - minY) / 5,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (sortedMeasurements.length - 1).toDouble(),
                minY: minY.toDouble(),
                maxY: maxY.toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue.shade600,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue.shade600,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem {
  final String name;
  final String sets;

  _ExerciseItem({required this.name, required this.sets});
}
