import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/preference.dart';
import 'package:gamified/src/features/account/schema/preference.dart';
import 'package:isar_community/isar.dart';

class PreferenceRepository {
  final Isar _db;

  const PreferenceRepository(this._db);

  Stream<PreferenceDTO> getPreference() {
    final result = _db.preferences.watchObject(1, fireImmediately: true);
    return result.asyncMap((preference) async {
      if (preference == null) {
        // Create default preference if none exists
        await _createDefaultPreferenceIfNeeded();
        // Fetch the newly created preference
        final created = await _db.preferences.get(1);
        if (created == null) {
          // Fallback: return default preference
          return const PreferenceDTO(
            id: 1,
            weightUnit: WeightUnit.kg,
            useHealth: false,
          );
        }
        return PreferenceDTO.fromSchema(created);
      }
      return PreferenceDTO.fromSchema(preference);
    });
  }

  Future<void> _createDefaultPreferenceIfNeeded() async {
    final existing = await _db.preferences.get(1);
    if (existing == null) {
      await createPreference(
        const PreferenceDTO(id: 1, weightUnit: WeightUnit.kg, useHealth: false),
      );
    }
  }

  Future<PreferenceDTO?> getPreferenceSync() async {
    final result = await _db.preferences.get(1);
    return result == null ? null : PreferenceDTO.fromSchema(result);
  }

  /// Initialize default preference if it doesn't exist
  /// This should be called during app startup
  Future<void> initializeDefaultPreference() async {
    await _createDefaultPreferenceIfNeeded();
  }

  Future<void> createPreference(PreferenceDTO preference) async {
    await _db.writeTxn(() async {
      await _db.preferences.put(preference.toSchema());
    });
  }

  Future<void> updatePreference(PreferenceDTO preference) async {
    if (preference.id == null) {
      throw Exception('Cannot update preference without an ID');
    }
    await _db.writeTxn(() async {
      final existing = await _db.preferences.get(preference.id!);
      if (existing == null) {
        throw Exception('Preference not found with ID: ${preference.id}');
      }
      // Update the existing object's fields
      existing.weightUnit = preference.weightUnit;
      existing.useHealth = preference.useHealth;
      // Save the updated object
      await _db.preferences.put(existing);
    });
  }
}

final preferenceRepoProvider = Provider(
  (ref) => PreferenceRepository(ref.read(dbProvider)),
);

final preferenceProvider = StreamProvider<PreferenceDTO>(
  (ref) => ref.read(preferenceRepoProvider).getPreference(),
);
