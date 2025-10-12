import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/account/schema/user.dart';
import 'package:isar_community/isar.dart';

class UserRepository {
  final Isar _db;

  const UserRepository(this._db);

  Future<UserDTO?> getUser() async {
    final result = await _db.users.where().limit(1).findFirst();
    return result == null ? null : UserDTO.fromSchema(result);
  }

  Future<void> createUser(UserDTO user) async {
    await _db.writeTxn(() async {
      await _db.users.put(user.toSchema());
    });
  }

  Future<void> updateUser(UserDTO user) async {
    await _db.writeTxn(() async {
      await _db.users.put(user.toSchema());
    });
  }
}

final userRepoProvider = Provider(
  (ref) => UserRepository(ref.read(dbProvider)),
);

final userProvider = FutureProvider(
  (ref) => ref.read(userRepoProvider).getUser(),
);
