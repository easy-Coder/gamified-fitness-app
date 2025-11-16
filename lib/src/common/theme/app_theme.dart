import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:gamified/src/common/theme/app_colors.dart';
import 'package:gamified/src/common/theme/theme_extensions.dart';

/// Main theme configuration for the app
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ShadThemeData light() {
    final colors = AppLightColors();
    
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: ShadGrayColorScheme.light(),
      primaryButtonTheme: ShadButtonTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      extensions: [
        const FlashBarTheme(),
        const FlashToastTheme(),
        HydrationGradientExtension(
          gradientColors: colors.hydrationGradient,
          strokeWidth: 8,
        ),
        BMIColorsExtension(
          underweight: Colors.blue.shade600,
          normal: colors.success,
          overweight: colors.warning,
          obese: colors.error,
        ),
        HealthIntegrationColorsExtension(
          appleHealth: colors.healthApple,
          googleFit: colors.healthGoogle,
        ),
      ],
    );
  }

  /// Dark theme configuration
  static ShadThemeData dark() {
    final colors = AppDarkColors();
    
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: ShadGrayColorScheme.dark(),
      primaryButtonTheme: ShadButtonTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      extensions: [
        const FlashBarTheme(),
        const FlashToastTheme(),
        HydrationGradientExtension(
          gradientColors: colors.hydrationGradient,
          strokeWidth: 8,
        ),
        BMIColorsExtension(
          underweight: Colors.blue.shade400,
          normal: colors.success,
          overweight: colors.warning,
          obese: colors.error,
        ),
        HealthIntegrationColorsExtension(
          appleHealth: colors.healthApple,
          googleFit: colors.healthGoogle,
        ),
      ],
    );
  }

  /// Get colors for current brightness
  static AppColors colors(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppDarkColors()
        : AppLightColors();
  }
}

/// Extension for easy color access from ThemeData
extension AppThemeExtension on BuildContext {
  /// Get app colors based on current theme
  AppColors get appColors {
    final brightness = Theme.of(this).brightness;
    return AppTheme.colors(brightness);
  }
}

