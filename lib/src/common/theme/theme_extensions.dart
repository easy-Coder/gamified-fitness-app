import 'package:flutter/material.dart';

/// Extension for hydration progress gradient colors
class HydrationGradientExtension extends ThemeExtension<HydrationGradientExtension> {
  final List<Color> gradientColors;
  final double strokeWidth;

  const HydrationGradientExtension({
    required this.gradientColors,
    this.strokeWidth = 8,
  });

  @override
  ThemeExtension<HydrationGradientExtension> copyWith({
    List<Color>? gradientColors,
    double? strokeWidth,
  }) {
    return HydrationGradientExtension(
      gradientColors: gradientColors ?? this.gradientColors,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  ThemeExtension<HydrationGradientExtension> lerp(
    ThemeExtension<HydrationGradientExtension>? other,
    double t,
  ) {
    if (other is! HydrationGradientExtension) {
      return this;
    }

    // Simple lerp for gradient colors
    final interpolatedColors = List.generate(
      gradientColors.length.clamp(0, other.gradientColors.length),
      (i) => Color.lerp(
        gradientColors[i],
        other.gradientColors[i],
        t,
      ) ?? gradientColors[i],
    );

    return HydrationGradientExtension(
      gradientColors: interpolatedColors,
      strokeWidth: (strokeWidth + (other.strokeWidth - strokeWidth) * t),
    );
  }
}

/// Extension for BMI category colors
class BMIColorsExtension extends ThemeExtension<BMIColorsExtension> {
  final Color underweight; // < 18.5
  final Color normal; // 18.5 - 24.9
  final Color overweight; // 25.0 - 29.9
  final Color obese; // ≥ 30.0

  const BMIColorsExtension({
    required this.underweight,
    required this.normal,
    required this.overweight,
    required this.obese,
  });

  @override
  ThemeExtension<BMIColorsExtension> copyWith({
    Color? underweight,
    Color? normal,
    Color? overweight,
    Color? obese,
  }) {
    return BMIColorsExtension(
      underweight: underweight ?? this.underweight,
      normal: normal ?? this.normal,
      overweight: overweight ?? this.overweight,
      obese: obese ?? this.obese,
    );
  }

  @override
  ThemeExtension<BMIColorsExtension> lerp(
    ThemeExtension<BMIColorsExtension>? other,
    double t,
  ) {
    if (other is! BMIColorsExtension) {
      return this;
    }

    return BMIColorsExtension(
      underweight: Color.lerp(underweight, other.underweight, t) ?? underweight,
      normal: Color.lerp(normal, other.normal, t) ?? normal,
      overweight: Color.lerp(overweight, other.overweight, t) ?? overweight,
      obese: Color.lerp(obese, other.obese, t) ?? obese,
    );
  }
}

/// Extension for health integration platform colors
class HealthIntegrationColorsExtension
    extends ThemeExtension<HealthIntegrationColorsExtension> {
  final Color appleHealth;
  final Color googleFit;

  const HealthIntegrationColorsExtension({
    required this.appleHealth,
    required this.googleFit,
  });

  @override
  ThemeExtension<HealthIntegrationColorsExtension> copyWith({
    Color? appleHealth,
    Color? googleFit,
  }) {
    return HealthIntegrationColorsExtension(
      appleHealth: appleHealth ?? this.appleHealth,
      googleFit: googleFit ?? this.googleFit,
    );
  }

  @override
  ThemeExtension<HealthIntegrationColorsExtension> lerp(
    ThemeExtension<HealthIntegrationColorsExtension>? other,
    double t,
  ) {
    if (other is! HealthIntegrationColorsExtension) {
      return this;
    }

    return HealthIntegrationColorsExtension(
      appleHealth: Color.lerp(appleHealth, other.appleHealth, t) ?? appleHealth,
      googleFit: Color.lerp(googleFit, other.googleFit, t) ?? googleFit,
    );
  }
}

/// Helper extension for accessing theme extensions easily
extension ThemeExtensionHelper on ThemeData {
  HydrationGradientExtension get hydrationColors =>
      extension<HydrationGradientExtension>()!;

  BMIColorsExtension get bmiColors => extension<BMIColorsExtension>()!;

  HealthIntegrationColorsExtension get healthIntegrationColors =>
      extension<HealthIntegrationColorsExtension>()!;
}

