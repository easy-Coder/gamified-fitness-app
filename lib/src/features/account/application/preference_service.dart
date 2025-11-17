import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/account/data/health_repository.dart';
import 'package:gamified/src/features/account/data/preference_repository.dart';
import 'package:gamified/src/features/account/model/preference.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit;
import 'package:health/health.dart';

class PreferenceService {
  final Ref _ref;

  PreferenceService(this._ref);

  /// Get user preference or create default if none exists
  Future<PreferenceDTO> _getPreference() async {
    try {
      final preference = _ref.read(preferenceRepoProvider).getPreference();
      return await preference.first;
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to get preference: $e');
      throw Failure(message: 'Failed to get preference: $e');
    }
  }

  /// Update weight unit preference
  Future<void> updateWeightUnit(WeightUnit weightUnit) async {
    try {
      final currentPreference = await _getPreference();
      if (currentPreference.id == null) {
        throw Failure(message: 'Preference has no ID');
      }

      final updatedPreference = currentPreference.copyWith(
        weightUnit: weightUnit,
      );

      await _ref
          .read(preferenceRepoProvider)
          .updatePreference(updatedPreference);
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to update weight unit: $e');
      throw Failure(message: 'Failed to update weight unit: $e');
    }
  }

  /// Update health integration preference
  /// This will request permissions if enabling, and sync preference with actual permission status
  Future<void> updateUseHealth() async {
    try {
      final currentPreference = await _getPreference();
      if (currentPreference.id == null) {
        throw Failure(message: 'Preference has no ID');
      }

      final healthRepo = _ref.read(healthRepoProvider);

      // Request authorization when enabling
      final isAuthorized = await healthRepo.requestAuthorization();
      if (!isAuthorized) {
        throw Failure(message: 'Health permission was not granted');
      }
      // Update preference to enabled
      await _ref
          .read(preferenceRepoProvider)
          .updatePreference(currentPreference.copyWith(useHealth: true));
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to update health integration: $e');
      throw Failure(message: 'Failed to update health integration: $e');
    }
  }
}

final preferenceServiceProvider = Provider((ref) {
  return PreferenceService(ref);
});
