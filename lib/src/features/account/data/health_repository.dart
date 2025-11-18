import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';

/// Repository for accessing health data from Apple HealthKit (iOS) and Google Fit (Android)
class HealthRepository {
  final Health _health;

  HealthRepository(this._health) {
    init();
  }

  void init() async {
    await _health.configure();
  }

  /// Check if health integration is available on the current platform
  Future<bool> get isAvailable async {
    await _health.configure();
    final isHealthConnectAvailable = await _health.isHealthConnectAvailable();
    return (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android) &&
        isHealthConnectAvailable;
  }

  /// Request authorization to access health data
  /// Returns true if authorization is granted, false otherwise
  Future<bool> requestAuthorization() async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      final dataTypes = [
        HealthDataType.WEIGHT,
        HealthDataType.WORKOUT,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.STEPS,
      ];

      final permissions = [
        HealthDataAccess.READ,
        HealthDataAccess.WRITE,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
      ];

      return await _health.requestAuthorization(
        dataTypes,
        permissions: permissions,
      );
    } catch (e) {
      Logger().e('Failed to request authorization: $e');
      return false;
    }
  }

  /// Check if authorization has been granted for the specified types
  Future<bool> hasPermissions(
    List<HealthDataType> types, [
    List<HealthDataAccess> permissions = const [],
  ]) async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      final hasPermissions = await _health.hasPermissions(
        types,
        permissions: permissions,
      );
      return hasPermissions ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Fetch health data of specified types within a date range
  /// Returns a list of health data points
  Future<List<HealthDataPoint>> fetchHealthData(
    DateTime startDate,
    DateTime endDate,
    List<HealthDataType> types,
  ) async {
    if (!(await isAvailable)) {
      return [];
    }

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startDate,
        endTime: endDate,
      );
      // Remove duplicates
      healthData = _health.removeDuplicates(healthData);
      // Sort by date (newest first)
      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      return healthData;
    } catch (e) {
      return [];
    }
  }

  /// Fetch weight data within a date range
  Future<List<HealthDataPoint>> fetchWeightData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return fetchHealthData(startDate, endDate, [HealthDataType.WEIGHT]);
  }

  /// Fetch height data
  Future<List<HealthDataPoint>> fetchHeightData() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 365));
    return fetchHealthData(startDate, now, [HealthDataType.HEIGHT]);
  }

  /// Get the latest weight from health data
  Future<double?> getLatestWeight() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 365));
    final weightData = await fetchWeightData(startDate, now);

    if (weightData.isEmpty) return null;

    // Get the most recent weight
    final latest = weightData.first;
    final value = (latest.value as NumericHealthValue).numericValue;
    return value.toDouble();
  }

  /// Get the latest height from health data
  Future<double?> getLatestHeight() async {
    final heightData = await fetchHeightData();
    if (heightData.isEmpty) return null;

    // Get the most recent height
    final latest = heightData.first;
    final value = (latest.value as NumericHealthValue).numericValue;
    return value.toDouble();
  }

  /// Write weight data to health platform
  Future<bool> writeWeight(double weight, DateTime date) async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      return await _health.writeHealthData(
        value: weight,
        type: HealthDataType.WEIGHT,
        startTime: date,
      );
    } catch (e) {
      return false;
    }
  }

  /// Write height data to health platform
  Future<bool> writeHeight(double height, DateTime date) async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      return await _health.writeHealthData(
        value: height,
        type: HealthDataType.HEIGHT,
        startTime: date,
      );
    } catch (e) {
      return false;
    }
  }

  /// Write health data of a specific type
  Future<bool> writeHealthData(
    double value,
    HealthDataType type,
    DateTime date,
  ) async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      return await _health.writeHealthData(
        value: value,
        type: type,
        startTime: date,
      );
    } catch (e) {
      return false;
    }
  }

  /// Fetch calories data within a date range
  /// Returns a list of calorie data points
  Future<List<HealthDataPoint>> fetchCaloriesData(
    DateTime startDate,
    DateTime endDate, {
    bool activeEnergyOnly = false,
  }) async {
    final types = activeEnergyOnly
        ? [HealthDataType.ACTIVE_ENERGY_BURNED]
        : [
            HealthDataType.ACTIVE_ENERGY_BURNED,
            HealthDataType.BASAL_ENERGY_BURNED,
          ];
    return fetchHealthData(startDate, endDate, types);
  }

  /// Get total calories burned for a specific date
  Future<double?> getTotalCaloriesBurned(DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    final caloriesData = await fetchCaloriesData(startDate, endDate);

    if (caloriesData.isEmpty) return null;

    double total = 0.0;
    for (final dataPoint in caloriesData) {
      if (dataPoint.value is NumericHealthValue) {
        total += (dataPoint.value as NumericHealthValue).numericValue;
      }
    }

    return total;
  }

  /// Get active calories burned for a specific date
  Future<double?> getActiveCaloriesBurned(DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    final caloriesData = await fetchCaloriesData(
      startDate,
      endDate,
      activeEnergyOnly: true,
    );

    if (caloriesData.isEmpty) return null;

    double total = 0.0;
    for (final dataPoint in caloriesData) {
      if (dataPoint.value is NumericHealthValue) {
        total += (dataPoint.value as NumericHealthValue).numericValue;
      }
    }

    return total;
  }

  /// Get calories burned for a date range
  /// Returns a map of dates to total calories burned
  Future<Map<DateTime, double>> getCaloriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final caloriesData = await fetchCaloriesData(startDate, endDate);
    final Map<DateTime, double> caloriesByDate = {};

    for (final dataPoint in caloriesData) {
      if (dataPoint.value is NumericHealthValue) {
        final date = DateTime(
          dataPoint.dateFrom.year,
          dataPoint.dateFrom.month,
          dataPoint.dateFrom.day,
        );
        final calories = (dataPoint.value as NumericHealthValue).numericValue
            .toDouble();
        caloriesByDate[date] = (caloriesByDate[date] ?? 0.0) + calories;
      }
    }

    return caloriesByDate;
  }

  /// Write workout activity to health platform
  /// [activityType] - The type of workout activity (e.g., HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING)
  /// [start] - When the workout started
  /// [end] - When the workout ended
  /// [totalEnergyBurned] - Optional total calories burned during the workout (in kilocalories)
  Future<bool> writeWorkoutActivity({
    required HealthWorkoutActivityType activityType,
    required DateTime start,
    required DateTime end,
    double? totalEnergyBurned,
  }) async {
    if (!(await isAvailable)) {
      return false;
    }

    try {
      return await _health.writeWorkoutData(
        activityType: activityType,
        start: start,
        end: end,
        totalEnergyBurned: totalEnergyBurned?.toInt(),
      );
    } catch (e) {
      return false;
    }
  }

  /// Write workout activity from WorkoutLogsDTO
  /// Convenience method to write workout data from the app's workout log model
  Future<bool> writeWorkoutFromLog({
    required DateTime startTime,
    required Duration duration,
    double? totalEnergyBurned,
  }) async {
    final endTime = startTime.add(duration);

    // Default to traditional strength training for strength workouts
    // You can customize this based on your workout type enum
    return await writeWorkoutActivity(
      activityType: HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING,
      start: startTime,
      end: endTime,
      totalEnergyBurned: totalEnergyBurned,
    );
  }

  /// Sync weight data from health platform to app's measurement repository
  /// This is useful for importing weight data from health platforms
  Future<List<HealthDataPoint>> syncWeightData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!(await isAvailable)) {
      return [];
    }

    // Check if we have permission
    final hasPermission = await hasPermissions([HealthDataType.WEIGHT]);
    if (!hasPermission) {
      return [];
    }

    return await fetchWeightData(startDate, endDate);
  }

  Future<void> revokeAuthorization() async {
    if (Platform.isIOS) {
      throw Failure(
        message:
            "To revoke authorization, please go to settings and disable health integration in the app.",
      );
    }
    await _health.revokePermissions();
  }
}

final healthRepoProvider = Provider((ref) => HealthRepository(Health()));
