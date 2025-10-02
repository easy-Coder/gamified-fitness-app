import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class DurationsChart extends StatelessWidget {
  final WorkoutLogFilter filter;
  final List<WorkoutLog> workoutLogs;

  const DurationsChart({
    super.key,
    required this.filter,
    required this.workoutLogs,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(_buildChartData());
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    String text = '';

    switch (filter) {
      case WorkoutLogFilter.week:
        text = _getWeekLabel(value.toInt());
        break;
      case WorkoutLogFilter.month:
        text = _getMonthLabel(value.toInt());
        break;
      case WorkoutLogFilter.year:
        text = _getYearLabel(value.toInt());
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  String _getWeekLabel(int value) {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return value < weekDays.length ? weekDays[value] : '';
  }

  String _getMonthLabel(int value) {
    // For month view, show weeks (Week 1, Week 2, etc.)
    if (value >= 0 && value < 4) {
      return ' ${value + 1}';
    }
    return '';
  }

  String _getYearLabel(int value) {
    // For year view, show months
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return value < months.length ? months[value] : '';
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, color: Colors.black54);

    // Get the dynamic Y-axis range
    final (_, maxY) = _getYAxisRange();

    // Only show labels at specific intervals
    final interval = maxY / 5; // Show 5 labels
    final expectedValues = [
      0,
      interval,
      interval * 2,
      interval * 3,
      interval * 4,
      maxY,
    ];

    // Check if current value matches any expected label position (with tolerance)
    bool shouldShowLabel = expectedValues.any(
      (expected) => (value - expected).abs() < 0.1,
    );

    if (!shouldShowLabel) {
      return Container();
    }

    String text = '${value.toInt()}m';
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData _buildChartData() {
    final spots = _generateDataSpots();
    final (minX, maxX) = _getXAxisRange();
    final (minY, maxY) = _getYAxisRange();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border(
          left: BorderSide(color: Colors.blue.shade600, width: 2),
          bottom: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
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
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400.withValues(alpha: 0.1),
                Colors.blue.shade600.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateDataSpots() {
    switch (filter) {
      case WorkoutLogFilter.week:
        return _generateWeeklySpots();
      case WorkoutLogFilter.month:
        return _generateMonthlySpots();
      case WorkoutLogFilter.year:
        return _generateYearlySpots();
    }
  }

  List<FlSpot> _generateWeeklySpots() {
    // Group workouts by day of week (0 = Monday, 6 = Sunday)
    final Map<int, List<WorkoutLog>> groupedByDay = {};

    for (final log in workoutLogs) {
      final dayOfWeek = (log.workoutDate!.weekday - 1) % 7; // Convert to 0-6
      groupedByDay.putIfAbsent(dayOfWeek, () => []).add(log);
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      final dayWorkouts = groupedByDay[i] ?? [];
      final avgDuration = dayWorkouts.isEmpty
          ? 0.0
          : dayWorkouts
                    .map((w) => w.duration)
                    .reduce((a, b) => a + b)
                    .inMinutes /
                dayWorkouts.length;

      spots.add(FlSpot(i.toDouble(), avgDuration));
    }

    return spots;
  }

  List<FlSpot> _generateMonthlySpots() {
    // Group workouts by week of the month
    final Map<int, List<WorkoutLog>> groupedByWeek = {};
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);

    for (final log in workoutLogs) {
      final weekOfMonth =
          ((log.workoutDate!.difference(firstOfMonth).inDays) / 7).floor();
      if (weekOfMonth >= 0 && weekOfMonth < 4) {
        groupedByWeek.putIfAbsent(weekOfMonth, () => []).add(log);
      }
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < 4; i++) {
      final weekWorkouts = groupedByWeek[i] ?? [];
      final avgDuration = weekWorkouts.isEmpty
          ? 0.0
          : weekWorkouts
                    .map((w) => w.duration)
                    .reduce((a, b) => a + b)
                    .inMinutes /
                weekWorkouts.length;

      spots.add(FlSpot(i.toDouble(), avgDuration));
    }

    return spots;
  }

  List<FlSpot> _generateYearlySpots() {
    // Group workouts by month
    final Map<int, List<WorkoutLog>> groupedByMonth = {};

    for (final log in workoutLogs) {
      final month = log.workoutDate!.month - 1; // Convert to 0-11
      groupedByMonth.putIfAbsent(month, () => []).add(log);
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < 12; i++) {
      final monthWorkouts = groupedByMonth[i] ?? [];
      final avgDuration = monthWorkouts.isEmpty
          ? 0.0
          : monthWorkouts
                    .map((w) => w.duration)
                    .reduce((a, b) => a + b)
                    .inMinutes /
                monthWorkouts.length;

      spots.add(FlSpot(i.toDouble(), avgDuration));
    }

    return spots;
  }

  (double, double) _getXAxisRange() {
    switch (filter) {
      case WorkoutLogFilter.week:
        return (0, 6); // 7 days (0-6)
      case WorkoutLogFilter.month:
        return (0, 3); // 4 weeks (0-3)
      case WorkoutLogFilter.year:
        return (0, 11); // 12 months (0-11)
    }
  }

  (double, double) _getYAxisRange() {
    if (workoutLogs.isEmpty) {
      return (0, 10); // Default range when no data
    }

    // Calculate all spot values to find the maximum
    final spots = _generateDataSpots();
    final maxValue = spots.isEmpty
        ? 0.0
        : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Round up to the nearest 10, 20, 50, 100, etc.
    double maxY;
    if (maxValue <= 10) {
      maxY = 10;
    } else if (maxValue <= 20) {
      maxY = 20;
    } else if (maxValue <= 30) {
      maxY = 30;
    } else if (maxValue <= 40) {
      maxY = 40;
    } else if (maxValue <= 50) {
      maxY = 50;
    } else if (maxValue <= 60) {
      maxY = 60;
    } else if (maxValue <= 90) {
      maxY = 90;
    } else if (maxValue <= 120) {
      maxY = 120;
    } else if (maxValue <= 150) {
      maxY = 150;
    } else if (maxValue <= 180) {
      maxY = 180;
    } else {
      // For values above 180, round up to nearest 50
      maxY = ((maxValue / 50).ceil() * 50).toDouble();
    }

    return (0, maxY);
  }
}
