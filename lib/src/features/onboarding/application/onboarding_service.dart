import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/data/goal_repository.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/onboarding/data/onboarding_repository.dart';

class OnboardingService {
  final Ref _ref;

  const OnboardingService(this._ref);

  Future<void> saveAndCompleteOnboarding(UserModel user, GoalModel goal) async {
    await _ref.read(userRepoProvider).createUser(user);
    await _ref.read(goalRepoProvider).createGoal(goal);
    final sharedRepo = _ref.read(onboardingRepoProvider);
    sharedRepo.completeOnboarding();
  }
}

final onboardingServiceProvider = Provider((ref) => OnboardingService(ref));
