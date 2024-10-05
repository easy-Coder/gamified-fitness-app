import 'package:gamified/src/features/workout_log/application/workout_log_service.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_log_controller.g.dart';

@riverpod
class WorkoutLogController extends _$WorkoutLogController {
  @override
  FutureOr<void> build() {}

  Future<void> addWorkoutLog(WorkoutLog log) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(()  =>
         ref.read(workoutLogServiceProvider).addWorkoutLog(log));
  }
}
