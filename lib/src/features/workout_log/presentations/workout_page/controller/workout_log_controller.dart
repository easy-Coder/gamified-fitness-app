import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';
import 'package:gamified/src/features/workout_log/model/set_log.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:gamified/src/features/workout_plan/application/workout_plan_service.dart';

class WorkoutLogController extends FamilyNotifier<WorkoutLogs, int> {
  @override
  WorkoutLogs build(int planId) {
    final workoutPlan = ref.watch(workoutPlanProvider(planId)).valueOrNull;
    return WorkoutLogs(
      planId: planId,
      bodyweight: '0',
      caloriesBurned: 0,
      date: DateTime.now(),
      duration: 0,
      exerciseLogs: List.generate(workoutPlan!.workoutExercise.length, (index) {
        return ExerciseLogs(
          exerciseName: workoutPlan.workoutExercise[index].exercise.name,
        );
      }),
    );
  }

  void addSetLogs(int exerciseId, SetLogs setLogs) {
    List<ExerciseLogs> exerciseLogs = List.from(state.exerciseLogs);

    exerciseLogs[exerciseId] = exerciseLogs[exerciseId].copyWith(
      setLogs: [...exerciseLogs[exerciseId].setLogs, setLogs],
    );

    state = state.copyWith(exerciseLogs: exerciseLogs);
  }

  void updateSetLogs(int exerciseId, int setId, SetLogs setLog) {
    List<ExerciseLogs> exerciseLogs = List.from(state.exerciseLogs);
    List<SetLogs> setLogs = List.from(exerciseLogs[exerciseId].setLogs);

    setLogs[setId] = setLog;

    exerciseLogs[exerciseId] = exerciseLogs[exerciseId].copyWith(
      setLogs: setLogs,
    );

    state = state.copyWith(exerciseLogs: exerciseLogs);
  }

  void removeSetLogs(int exerciseId, int setId) {
    List<ExerciseLogs> exerciseLogs = List.from(state.exerciseLogs);

    exerciseLogs[exerciseId].setLogs.removeAt(setId);

    exerciseLogs[exerciseId] = exerciseLogs[exerciseId].copyWith(
      setLogs: exerciseLogs[exerciseId].setLogs,
    );
    state = state.copyWith(exerciseLogs: exerciseLogs);
  }
}

final workoutLogControllerProvider =
    NotifierProvider.family<WorkoutLogController, WorkoutLogs, int>(
      WorkoutLogController.new,
    );
