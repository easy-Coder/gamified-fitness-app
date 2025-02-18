import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _sharedPreferences;

  const OnboardingRepository(this._sharedPreferences);

  static const onboardingKey = 'onboardingComplete';

  Future<void> completeOnboarding() async {
    print('Save pref');
    await _sharedPreferences.setBool(onboardingKey, true);
  }

  bool isOnboardingComplete() =>
      _sharedPreferences.getBool(onboardingKey) ?? false;
}

final onboardingRepoProvider = FutureProvider((ref) async {
  final sharedPref = await ref.watch(sharedPrefProvider.future);
  return OnboardingRepository(sharedPref);
});
