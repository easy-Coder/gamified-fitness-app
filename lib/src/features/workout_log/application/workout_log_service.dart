import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutLogService {
  WorkoutLogService();
}

final workoutLogServiceProvider = Provider((ref) {
  return WorkoutLogService();
});
