import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/account/model/measurement.dart';
import 'package:gamified/src/features/account/schema/measurement.dart';
import 'package:isar_community/isar.dart';

class MeasurementRepository {
  final Isar _db;

  const MeasurementRepository(this._db);

  Future<List<MeasurementDTO>> getAllMeasurements() async {
    final results = await _db.measurements.where().findAll();
    // Sort by date descending (most recent first)
    results.sort((a, b) => b.date.compareTo(a.date));
    return results.map((m) => MeasurementDTO.fromSchema(m)).toList();
  }

  Future<List<MeasurementDTO>> getMeasurementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allResults = await _db.measurements.where().findAll();
    // Filter and sort by date descending
    final filtered = allResults
        .where((m) => m.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            m.date.isBefore(endDate.add(Duration(days: 1))))
        .toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered.map((m) => MeasurementDTO.fromSchema(m)).toList();
  }

  Future<MeasurementDTO?> getLatestMeasurement() async {
    final allResults = await _db.measurements.where().findAll();
    if (allResults.isEmpty) return null;
    allResults.sort((a, b) => b.date.compareTo(a.date));
    return MeasurementDTO.fromSchema(allResults.first);
  }

  Future<void> createMeasurement(MeasurementDTO measurement) async {
    await _db.writeTxn(() async {
      await _db.measurements.put(measurement.toSchema());
    });
  }

  Future<void> deleteMeasurement(Id id) async {
    await _db.writeTxn(() async {
      await _db.measurements.delete(id);
    });
  }
}

final measurementRepoProvider = Provider(
  (ref) => MeasurementRepository(ref.read(dbProvider)),
);

final measurementsProvider = FutureProvider(
  (ref) => ref.read(measurementRepoProvider).getAllMeasurements(),
);

