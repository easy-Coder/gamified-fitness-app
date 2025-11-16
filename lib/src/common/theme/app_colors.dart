import 'package:flutter/material.dart';

/// Base class for app color definitions
abstract class AppColors {
  // Primary colors
  Color get primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;

  // Surface colors
  Color get surface;
  Color get onSurface;
  Color get surfaceContainer;
  Color get onSurfaceContainer;
  Color get background;
  Color get onBackground;

  // Grey scale
  Color get grey50;
  Color get grey100;
  Color get grey200;
  Color get grey300;
  Color get grey400;
  Color get grey600;
  Color get grey700;

  // Semantic colors
  Color get success;
  Color get onSuccess;
  Color get warning;
  Color get onWarning;
  Color get error;
  Color get onError;
  Color get info;
  Color get onInfo;

  // Feature colors
  List<Color> get hydrationGradient;
  Color get healthApple;
  Color get healthGoogle;
}

/// Light theme colors
class AppLightColors extends AppColors {
  @override
  Color get primary => Colors.black;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => Colors.black87;

  @override
  Color get onPrimaryContainer => Colors.white;

  @override
  Color get surface => Colors.white;

  @override
  Color get onSurface => Colors.black87;

  @override
  Color get surfaceContainer => Colors.grey.shade50;

  @override
  Color get onSurfaceContainer => Colors.black54;

  @override
  Color get background => Colors.white;

  @override
  Color get onBackground => Colors.black87;

  @override
  Color get grey50 => Colors.grey.shade50;

  @override
  Color get grey100 => Colors.grey.shade100;

  @override
  Color get grey200 => Colors.grey.shade200;

  @override
  Color get grey300 => Colors.grey.shade300;

  @override
  Color get grey400 => Colors.grey.shade400;

  @override
  Color get grey600 => Colors.grey.shade600;

  @override
  Color get grey700 => Colors.grey.shade700;

  @override
  Color get success => Colors.green.shade600;

  @override
  Color get onSuccess => Colors.white;

  @override
  Color get warning => Colors.orange.shade600;

  @override
  Color get onWarning => Colors.white;

  @override
  Color get error => Colors.red.shade600;

  @override
  Color get onError => Colors.white;

  @override
  Color get info => Colors.blue.shade600;

  @override
  Color get onInfo => Colors.white;

  @override
  List<Color> get hydrationGradient => [
    const Color(0xFF64B5F6), // Light blue
    const Color(0xFF42A5F5), // Medium blue
    const Color(0xFF1E88E5), // Darker blue
    const Color(0xFF1976D2), // Deep blue
  ];

  @override
  Color get healthApple => Colors.red.shade400;

  @override
  Color get healthGoogle => Colors.green.shade600;
}

/// Dark theme colors
class AppDarkColors extends AppColors {
  @override
  Color get primary => Colors.white;

  @override
  Color get onPrimary => Colors.black87;

  @override
  Color get primaryContainer => Colors.grey.shade200;

  @override
  Color get onPrimaryContainer => Colors.black87;

  @override
  Color get surface => const Color(0xFF1E1E1E);

  @override
  Color get onSurface => Colors.white;

  @override
  Color get surfaceContainer => const Color(0xFF2A2A2A);

  @override
  Color get onSurfaceContainer => Colors.grey.shade300;

  @override
  Color get background => const Color(0xFF121212);

  @override
  Color get onBackground => Colors.white;

  @override
  Color get grey50 => const Color(0xFF424242);

  @override
  Color get grey100 => const Color(0xFF383838);

  @override
  Color get grey200 => const Color(0xFF2E2E2E);

  @override
  Color get grey300 => const Color(0xFF525252);

  @override
  Color get grey400 => const Color(0xFF616161);

  @override
  Color get grey600 => const Color(0xFF757575);

  @override
  Color get grey700 => const Color(0xFF9E9E9E);

  @override
  Color get success => Colors.green.shade400;

  @override
  Color get onSuccess => Colors.black87;

  @override
  Color get warning => Colors.orange.shade400;

  @override
  Color get onWarning => Colors.black87;

  @override
  Color get error => Colors.red.shade400;

  @override
  Color get onError => Colors.white;

  @override
  Color get info => Colors.blue.shade400;

  @override
  Color get onInfo => Colors.black87;

  @override
  List<Color> get hydrationGradient => [
    const Color(0xFF81D4FA), // Brighter light blue for dark mode
    const Color(0xFF64B5F6),
    const Color(0xFF42A5F5),
    const Color(0xFF1E88E5),
  ];

  @override
  Color get healthApple => const Color(0xFFEF5350);

  @override
  Color get healthGoogle => const Color(0xFF66BB6A);
}
