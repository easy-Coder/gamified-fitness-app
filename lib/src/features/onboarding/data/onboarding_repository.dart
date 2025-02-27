import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferencesAsync _storage;

  const OnboardingRepository(this._storage);

  static const onboardingKey = 'onboardingComplete';

  Future<void> completeOnboarding() async {
    await _storage.setBool(onboardingKey, true);
  }

  Future<bool> isOnboardingComplete() async =>
      await _storage.getBool(onboardingKey) ?? false;
}

final onboardingRepoProvider = Provider((ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  return OnboardingRepository(sharedPref);
});
