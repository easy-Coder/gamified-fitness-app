import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

class WorkoutLogRepository {

  final AppDatabase _db;

  WorkoutLogRepository(this._db);

  

  
}

final workoutLogRepoProvider = Provider((ref) {
  return WorkoutLogRepository());
});
