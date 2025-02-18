import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';

class GoalRepository {
  final AppDatabase _db;

  const GoalRepository(this._db);

  Future<GoalData?> getGoal() async {
    final result = await (_db.select(_db.goal)..limit(1)).getSingleOrNull();
    return result;
  }

  Future<void> createGoal(GoalCompanion goal) async {
    await (_db.into(_db.goal).insert(goal));
  }

  Future<void> updateGoal(GoalCompanion goal) async {
    await (_db.update(_db.goal).write(goal));
  }
}

final goalRepoProvider = Provider(
  (ref) => GoalRepository(ref.read(dbProvider)),
);
