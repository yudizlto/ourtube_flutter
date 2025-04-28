import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../utils/constants/app_colors.dart';
import '../styles/app_text_style.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T groupValue;
  final Color? titleColor;
  final ValueChanged<T>? onChanged;
  final Function() onTap;

  const CustomRadioButton({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    required this.value,
    required this.groupValue,
    this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      titleTextStyle: AppTextStyles.bodyLarge
          .copyWith(color: context.secondaryColor, fontSize: 18.0),
      subtitle: subtitle == null ? null : Text(subtitle!),
      subtitleTextStyle:
          AppTextStyles.bodyMedium.copyWith(color: context.ternaryColor),
      leading: Radio<T>(
        value: value,
        groupValue: groupValue,
        activeColor: context.activeColor,
        fillColor: MaterialStateProperty.resolveWith((states) {
          return groupValue == value
              ? context.activeColor
              : AppColors.blackDark3;
        }),
        splashRadius: 20.0,
        onChanged: (value) => onChanged,
      ),
      onTap: onTap,
    );
  }
}
