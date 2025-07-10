import 'package:flutter/material.dart';

/// App color scheme definition
class AppColors {
  /// Primary colors
  static const Color deepPurple = Colors.deepPurple;
  static Color purple = Colors.deepPurple.shade300;

  /// Secondary colors
  static const Color teal = Colors.teal;
  static const Color orange = Colors.orange;

  /// Gender colors
  static const Color male = Colors.blue;
  static const Color female = Colors.pink;

  /// Gradient colors
  static const Color gradientStart = Color(0xFFF6D6E6);
  static const Color gradientEnd = Color(0xFFE6FBFA);

  /// Background colors
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color greyBackground = Color(0xFFEAF6F6);
  static const Color petProfileBackground = Color(0xFFF9E9E0);

  /// Text colors
  static const Color black = Colors.black;
  static final Color grey = Colors.grey[800]!;
  static final Color lightGrey = Colors.grey[600]!;

  /// Border and shadow colors
  static Color deepPurpleBorder = Colors.deepPurple.withOpacity(0.1);
  static const Color shadowColor = Color(0xFFF6D6E6);

  /// Button colors
  static const Color actionRed = Colors.redAccent;

  /// Static gradients
  static const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}
