import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/features/auth/data/repository/auth_repository.dart';
import 'package:gamified/src/features/stats/application/stat_overview_model/overview_model.dart';
import 'package:gamified/src/features/stats/data/attribute_repository.dart';
import 'package:gamified/src/features/workout_plan/data/workout_plan_repository.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_service.g.dart';

class StatsService {
  final Ref _ref;

  const StatsService(Ref ref) : _ref = ref;

  // stat overview
  Future<Either<Failure, OverviewModel>> getStatOverview() async {
    try {
      final user = _ref.read(authRepoSitoryProvider).currentUser();

      if (user != null) {
        final attribute =
            await _ref.read(attributeRepoProvider).getUserAttributes(user.id);

        final today = DateTime.now();

        final workoutPlan =
            await _ref.read(workoutPlanRepoProvider).getUserPlans(user.id);

        return Right(
          OverviewModel(
            user: user,
            userAttribute: attribute,
            workoutPlans: workoutPlan,
          ),
        );
      }
      return Left(Failure(message: 'You are not authenticated'));
    } on Failure catch (error) {
      return Left(error);
    }
  }
}

@riverpod
StatsService statService(StatServiceRef ref) {
  return StatsService(ref);
}
