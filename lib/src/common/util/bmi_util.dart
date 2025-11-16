import 'package:flutter/material.dart';

class BMIUtil {
  static double calculateBMI(double weight, double height) {
    if (height == 0) return 0.0;
    // BMI = weight (kg) / (height (m))^2
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  static ({String category, Color color, String description}) getBMICategory(
    double bmi,
  ) {
    if (bmi < 18.5) {
      return (
        category: 'Underweight',
        color: Colors.blue.shade600,
        description: 'Below normal range',
      );
    } else if (bmi >= 18.5 && bmi < 25.0) {
      return (
        category: 'Normal',
        color: Colors.green.shade600,
        description: 'Healthy range',
      );
    } else if (bmi >= 25.0 && bmi < 30.0) {
      return (
        category: 'Overweight',
        color: Colors.orange.shade600,
        description: 'Above normal range',
      );
    } else {
      return (
        category: 'Obese',
        color: Colors.red.shade600,
        description: 'Significantly above normal',
      );
    }
  }

  static bool isHealthyBMI(double bmi) {
    return bmi >= 18.5 && bmi < 25.0;
  }
}

