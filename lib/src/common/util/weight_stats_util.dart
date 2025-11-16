import 'package:gamified/src/features/account/model/measurement.dart';

class WeightStatsUtil {
  static ({double initialWeight, double currentWeight, double difference}) 
      calculateWeightStats(
    List<MeasurementDTO> measurements,
    double currentWeight,
  ) {
    if (measurements.isEmpty) {
      return (
        initialWeight: 0.0,
        currentWeight: currentWeight,
        difference: 0.0,
      );
    }

    // Get oldest measurement (initial weight)
    final sortedByDate = List<MeasurementDTO>.from(measurements)
      ..sort((a, b) => a.date.compareTo(b.date));
    final initialMeasurement = sortedByDate.first;
    final initialWeight = initialMeasurement.weight;
    final difference = currentWeight - initialWeight;

    return (
      initialWeight: initialWeight,
      currentWeight: currentWeight,
      difference: difference,
    );
  }

  static MeasurementDTO? getInitialMeasurement(
    List<MeasurementDTO> measurements,
  ) {
    if (measurements.isEmpty) return null;

    final sortedByDate = List<MeasurementDTO>.from(measurements)
      ..sort((a, b) => a.date.compareTo(b.date));
    return sortedByDate.first;
  }
}

