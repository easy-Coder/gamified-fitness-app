import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/hydration/model/water_intake.dart';

class HydrationRepo {
  final AppDatabase db;

  const HydrationRepo(this.db);

  Future<int> createIntake(WaterIntakesCompanion intake) =>
      db.into(db.waterIntakes).insert(intake);

  Stream<List<WaterIntake>> getTodayIntakes() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = (db.select(
      db.waterIntakes,
    )..where((tbl) => tbl.time.isBetweenValues(startOfDay, endOfDay))).watch();

    return result.map(
      (intakes) => intakes
          .map((intake) => WaterIntake.fromJson(intake.toJson()))
          .toList(),
    );
  }

  Stream<double> watchTodayTotal() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = db.select(db.waterIntakes)
      ..where((tbl) => tbl.time.isBetweenValues(startOfDay, endOfDay));

    return query.watch().map((intakes) {
      return intakes.fold(0.0, (total, intake) {
        final ml = intake.amount;
        return total + (ml * intake.drinkType.hydrationFactor);
      });
    });
  }
}

final hydrationRepoProvider = Provider((ref) {
  return HydrationRepo(ref.read(dbProvider));
});

final todayIntakeStreamProvider = StreamProvider.autoDispose<double>((ref) {
  return ref.read(hydrationRepoProvider).watchTodayTotal();
});

final todayIntakeListStreamProvider =
    StreamProvider.autoDispose<List<WaterIntake>>((ref) {
      return ref.read(hydrationRepoProvider).getTodayIntakes();
    });
