import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_log_service.g.dart';

class WorkoutLogService {
  final Ref _ref;

  WorkoutLogService(this._ref);
}

@riverpod
WorkoutLogService workoutLogService(WorkoutLogServiceRef ref) {
  return WorkoutLogService(ref);
}
