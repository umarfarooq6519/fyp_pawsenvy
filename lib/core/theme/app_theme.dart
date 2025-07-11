import 'package:flutter/material.dart';

/// Common border radius values used throughout the app
class AppBorderRadius {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double xLarge = 28.0;
}

/// Common spacing values used throughout the app
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double huge = 32.0;
}

/// Common box shadows used throughout the app
class AppShadows {
  static BoxShadow get light =>
      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8);

  static BoxShadow get medium =>
      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12);

  static BoxShadow get heavy =>
      BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20);

  static BoxShadow get purple => BoxShadow(
    color: Colors.deepPurple.withValues(alpha: 0.15),
    blurRadius: 8,
  );

  // Shadow lists
  static List<BoxShadow> get lightShadow => [light];
  static List<BoxShadow> get mediumShadow => [medium];
  static List<BoxShadow> get heavyShadow => [heavy];
  static List<BoxShadow> get purpleShadow => [purple];
}
