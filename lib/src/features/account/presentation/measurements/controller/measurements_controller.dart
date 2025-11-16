import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/application/measurement_service.dart';
import 'package:gamified/src/features/account/data/measurement_repository.dart';
import 'package:gamified/src/features/account/model/measurement.dart';
import 'package:gamified/src/features/account/model/user.dart';

class MeasurementsController extends AsyncNotifier<UserDTO> {
  @override
  FutureOr<UserDTO> build() async {
    final user = await ref.read(measurementServiceProvider).getUser();
    return user ?? UserDTO.empty();
  }

  Future<void> loadUser() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final user = await ref.read(measurementServiceProvider).getUser();
        return user ?? UserDTO.empty();
      },
    );
  }

  Future<void> updateWeight(double weight) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(weight: weight);
    state = AsyncData(updatedUser);
  }

  Future<void> updateHeight(double height) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(height: height);
    state = AsyncData(updatedUser);
  }

  Future<void> saveMeasurement() async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.weight == 0 || currentUser.height == 0) {
      throw Exception('Please enter weight and height first');
    }

    final measurement = MeasurementDTO(
      date: DateTime.now(),
      weight: currentUser.weight,
      height: currentUser.height,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(measurementServiceProvider).saveMeasurement(
              currentUser,
              measurement,
            );
        ref.invalidate(measurementsProvider);
        return currentUser;
      },
    );
  }
}

final measurementsControllerProvider =
    AsyncNotifierProvider<MeasurementsController, UserDTO>(
  MeasurementsController.new,
);

