import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/data/goal_repository.dart';
import 'package:gamified/src/features/hydration/data/hydration_repo.dart';
import 'package:gamified/src/features/hydration/model/hydration_progress.dart';

class HydrationService {
  final Ref _ref;

  const HydrationService(this._ref);

  Stream<HydrationProgress> todayHydrationProgress() {
    final result = _ref.read(hydrationRepoProvider).watchTodayTotal().asyncMap((
      totalIntake,
    ) async {
      final goal = await _ref.read(goalRepoProvider).getHydrationGoal();
      return HydrationProgress(
        todayHydrationTotal: totalIntake,
        hydrationGoal: goal,
      );
    });

    return result;
  }
}

final hydrationServiceProvider = Provider((ref) => HydrationService(ref));

final hydrationGoalProvider = StreamProvider(
  (ref) => ref.read(hydrationServiceProvider).todayHydrationProgress(),
);
