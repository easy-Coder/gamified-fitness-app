import 'package:drift/drift.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class WorkoutExerciseRepository {
  final AppDatabase _db;

  const WorkoutExerciseRepository(this._db);

  Future<List<WorkoutExercise>> getPlanWorkoutExercises(int planId) async {
    try {
      final query = _db.select(_db.workoutExcercise).join([
        innerJoin(
          _db.exercise,
          _db.exercise.id.equalsExp(_db.workoutExcercise.excerciseId),
        ),
      ])..where(_db.workoutExcercise.planId.equals(planId));

      final rows = await query.get();

      return rows.map((row) {
        final workoutExercise = row.readTable(_db.workoutExcercise);
        final exercise = row.readTable(_db.exercise);
        return WorkoutExercise(
          // Construct your WorkoutExercise object
          id: workoutExercise.id,
          planId: workoutExercise.planId,
          // ... other WorkoutExercise properties
          exercise: ExerciseMapper.fromJson(
            exercise.toJsonString(),
          ), // Assign the Exercise object
        );
      }).toList();
    } catch (error) {
      print(error);
      throw Failure(message: 'Unexpected error occurred. Try again later');
    }
  }

  Future<void> deleteWorkoutExercise(int id) async {
    try {
      await (_db.delete(_db.workoutExcercise)
        ..where((t) => t.id.equals(id))).go();
    } catch (error) {
      throw Failure(message: 'Unexpected error occurred. Try again later');
    }
  }

  Future<void> addWorkoutExcerciseToPlan(
    List<WorkoutExercise> workoutExercises,
  ) async {
    try {
      await _db.batch((batch) {
        batch.insertAll(
          _db.workoutExcercise,
          workoutExercises
              .map((workoutExercise) => workoutExercise.toCompanion())
              .toList(),
        );
      });
    } catch (error) {}
  }
}

final workoutExerciseRepoProvider = Provider(
  (ref) => WorkoutExerciseRepository(ref.read(dbProvider)),
);
