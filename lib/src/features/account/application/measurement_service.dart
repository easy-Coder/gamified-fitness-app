import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/account/data/measurement_repository.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/account/model/measurement.dart';
import 'package:gamified/src/features/account/model/user.dart';

class MeasurementService {
  final Ref _ref;

  MeasurementService(this._ref);

  Future<void> saveMeasurement(UserDTO user, MeasurementDTO measurement) async {
    try {
      // Create new measurement entry
      await _ref.read(measurementRepoProvider).createMeasurement(measurement);

      // Update user profile
      await _ref.read(userRepoProvider).updateUser(user);
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to save measurement: $e');
      throw Failure(message: 'Failed to save measurement: $e');
    }
  }

  Future<UserDTO?> getUser() async {
    try {
      return await _ref.read(userRepoProvider).getUser();
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    }
  }

  Future<void> updateUser(UserDTO user) async {
    try {
      await _ref.read(userRepoProvider).updateUser(user);
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    }
  }
}

final measurementServiceProvider = Provider((ref) {
  return MeasurementService(ref);
});

