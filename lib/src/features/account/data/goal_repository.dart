import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/goal.dart';

class GoalRepository {
  final AppDatabase _db;

  const GoalRepository(this._db);

  Future<GoalModel?> getGoal() async {
    final result = await (_db.select(_db.goal)..limit(1)).getSingleOrNull();
    return result == null ? null : GoalModel.fromJson(result.toJsonString());
  }

  Future<void> createGoal(GoalModel goal) async {
    await (_db.into(_db.goal).insert(goal.toCompanion()));
  }

  Future<void> updateGoal(GoalModel goal) async {
    await (_db.update(_db.goal).write(goal.toCompanion()));
  }
}

final goalRepoProvider = Provider(
  (ref) => GoalRepository(ref.read(dbProvider)),
);
