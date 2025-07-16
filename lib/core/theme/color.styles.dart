import 'package:flutter/material.dart';

/// App color scheme definition
class AppColorStyles {
  static const Color white = Colors.white;
  static const Color offWhite = Color(0xffeeeeee);
  static const Color black = Color(0xff222222);
  static const Color transparent = Colors.transparent;

  static final Color grey = Colors.grey.shade700;
  static final Color lightGrey = Colors.grey.shade500;

  static const Color deepPurple = Colors.deepPurple;
  static Color purple = Colors.deepPurple.shade300;
  static Color lightPurple = Colors.deepPurple.withOpacity(0.1);

  static Color red = Colors.redAccent;
  static const Color pastelGreen = Color(0xFFB2F2B2);
  static const Color pastelRed = Color(0xFFFFB6C1);

  static const Color gradientStart = Color(0xFFF6D6E6);
  static const Color gradientEnd = Color(0xFFE6FBFA);

  static const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}
