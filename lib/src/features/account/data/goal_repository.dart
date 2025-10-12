import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/goal.dart';
import 'package:gamified/src/features/account/schema/goal.dart';
import 'package:isar_community/isar.dart';

class GoalRepository {
  final Isar _db;

  const GoalRepository(this._db);

  Future<GoalDTO?> getGoal() async {
    final result = _db.goals.where().limit(1).findFirstSync();
    return result == null ? null : GoalDTO.fromSchema(result);
  }

  Future<double> getHydrationGoal() async {
    final goal = await getGoal();
    if (goal == null) return 0.0;
    return goal.hydrationGoal;
  }

  Future<void> createGoal(GoalDTO goal) async {
    await _db.writeTxn(() async {
      await _db.goals.put(goal.toSchema());
    });
  }

  Future<void> updateGoal(GoalDTO goal) async {
    await _db.writeTxn(() async {
      await _db.goals.put(goal.toSchema());
    });
  }
}

final goalRepoProvider = Provider(
  (ref) => GoalRepository(ref.read(dbProvider)),
);
