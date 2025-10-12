import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/stats/presentations/controller/duration_controller.dart';
import 'package:gamified/src/features/stats/presentations/widgets/durations_chart.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OverviewSection extends ConsumerWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutLogsState = ref.watch(durationController);
    final selectedFilter = ref.watch(workoutLogFilter);
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Workout Durations',
              style: ShadTheme.of(
                context,
              ).textTheme.p.copyWith(fontWeight: FontWeight.bold),
            ),
            DropdownButton<WorkoutLogFilter>(
              value: selectedFilter,
              enableFeedback: true,
              onChanged: (filter) {
                if (filter != null) {
                  ref.read(workoutLogFilter.notifier).changeFilter(filter);
                }
              },
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowDown01,
                color: Colors.blue,
              ),
              items: WorkoutLogFilter.values.map((filter) {
                return DropdownMenuItem(
                  value: filter,
                  child: Text(filter.name.toTitleCase()),
                );
              }).toList(),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.blue, fontSize: 14),
              underline: Container(), // remove underline for a cleaner look
              borderRadius: BorderRadius.circular(18),
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.8,
          child: workoutLogsState.when(
            data: (workoutLogs) {
              return DurationsChart(
                filter: selectedFilter,
                workoutLogs: workoutLogs,
              );
            },
            error: (error, st) {
              ref.read(loggerProvider).d(error.toString(), stackTrace: st);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Icon(LucideIcons.x600, color: Colors.red),
                  Text(error.toString()),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),

        // Row(children: [

        // ],)
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem:
          (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            );
          },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'M';
        break;
      case 1:
        text = 'T';
        break;
      case 2:
        text = 'W';
        break;
      case 3:
        text = 'T';
        break;
      case 4:
        text = 'F';
        break;
      case 5:
        text = 'S';
        break;
      case 6:
        text = 'S';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => LinearGradient(
    colors: [Colors.black87, Colors.black54],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [BarChartRodData(toY: 8, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [BarChartRodData(toY: 10, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [BarChartRodData(toY: 14, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [BarChartRodData(toY: 15, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [BarChartRodData(toY: 13, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [BarChartRodData(toY: 10, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [BarChartRodData(toY: 16, gradient: _barsGradient)],
      showingTooltipIndicators: [0],
    ),
  ];
}
