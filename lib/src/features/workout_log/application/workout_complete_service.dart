import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/account/data/health_repository.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/excersice/model/exercise.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_complete_summary.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:health/health.dart';

class WorkoutCompleteService {
  final Ref _ref;

  WorkoutCompleteService(this._ref);

  /// Get workout complete summary with progress metrics and calories
  Future<WorkoutCompleteSummary> getWorkoutCompleteSummary(
    WorkoutLogsDTO workoutLog,
  ) async {
    try {
      // Get workout plan name
      String workoutName = 'Unknown Workout';
      try {
        final plan = await _ref
            .read(workoutPlanRepoProvider)
            .getWorkoutPlanById(workoutLog.planId);
        workoutName = plan.name;
      } catch (e) {
        _ref.read(loggerProvider).w('Failed to get workout plan: $e');
      }

      // Calculate totals
      // For each exerciseId, find the highest sets, then sum those
      final Map<String, int> maxSetsPerExercise = {};
      for (final log in workoutLog.exerciseLogs) {
        if (!maxSetsPerExercise.containsKey(log.exerciseId) ||
            log.sets > maxSetsPerExercise[log.exerciseId]!) {
          maxSetsPerExercise[log.exerciseId] = log.sets;
        }
      }
      final totalSets = maxSetsPerExercise.values.fold<int>(
        0,
        (sum, sets) => sum + sets,
      );

      final totalReps = workoutLog.exerciseLogs.fold<int>(
        0,
        (sum, log) => sum + (log.reps ?? 0),
      );

      final totalVolume = workoutLog.exerciseLogs.fold<double>(0.0, (sum, log) {
        if (log.weight != null && log.reps != null) {
          return sum + (log.weight! * log.reps!.toDouble() * log.sets);
        }
        return sum;
      });

      // Get calories burned from health
      double? caloriesBurned;
      try {
        if (workoutLog.workoutDate != null) {
          // Estimate workout time range
          // Use workoutDate as start, add duration for end
          final startTime = workoutLog.workoutDate!;
          final endTime = startTime.add(workoutLog.duration);

          // Get active calories for the workout time range
          final healthRepo = _ref.read(healthRepoProvider);
          final caloriesData = await healthRepo.fetchCaloriesData(
            startTime,
            endTime,
            activeEnergyOnly: true,
          );

          if (caloriesData.isNotEmpty) {
            caloriesBurned = caloriesData.fold<double>(0.0, (sum, dataPoint) {
              if (dataPoint.value is NumericHealthValue) {
                return sum +
                    (dataPoint.value as NumericHealthValue).numericValue;
              }
              return sum;
            });
          }
        }
      } catch (e) {
        _ref.read(loggerProvider).w('Failed to get calories: $e');
      }

      // Get previous workout for comparison
      WorkoutLogsDTO? previousWorkout;
      try {
        final allLogs = await _ref
            .read(workoutLogRepoProvider)
            .getAllWorkoutLogs();

        // Find previous workout with same planId, sorted by date
        final samePlanLogs = allLogs
            .where(
              (log) =>
                  log.planId == workoutLog.planId &&
                  log.id != workoutLog.id &&
                  (log.workoutDate?.isBefore(
                        workoutLog.workoutDate ?? DateTime.now(),
                      ) ??
                      false),
            )
            .toList();

        if (samePlanLogs.isNotEmpty) {
          samePlanLogs.sort((a, b) {
            final dateA = a.workoutDate ?? DateTime(1970);
            final dateB = b.workoutDate ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });

          previousWorkout = samePlanLogs.first;
          // Load exercise logs for previous workout
          if (previousWorkout.id != null) {
            final previousExerciseLogs = await _ref
                .read(exerciseLogRepoProvider)
                .getExerciseLogs(previousWorkout.id!);
            previousWorkout = previousWorkout.copyWith(
              exerciseLogs: previousExerciseLogs,
            );
          }
        }
      } catch (e) {
        _ref.read(loggerProvider).w('Failed to get previous workout: $e');
      }

      // Group exercise logs by exerciseId
      final groupedLogs = <String, List<ExerciseLogsDTO>>{};
      for (final exerciseLog in workoutLog.exerciseLogs) {
        groupedLogs
            .putIfAbsent(exerciseLog.exerciseId, () => [])
            .add(exerciseLog);
      }

      // Build grouped exercises and exercise progress
      final groupedExercises = <GroupedExerciseLog>[];
      final exerciseProgress = <ExerciseProgress>[];

      for (final entry in groupedLogs.entries) {
        final exerciseId = entry.key;
        final logs = entry.value;

        // Aggregate data for grouped exercise
        final groupedSets = logs.fold<int>(0, (sum, log) => sum + log.sets);

        int? groupedReps;
        final allReps = logs
            .where((log) => log.reps != null)
            .map((log) => log.reps!)
            .toList();
        if (allReps.isNotEmpty) {
          groupedReps = allReps.fold<int>(0, (sum, reps) => sum + reps);
        }

        double? avgWeight;
        double? maxWeight;
        final allWeights = logs
            .where((log) => log.weight != null)
            .map((log) => log.weight!)
            .toList();
        if (allWeights.isNotEmpty) {
          avgWeight = allWeights.reduce((a, b) => a + b) / allWeights.length;
          maxWeight = allWeights.reduce((a, b) => a > b ? a : b);
        }

        Duration? groupedDuration;
        final allDurations = logs
            .where((log) => log.duration != null)
            .map((log) => log.duration!)
            .toList();
        if (allDurations.isNotEmpty) {
          groupedDuration = allDurations.reduce((a, b) => a + b);
        }

        groupedExercises.add(
          GroupedExerciseLog(
            exerciseId: exerciseId,
            logs: logs,
            totalSets: groupedSets,
            totalReps: groupedReps,
            averageWeight: avgWeight,
            maxWeight: maxWeight,
            totalDuration: groupedDuration,
          ),
        );

        // Get exercise name
        String exerciseName = 'Unknown Exercise';
        try {
          final exercise = await _ref
              .read(exerciseRepositoryProvider)
              .getExercise(exerciseId);
          exerciseName = ExerciseDTO.fromSchema(exercise).name;
        } catch (e) {
          _ref.read(loggerProvider).w('Failed to get exercise: $e');
        }

        // Find previous grouped exercise logs for comparison
        int? previousSets;
        int? previousReps;
        double? previousWeight;
        Duration? previousDuration;

        if (previousWorkout != null) {
          final previousLogs = previousWorkout.exerciseLogs
              .where((log) => log.exerciseId == exerciseId)
              .toList();

          if (previousLogs.isNotEmpty) {
            previousSets = previousLogs.fold<int>(
              0,
              (sum, log) => sum + log.sets,
            );

            final prevReps = previousLogs
                .where((log) => log.reps != null)
                .map((log) => log.reps!)
                .toList();
            if (prevReps.isNotEmpty) {
              previousReps = prevReps.fold<int>(0, (sum, reps) => sum + reps);
            }

            final prevWeights = previousLogs
                .where((log) => log.weight != null)
                .map((log) => log.weight!)
                .toList();
            if (prevWeights.isNotEmpty) {
              previousWeight =
                  prevWeights.reduce((a, b) => a + b) / prevWeights.length;
            }

            final prevDurations = previousLogs
                .where((log) => log.duration != null)
                .map((log) => log.duration!)
                .toList();
            if (prevDurations.isNotEmpty) {
              previousDuration = prevDurations.reduce((a, b) => a + b);
            }
          }
        }

        exerciseProgress.add(
          ExerciseProgress(
            exerciseId: exerciseId,
            exerciseName: exerciseName,
            setsCompleted: groupedSets,
            repsCompleted: groupedReps,
            weightUsed: maxWeight ?? avgWeight,
            durationCompleted: groupedDuration,
            previousSets: previousSets,
            previousReps: previousReps,
            previousWeight: previousWeight,
            previousDuration: previousDuration,
          ),
        );
      }

      return WorkoutCompleteSummary(
        workoutLog: workoutLog,
        workoutName: workoutName,
        caloriesBurned: caloriesBurned,
        totalSets: totalSets,
        totalReps: totalReps,
        totalVolume: totalVolume,
        exerciseProgress: exerciseProgress,
        groupedExercises: groupedExercises,
        previousWorkout: previousWorkout,
      );
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to get workout complete summary: $e');
      rethrow;
    }
  }
}

final workoutCompleteServiceProvider = Provider((ref) {
  return WorkoutCompleteService(ref);
});
