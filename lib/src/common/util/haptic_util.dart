import 'package:flutter/services.dart';
import 'package:gaimon/gaimon.dart';

/// Utility class for playing haptic feedback
class HapticUtil {
  /// Helpers method (Play feedback safely)

  static void _playFeedback(VoidCallback modeCallback) async {
    if (await Gaimon.canSupportsHaptic) {
      modeCallback();
    }
  }

  /// Helpers method (load ahap files)
  static Future<String> _loadFromAssets(String assetPath) async {
    try {
      final String pattern = await rootBundle.loadString(
        "assets/haptics/$assetPath.ahap",
      );

      return pattern;
    } catch (e) {
      throw Exception('Failed to load AHAP file from assets: $e');
    }
  }

  // Basic feedback methods
  static void selection() => _playFeedback(() => Gaimon.selection());

  static void error() => _playFeedback(() => Gaimon.error());

  static void success() => _playFeedback(() => Gaimon.success());

  static void warning() => _playFeedback(() => Gaimon.warning());

  static void heavy() => _playFeedback(() => Gaimon.heavy());

  static void medium() => _playFeedback(() => Gaimon.medium());

  static void light() => _playFeedback(() => Gaimon.light());

  static void rigid() => _playFeedback(() => Gaimon.rigid());

  static void soft() => _playFeedback(() => Gaimon.soft());

  /// Load and play AHAP file from assets
  static void playFromFile(String assetPath) => _playFeedback(() async {
    try {
      final String ahapJson = await _loadFromAssets(assetPath);
      Gaimon.patternFromData(ahapJson);
    } catch (e) {
      throw Exception('Failed to play AHAP from assets: $e');
    }
  });
}
