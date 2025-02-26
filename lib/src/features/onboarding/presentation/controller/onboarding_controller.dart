import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/onboarding/application/onboarding_service.dart';

class OnboardingController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> completeOnboarding(UserModel user, GoalModel goal) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => await ref
          .read(onboardingServiceProvider)
          .saveAndCompleteOnboarding(user, goal),
    );
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, void>(OnboardingController.new);
