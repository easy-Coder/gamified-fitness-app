import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';

class UserRepository {
  final AppDatabase _db;

  const UserRepository(this._db);

  Future<UserData?> getUser() async {
    final result = await (_db.select(_db.user)..limit(1)).getSingleOrNull();
    return result;
  }

  Future<void> createUser(UserCompanion user) async {
    await (_db.into(_db.user).insert(user));
  }

  Future<void> updateUser(UserCompanion user) async {
    await (_db.update(_db.user).write(user));
  }
}

final userRepoProvider = Provider(
  (ref) => UserRepository(ref.read(dbProvider)),
);
