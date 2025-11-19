import 'package:equatable/equatable.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class ExerciseProgress extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final int setsCompleted;
  final int? repsCompleted;
  final double? weightUsed;
  final Duration? durationCompleted;
  final int? previousSets;
  final int? previousReps;
  final double? previousWeight;
  final Duration? previousDuration;

  const ExerciseProgress({
    required this.exerciseId,
    required this.exerciseName,
    required this.setsCompleted,
    this.repsCompleted,
    this.weightUsed,
    this.durationCompleted,
    this.previousSets,
    this.previousReps,
    this.previousWeight,
    this.previousDuration,
  });

  bool get hasProgress {
    if (previousSets == null && previousReps == null && 
        previousWeight == null && previousDuration == null) {
      return false;
    }
    return true;
  }

  String? get setsProgress {
    if (previousSets == null) return null;
    if (setsCompleted > previousSets!) return '+${setsCompleted - previousSets!}';
    if (setsCompleted < previousSets!) return '${setsCompleted - previousSets!}';
    return null;
  }

  String? get repsProgress {
    if (previousReps == null || repsCompleted == null) return null;
    if (repsCompleted! > previousReps!) return '+${repsCompleted! - previousReps!}';
    if (repsCompleted! < previousReps!) return '${repsCompleted! - previousReps!}';
    return null;
  }

  String? get weightProgress {
    if (previousWeight == null || weightUsed == null) return null;
    if (weightUsed! > previousWeight!) return '+${(weightUsed! - previousWeight!).toStringAsFixed(1)}kg';
    if (weightUsed! < previousWeight!) return '${(weightUsed! - previousWeight!).toStringAsFixed(1)}kg';
    return null;
  }

  @override
  List<Object?> get props => [
        exerciseId,
        exerciseName,
        setsCompleted,
        repsCompleted,
        weightUsed,
        durationCompleted,
        previousSets,
        previousReps,
        previousWeight,
        previousDuration,
      ];
}

class GroupedExerciseLog extends Equatable {
  final String exerciseId;
  final List<ExerciseLogsDTO> logs;
  final int totalSets;
  final int? totalReps;
  final double? averageWeight;
  final double? maxWeight;
  final Duration? totalDuration;

  const GroupedExerciseLog({
    required this.exerciseId,
    required this.logs,
    required this.totalSets,
    this.totalReps,
    this.averageWeight,
    this.maxWeight,
    this.totalDuration,
  });

  @override
  List<Object?> get props => [
        exerciseId,
        logs,
        totalSets,
        totalReps,
        averageWeight,
        maxWeight,
        totalDuration,
      ];
}

class WorkoutCompleteSummary extends Equatable {
  final WorkoutLogsDTO workoutLog;
  final String workoutName;
  final double? caloriesBurned;
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final List<ExerciseProgress> exerciseProgress;
  final List<GroupedExerciseLog> groupedExercises;
  final WorkoutLogsDTO? previousWorkout;

  const WorkoutCompleteSummary({
    required this.workoutLog,
    required this.workoutName,
    this.caloriesBurned,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.exerciseProgress,
    required this.groupedExercises,
    this.previousWorkout,
  });

  bool get hasPreviousWorkout => previousWorkout != null;

  String? get durationProgress {
    if (previousWorkout == null) return null;
    final current = workoutLog.duration;
    final previous = previousWorkout!.duration;
    if (current > previous) {
      final diff = current - previous;
      return '+${diff.inMinutes}min';
    }
    if (current < previous) {
      final diff = previous - current;
      return '-${diff.inMinutes}min';
    }
    return null;
  }

  String? get setsProgress {
    if (previousWorkout == null) return null;
    final previousSets = previousWorkout!.exerciseLogs.fold<int>(
      0,
      (sum, log) => sum + log.sets,
    );
    if (totalSets > previousSets) return '+${totalSets - previousSets}';
    if (totalSets < previousSets) return '${totalSets - previousSets}';
    return null;
  }

  String? get repsProgress {
    if (previousWorkout == null) return null;
    final previousReps = previousWorkout!.exerciseLogs.fold<int>(
      0,
      (sum, log) => sum + (log.reps ?? 0),
    );
    if (totalReps > previousReps) return '+${totalReps - previousReps}';
    if (totalReps < previousReps) return '${totalReps - previousReps}';
    return null;
  }

  String? get volumeProgress {
    if (previousWorkout == null) return null;
    final previousVolume = previousWorkout!.exerciseLogs.fold<double>(
      0.0,
      (sum, log) {
        if (log.weight != null && log.reps != null) {
          return sum + (log.weight! * log.reps!.toDouble() * log.sets);
        }
        return sum;
      },
    );
    if (totalVolume > previousVolume) {
      return '+${(totalVolume - previousVolume).toStringAsFixed(1)}kg';
    }
    if (totalVolume < previousVolume) {
      return '${(totalVolume - previousVolume).toStringAsFixed(1)}kg';
    }
    return null;
  }

  @override
  List<Object?> get props => [
        workoutLog,
        workoutName,
        caloriesBurned,
        totalSets,
        totalReps,
        totalVolume,
        exerciseProgress,
        groupedExercises,
        previousWorkout,
      ];
}

