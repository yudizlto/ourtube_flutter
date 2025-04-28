import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class AppTextStyles {
  // Display Styles (Large Titles)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w500,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
  );

  // Light Theme Styles
  static final TextStyle lightDisplayLarge =
      displayLarge.copyWith(color: AppColors.black);
  static final TextStyle lightDisplayMedium =
      displayMedium.copyWith(color: AppColors.black);
  static final TextStyle lightDisplaySmall =
      displaySmall.copyWith(color: AppColors.black);

  static final TextStyle lightHeadlineLarge =
      headlineLarge.copyWith(color: AppColors.black);
  static final TextStyle lightHeadlineMedium =
      headlineMedium.copyWith(color: AppColors.black);
  static final TextStyle lightHeadlineSmall =
      headlineSmall.copyWith(color: AppColors.black);

  static final TextStyle lightBodyLarge =
      bodyLarge.copyWith(color: AppColors.black);
  static final TextStyle lightBodyMedium =
      bodyMedium.copyWith(color: AppColors.black);
  static final TextStyle lightBodySmall =
      bodySmall.copyWith(color: AppColors.black);

  // Dark Theme Styles
  static final TextStyle darkDisplayLarge =
      displayLarge.copyWith(color: AppColors.white);
  static final TextStyle darkDisplayMedium =
      displayMedium.copyWith(color: AppColors.white);
  static final TextStyle darkDisplaySmall =
      displaySmall.copyWith(color: AppColors.white);

  static final TextStyle darkHeadlineLarge =
      headlineLarge.copyWith(color: AppColors.white);
  static final TextStyle darkHeadlineMedium =
      headlineMedium.copyWith(color: AppColors.white);
  static final TextStyle darkHeadlineSmall =
      headlineSmall.copyWith(color: AppColors.white);

  static final TextStyle darkBodyLarge =
      bodyLarge.copyWith(color: AppColors.white);
  static final TextStyle darkBodyMedium =
      bodyMedium.copyWith(color: AppColors.white);
  static final TextStyle darkBodySmall =
      bodySmall.copyWith(color: AppColors.white);
}
