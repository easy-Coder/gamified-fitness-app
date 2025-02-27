import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogController extends AsyncNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addWorkoutLog(WorkoutLog log) async {
    state = const AsyncLoading();
  }
}

final workoutLogControllerProvider = AsyncNotifierProvider(
  WorkoutLogController.new,
);
