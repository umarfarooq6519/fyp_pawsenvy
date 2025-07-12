import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// App text styles
class AppTextStyles {
  // Headings
  static TextStyle get headingLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingMedium => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingSmall => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );

  // Body text
  static TextStyle get bodyBase => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );
  // Button text
  static TextStyle get buttonText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColorStyles.white,
    fontFamily: 'Poppins',
  );
}
