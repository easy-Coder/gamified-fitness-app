import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutLogService {
  final Ref _ref;

  WorkoutLogService(this._ref);
}

final workoutLogServiceProvider = Provider((ref) {
  return WorkoutLogService(ref);
});
