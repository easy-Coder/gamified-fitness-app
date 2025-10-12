import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/preference.dart';
import 'package:gamified/src/features/account/schema/preference.dart';
import 'package:isar_community/isar.dart';

class PreferenceRepository {
  final Isar _db;

  const PreferenceRepository(this._db);

  Future<PreferenceDTO?> getPreference() async {
    final result = await _db.preferences.where().limit(1).findFirst();
    return result == null ? null : PreferenceDTO.fromSchema(result);
  }

  Future<void> createPreference(PreferenceDTO preference) async {
    await _db.writeTxn(() async {
      await _db.preferences.put(preference.toSchema());
    });
  }

  Future<void> updatePreference(PreferenceDTO preference) async {
    await _db.writeTxn(() async {
      await _db.preferences.put(preference.toSchema());
    });
  }
}

final preferenceRepoProvider = Provider(
  (ref) => PreferenceRepository(ref.read(dbProvider)),
);
