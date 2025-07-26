import 'package:flutter/material.dart';
import 'color.styles.dart';

/// App text styles
class AppTextStyles {
  // ########### HEADINGS
  static TextStyle get headingExtraLarge => const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );
  static TextStyle get headingLarge => const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingMedium => const TextStyle(
    fontSize: 22,
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

  // ########### BODY
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
  static TextStyle get bodyExtraSmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorStyles.black,
    fontFamily: 'Poppins',
  );
  static TextStyle get buttonText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColorStyles.white,
    fontFamily: 'Poppins',
  );
}
