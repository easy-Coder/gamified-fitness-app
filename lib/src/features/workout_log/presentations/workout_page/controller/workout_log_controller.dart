import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/application/workout_log_service.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogController extends AsyncNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addWorkoutLog(WorkoutLogsDTO log) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(workoutLogServiceProvider).addWorkoutLog(log),
    );
  }
}

final workoutLogControllerProvider = AsyncNotifierProvider(
  WorkoutLogController.new,
);
