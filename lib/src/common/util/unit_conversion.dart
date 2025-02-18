extension UnitConversion on num {
  // Weight conversion (kg to lbs only)
  /// Converts kilograms to pounds
  /// 1 kg = 2.20462 lbs
  double get toLbs => this * 2.20462;

  // Volume conversion (ml to fl oz only)
  /// Converts milliliters to fluid ounces
  /// 1 ml = 0.033814 fl oz
  double get toOz => this * 0.033814;

  // Height conversions
  /// Converts centimeters to feet and inches format
  /// Returns a string in the format "X'Y""
  ({int feet, int inches}) get toFtIn {
    final totalInches = this * 0.393701;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return (feet: feet, inches: inches);
  }

  /// Helper to format decimals
  String toFixed(int decimals) => toStringAsFixed(decimals);
}
