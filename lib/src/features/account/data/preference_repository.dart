import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';

class PreferenceRepository {
  final AppDatabase _db;

  const PreferenceRepository(this._db);

  Future<PreferenceData?> getPreference() async {
    final result =
        await (_db.select(_db.preference)..limit(1)).getSingleOrNull();
    return result;
  }

  Future<void> createPreference(PreferenceCompanion preference) async {
    await (_db.into(_db.preference).insert(preference));
  }

  Future<void> updatePreference(PreferenceCompanion preference) async {
    await (_db.update(_db.preference).write(preference));
  }
}

final preferenceRepoProvider = Provider(
  (ref) => PreferenceRepository(ref.read(dbProvider)),
);
