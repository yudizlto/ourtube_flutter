import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  Color get primaryColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.white
        : AppColors.black;
  }

  Color get secondaryColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.black
        : AppColors.white;
  }

  Color get ternaryColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.blackDark2
        : AppColors.blackDark3;
  }

  Color get surfaceColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.white
        : const Color(0xFF212121);
  }

  Color get buttonColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.lightGrey2
        : AppColors.blackDark1;
  }

  Color get disabledButtonColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.blackDark2
        : AppColors.blackDark1;
  }

  Color get popUpMenuColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.white
        : AppColors.blackDark1;
  }

  Color get secondarySurfaceColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.lightGrey1
        : const Color(0xff272727);
  }

  Color get errorColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.redDark4
        : AppColors.redLight2;
  }

  Color get activeColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.blue
        : AppColors.lightBlue;
  }

  Color get searchBarColor {
    return Theme.of(this).brightness == Brightness.light
        ? AppColors.blackDark5
        : AppColors.blackDark3;
  }
}
