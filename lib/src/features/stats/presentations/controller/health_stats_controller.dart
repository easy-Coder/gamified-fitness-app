import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/data/health_repository.dart';
import 'package:gamified/src/features/stats/model/home_stat.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:health/health.dart';

final yesterdayHealthStatsProvider = FutureProvider.autoDispose<List<HomeStat>>(
  (ref) async {
    final healthRepo = ref.read(healthRepoProvider);

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final start = startOfToday.subtract(const Duration(days: 1));
    final end = start.add(const Duration(days: 1));

    final calories = await _sumNumericValues(healthRepo, start, end, [
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ]);

    final steps = await _sumNumericValues(healthRepo, start, end, [
      HealthDataType.STEPS,
    ]);

    final activeMinutes = await _sumWorkoutMinutes(healthRepo, start, end);

    return [
      HomeStat(
        value: _formatCount(calories),
        label: '🔥 calories',
        icon: Icons.local_fire_department_outlined,
        color: Colors.deepOrange,
      ),
      HomeStat(
        value: _formatCount(steps),
        label: '👣 steps',
        icon: Icons.directions_walk_outlined,
        color: Colors.blueAccent,
      ),
      HomeStat(
        value: _formatActiveMinutes(activeMinutes),
        label: '⏱️ active times',
        icon: Icons.access_time_rounded,
        color: Colors.green,
      ),
    ];
  },
);

Future<double> _sumNumericValues(
  HealthRepository healthRepo,
  DateTime start,
  DateTime end,
  List<HealthDataType> types,
) async {
  final points = await healthRepo.fetchHealthData(start, end, types);

  return points.fold<double>(0, (total, point) {
    final value = point.value;
    if (value is NumericHealthValue) {
      return total + value.numericValue.toDouble();
    }
    return total;
  });
}

Future<double> _sumWorkoutMinutes(
  HealthRepository healthRepo,
  DateTime start,
  DateTime end,
) async {
  final points = await healthRepo.fetchHealthData(start, end, [
    HealthDataType.WORKOUT,
  ]);

  return points.fold<double>(0, (total, point) {
    final duration = point.dateTo.difference(point.dateFrom);
    if (duration.isNegative) {
      return total;
    }
    return total + duration.inMinutes.toDouble();
  });
}

String _formatCount(double total) {
  if (total <= 0) {
    return '0';
  }

  if (total >= 1000) {
    return '${(total / 1000).toStringAsFixed(1)}k';
  }

  return total.round().toString();
}

String _formatActiveMinutes(double minutes) {
  if (minutes <= 0) {
    return '0m';
  }
  final totalMinutes = minutes.round();
  final hours = totalMinutes ~/ 60;
  final remainingMinutes = totalMinutes % 60;

  if (hours <= 0) {
    return '${remainingMinutes}m';
  }

  return '${hours}h ${remainingMinutes}m';
}

final yesterdayWorkoutSessionStatsProvider =
    FutureProvider.autoDispose<List<HomeStat>>((ref) async {
      final workoutRepo = ref.read(workoutLogRepoProvider);
      final exerciseRepo = ref.read(exerciseLogRepoProvider);

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final targetDate = startOfToday.subtract(const Duration(days: 1));

      final logs = await workoutRepo.getWorkoutLogsByDate(targetDate);

      Duration totalDuration = Duration.zero;
      double totalVolume = 0;

      for (final log in logs) {
        totalDuration += log.duration;
        if (log.id == null) continue;

        final exerciseLogs = await exerciseRepo.getExerciseLogs(log.id!);
        totalVolume += exerciseLogs.fold<double>(0, (sum, exercise) {
          final reps = exercise.reps ?? 0;
          final weight = exercise.weight ?? 0;
          final sets = exercise.sets;
          return sum + (weight * reps * sets);
        });
      }

      final sessions = logs.length;

      return [
        HomeStat(
          value: _formatDuration(totalDuration),
          label: '⏳ duration',
          icon: Icons.timer_outlined,
          color: Colors.purple,
        ),
        HomeStat(
          value: _formatVolume(totalVolume),
          label: '🏋️ volume',
          icon: Icons.fitness_center_outlined,
          color: Colors.teal,
        ),
        HomeStat(
          value: _formatSessions(sessions),
          label: '📅 sessions',
          icon: Icons.calendar_today_outlined,
          color: Colors.indigo,
        ),
      ];
    });

String _formatDuration(Duration duration) {
  if (duration.inMinutes <= 0) return '0 m';

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours <= 0) {
    return '${minutes}m';
  }

  return '${hours}h ${minutes}m';
}

String _formatVolume(double volume) {
  if (volume <= 0) return '0 kg';
  if (volume >= 1000) {
    return '${(volume / 1000).toStringAsFixed(1)}k kg';
  }
  return '${volume.toStringAsFixed(0)} kg';
}

String _formatSessions(int sessions) {
  if (sessions <= 0) return '0';
  return sessions == 1 ? '1' : '$sessions';
}
