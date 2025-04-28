import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../styles/app_text_style.dart';

class CustomActionRowButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final TextStyle textStyle;
  final String? imagePath;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final Function()? onTap;
  final double? imageWidth;

  const CustomActionRowButton({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.textStyle = AppTextStyles.bodyLarge,
    this.padding = const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    this.onTap,
    this.maxLines,
    this.imageWidth = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon),
            if (imagePath != null)
              Image.asset(imagePath!,
                  width: imageWidth, color: context.secondaryColor),
            const SizedBox(width: 24.0),
            Expanded(
                child: Text(
              title,
              style: textStyle,
              maxLines: maxLines,
            )),
          ],
        ),
      ),
    );
  }
}
