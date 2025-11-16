import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App-specific text theme configurations
class AppTextTheme {
  AppTextTheme._();

  /// Display text style - for very large headings
  static TextStyle display(BuildContext context) => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );

  /// Large heading text style (h1)
  static TextStyle h1(BuildContext context) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
      );

  /// Medium-large heading text style (h2)
  static TextStyle h2(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  /// Medium heading text style (h3)
  static TextStyle h3(BuildContext context) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      );

  /// Small heading text style (h4)
  static TextStyle h4(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      );

  /// Body large text style
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      );

  /// Body medium text style
  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      );

  /// Body small text style
  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
      );

  /// Label large text style
  static TextStyle labelLarge(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  /// Label medium text style
  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// Label small text style
  static TextStyle labelSmall(BuildContext context) => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// Muted text style
  static TextStyle muted(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      );

  /// Button text style
  static TextStyle button(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  /// Caption text style
  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
      );

  /// Overline text style
  static TextStyle overline(BuildContext context) => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      );
}

/// Extension methods for easy text theme access
extension TextThemeExtension on TextTheme {
  // Note: These extensions are meant for shadcn_ui usage
  // Actual implementations should use AppTextTheme directly with BuildContext
  // or use the BuildContext extensions below
}

/// Helper extension for accessing app text theme styles
extension AppTextThemeHelper on BuildContext {
  /// Get display text style
  TextStyle get displayStyle => AppTextTheme.display(this);

  /// Get h1 text style
  TextStyle get h1Style => AppTextTheme.h1(this);

  /// Get h2 text style
  TextStyle get h2Style => AppTextTheme.h2(this);

  /// Get h3 text style
  TextStyle get h3Style => AppTextTheme.h3(this);

  /// Get h4 text style
  TextStyle get h4Style => AppTextTheme.h4(this);

  /// Get body large text style
  TextStyle get bodyLargeStyle => AppTextTheme.bodyLarge(this);

  /// Get body medium text style
  TextStyle get bodyMediumStyle => AppTextTheme.bodyMedium(this);

  /// Get body small text style
  TextStyle get bodySmallStyle => AppTextTheme.bodySmall(this);

  /// Get muted text style
  TextStyle get mutedStyle => AppTextTheme.muted(this);
}

