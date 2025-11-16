import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/workout_log/data/exercise_log_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';

class WorkoutHistoryService {
  final Ref _ref;

  WorkoutHistoryService(this._ref);

  Future<List<WorkoutHistoryItem>> getAllWorkoutHistory() async {
    try {
      final workoutLogs = await _ref
          .read(workoutLogRepoProvider)
          .getAllWorkoutLogs();

      final historyItems = <WorkoutHistoryItem>[];

      for (final log in workoutLogs) {
        // Get exercise logs for this workout
        List<ExerciseLogsDTO> exerciseLogs = [];
        if (log.id != null) {
          exerciseLogs = await _ref
              .read(exerciseLogRepoProvider)
              .getExerciseLogs(log.id!);
        }

        // Get workout plan name
        String workoutName = 'Unknown Workout';
        try {
          final plan = await _ref
              .read(workoutPlanRepoProvider)
              .getWorkoutPlanById(log.planId);
          workoutName = plan.name;
        } catch (e) {
          _ref.read(loggerProvider).w('Failed to get workout plan: $e');
        }

        // Calculate stats
        final totalWeight = exerciseLogs.fold<double>(
          0.0,
          (sum, exercise) {
            if (exercise.weight != null && exercise.reps != null) {
              return sum + (exercise.weight! * exercise.reps!.toDouble());
            }
            return sum;
          },
        );

        final totalReps = exerciseLogs.fold<int>(
          0,
          (sum, exercise) => sum + (exercise.reps ?? 0),
        );

        final totalSets = exerciseLogs.fold<int>(
          0,
          (sum, exercise) => sum + exercise.sets,
        );

        historyItems.add(WorkoutHistoryItem(
          workoutLog: log.copyWith(exerciseLogs: exerciseLogs),
          workoutName: workoutName,
          totalWeight: totalWeight,
          totalReps: totalReps,
          totalSets: totalSets,
        ));
      }

      // Sort by date descending (most recent first)
      historyItems.sort((a, b) {
        final dateA = a.workoutLog.workoutDate ?? DateTime(1970);
        final dateB = b.workoutLog.workoutDate ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      return historyItems;
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to get workout history: $e');
      throw Failure(message: 'Failed to get workout history: $e');
    }
  }
}

class WorkoutHistoryItem {
  final WorkoutLogsDTO workoutLog;
  final String workoutName;
  final double totalWeight;
  final int totalReps;
  final int totalSets;

  WorkoutHistoryItem({
    required this.workoutLog,
    required this.workoutName,
    required this.totalWeight,
    required this.totalReps,
    required this.totalSets,
  });
}

final workoutHistoryServiceProvider = Provider((ref) {
  return WorkoutHistoryService(ref);
});

final workoutHistoryProvider = FutureProvider<List<WorkoutHistoryItem>>((ref) {
  return ref.read(workoutHistoryServiceProvider).getAllWorkoutHistory();
});

