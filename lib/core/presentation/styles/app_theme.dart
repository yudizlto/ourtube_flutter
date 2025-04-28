import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.lightDisplayLarge,
      displayMedium: AppTextStyles.lightDisplayMedium,
      displaySmall: AppTextStyles.lightDisplaySmall,
      headlineLarge: AppTextStyles.lightHeadlineLarge,
      headlineMedium: AppTextStyles.lightHeadlineMedium,
      headlineSmall: AppTextStyles.lightHeadlineSmall,
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.black),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.black),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.black),
      bodyLarge: AppTextStyles.lightBodyLarge,
      bodyMedium: AppTextStyles.lightBodyMedium,
      bodySmall: AppTextStyles.lightBodySmall,
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.black),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.black),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.black),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionHandleColor: AppColors.blue),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.black,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.darkDisplayLarge,
      displayMedium: AppTextStyles.darkDisplayMedium,
      displaySmall: AppTextStyles.darkDisplaySmall,
      headlineLarge: AppTextStyles.darkHeadlineLarge,
      headlineMedium: AppTextStyles.darkHeadlineMedium,
      headlineSmall: AppTextStyles.darkHeadlineSmall,
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.white),
      bodyLarge: AppTextStyles.darkBodyLarge,
      bodyMedium: AppTextStyles.darkBodyMedium,
      bodySmall: AppTextStyles.darkBodySmall,
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionHandleColor: AppColors.lightBlue),
  );
}
