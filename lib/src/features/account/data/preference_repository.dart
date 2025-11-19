import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/shared_preferences.dart';
import 'package:gamified/src/features/account/model/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  PreferenceRepository(this._storage);

  static const _preferenceKey = 'userPreference';

  final SharedPreferencesAsync _storage;
  final _preferenceStreamController =
      StreamController<PreferenceDTO>.broadcast();

  Stream<PreferenceDTO> watchPreference() async* {
    yield await _getOrCreatePreference();
    yield* _preferenceStreamController.stream;
  }

  Future<PreferenceDTO> getPreference() async {
    return await _getOrCreatePreference();
  }

  Future<void> initializeDefaultPreference() async {
    await _getOrCreatePreference();
  }

  Future<void> updatePreference(PreferenceDTO preference) async {
    await _savePreference(preference);
  }

  Future<PreferenceDTO> _getOrCreatePreference() async {
    final storedPreference = await _storage.getString(_preferenceKey);
    if (storedPreference == null) {
      await _savePreference(PreferenceDTO.defaultPreference);
      return PreferenceDTO.defaultPreference;
    }

    try {
      return PreferenceDTO.fromJson(storedPreference);
    } catch (_) {
      await _savePreference(PreferenceDTO.defaultPreference);
      return PreferenceDTO.defaultPreference;
    }
  }

  Future<void> _savePreference(PreferenceDTO preference) async {
    await _storage.setString(_preferenceKey, preference.toJson());
    _preferenceStreamController.add(preference);
  }

  void dispose() {
    _preferenceStreamController.close();
  }
}

final preferenceRepoProvider = Provider((ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  final repository = PreferenceRepository(sharedPref);
  ref.onDispose(repository.dispose);
  return repository;
});

final preferenceProvider = StreamProvider<PreferenceDTO>(
  (ref) => ref.read(preferenceRepoProvider).watchPreference(),
);
