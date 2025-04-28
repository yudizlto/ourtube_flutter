import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_colors.dart';

class VisibilityOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String visibilityRef;
  final Function(String) onChanged;
  final Function() onTap;

  const VisibilityOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.visibilityRef,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    /// Function to determine the color based on the selection
    Color getTitleColor(String value, String ref) {
      return value == visibilityRef
          ? context.activeColor
          : context.secondaryColor;
    }

    return ListTile(
      title: Text(title),
      titleTextStyle: AppTextStyles.bodyLarge
          .copyWith(color: getTitleColor(value, visibilityRef)),
      subtitle: Text(subtitle),
      subtitleTextStyle:
          AppTextStyles.bodyMedium.copyWith(color: context.ternaryColor),
      leading: Radio<String>(
        value: value,
        groupValue: visibilityRef,
        activeColor: context.activeColor,
        fillColor: MaterialStateProperty.resolveWith((states) {
          return visibilityRef == value
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
