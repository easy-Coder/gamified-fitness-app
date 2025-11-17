import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/application/preference_service.dart';
import 'package:gamified/src/features/account/data/health_repository.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit;
import 'package:health/health.dart';

// Preference Notifier
class PreferenceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // no-op
  }

  Future<void> updateUseHealth() async {
    if (state is! AsyncData) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(preferenceServiceProvider).updateUseHealth(),
    );
  }

  Future<void> updateWeightUnit(WeightUnit weightUnit) async {
    if (state is! AsyncData) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(preferenceServiceProvider).updateWeightUnit(weightUnit),
    );
  }
}

final preferenceNotifierProvider =
    AsyncNotifierProvider<PreferenceNotifier, void>(PreferenceNotifier.new);

// Health Permissions Provider
final healthPermissionsProvider = FutureProvider.autoDispose<bool>((ref) async {
  final healthRepo = ref.read(healthRepoProvider);
  return await healthRepo.hasPermissions(
    [
      HealthDataType.WEIGHT,
      HealthDataType.WORKOUT,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ],
    [HealthDataAccess.READ, HealthDataAccess.WRITE, HealthDataAccess.READ],
  );
});
