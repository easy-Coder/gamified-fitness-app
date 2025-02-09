import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/stats/data/attribute_repository.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_log_service.g.dart';

class WorkoutLogService {
  final Ref _ref;

  WorkoutLogService(this._ref);

  Future<void> addWorkoutLog(WorkoutLog log) async {
    try {
      final user = _ref.read(authRepositoryProvider).currentUser()!;
      final attribute =
          await _ref.read(attributeRepoProvider).getUserAttributes(user.id);

      await _ref
          .read(attributeRepoProvider)
          .updateUserAttributes(attribute.copyWith(
            agility: attribute.agility + log.agility,
            endurance: attribute.endurance + log.endurance,
            strength: attribute.strength + log.strength,
            stamina: attribute.stamina + log.stamina,
          ));
      await _ref.read(workoutLogRepoProvider).addUserWorkoutLog(
            log.copyWith(userId: user.id),
          );
    } on Failure {
      rethrow;
    }
  }
}

@riverpod
WorkoutLogService workoutLogService(WorkoutLogServiceRef ref) {
  return WorkoutLogService(ref);
}
