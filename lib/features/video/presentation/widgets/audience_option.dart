import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class AudienceOption extends StatelessWidget {
  final String title;
  final bool value;
  final bool audienceRef;
  final Function(bool) onChanged;
  final Function() onTap;

  const AudienceOption({
    super.key,
    required this.title,
    required this.value,
    required this.audienceRef,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      titleTextStyle:
          AppTextStyles.bodyLarge.copyWith(color: context.secondaryColor),
      leading: Radio<bool>(
        value: value,
        groupValue: audienceRef,
        activeColor: context.activeColor,
        fillColor: MaterialStateProperty.resolveWith((states) {
          return audienceRef == value
              ? context.activeColor
              : context.ternaryColor;
        }),
        splashRadius: 20.0,
        onChanged: (value) => onChanged,
      ),
      onTap: onTap,
    );
  }
}
