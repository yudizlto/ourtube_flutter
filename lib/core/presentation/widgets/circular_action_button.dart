import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../utils/constants/app_colors.dart';
import '../styles/app_text_style.dart';

class CircularActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String? imagePath;
  final double? iconSize;
  final String? titleButton;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const CircularActionButton({
    super.key,
    required this.onTap,
    this.icon,
    this.imagePath,
    this.iconSize = 28.0,
    this.padding = const EdgeInsets.all(10.0),
    this.color = AppColors.white,
    this.titleButton,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? context.secondaryColor;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: padding!,
        child: Column(
          children: [
            _buildContent(iconColor),
            (titleButton != null)
                ? Text(
                    titleButton!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Color iconColor) {
    if (imagePath != null) {
      return Image.asset(imagePath!,
          width: 24.0, height: iconSize, color: iconColor, fit: BoxFit.cover);
    } else if (icon != null) {
      return Icon(icon, size: iconSize, color: iconColor);
    }
    return const SizedBox();
  }
}
