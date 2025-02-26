import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/user.dart';

class UserRepository {
  final AppDatabase _db;

  const UserRepository(this._db);

  Future<UserModel?> getUser() async {
    final result = await (_db.select(_db.user)..limit(1)).getSingleOrNull();
    return result == null ? null : UserModel.fromJson(result.toJsonString());
  }

  Future<void> createUser(UserModel user) async {
    await (_db.into(_db.user).insert(user.toCompanion()));
  }

  Future<void> updateUser(UserModel user) async {
    await (_db.update(_db.user).write(user.toCompanion()));
  }
}

final userRepoProvider = Provider(
  (ref) => UserRepository(ref.read(dbProvider)),
);
