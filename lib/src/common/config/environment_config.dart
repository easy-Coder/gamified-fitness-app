import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static Future<void> load() async {
    try {
      const envFileName = ".env";
      await dotenv.load(fileName: envFileName);
      if (kDebugMode) {
        print("✅ AppConfig: Loaded environment variables from $envFileName");
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          "⚠️ AppConfig: Could not load $e file. Using defaults or expecting errors.",
        );
        print("Error details: $e");
      }
      throw Exception(e.toString());
    }
  }

  static String _getMandatoryVariable(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception("❌ Missing mandatory environment variable: $key");
    }
    return value;
  }

  // static String _getVariableWithDefault(String key, String defaultValue) {
  //   return dotenv.env[key] ?? defaultValue;
  // }

  static String exerciseBaseUrl = _getMandatoryVariable("EXERCISE_BASE_URL");
}
