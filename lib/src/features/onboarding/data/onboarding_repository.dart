import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferencesAsync _sharedPreferences;

  const OnboardingRepository(this._sharedPreferences);

  static const onboardingKey = 'onboardingComplete';

  Future<void> completeOnboarding() async {
    print('Save pref');
    await _sharedPreferences.setBool(onboardingKey, true);
  }

  Future<bool> isOnboardingComplete() async =>
      await _sharedPreferences.getBool(onboardingKey) ?? false;
}

final onboardingRepoProvider = Provider((ref) {
  final sharedPref = ref.read(sharedPrefProvider);
  return OnboardingRepository(sharedPref);
});
