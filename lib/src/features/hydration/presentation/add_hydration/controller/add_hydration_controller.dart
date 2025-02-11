import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/hydration/data/hydration_repo.dart';

class AddHydrationController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> trackIntake(WaterIntakesCompanion intake) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () async => ref.read(hydrationRepoProvider).createIntake(intake));
  }
}

final addHydrationControllerProvider =
    AsyncNotifierProvider<AddHydrationController, void>(
        AddHydrationController.new);
