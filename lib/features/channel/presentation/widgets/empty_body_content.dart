import 'package:flutter/material.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class EmptyBodyContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Widget? shrinkingButton;
  final VoidCallback? onButtonPressed;

  const EmptyBodyContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.shrinkingButton,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 100.0,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
        const SizedBox(height: 16.0),
        Text(title, style: AppTextStyles.titleMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
          child: Text(
            description,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15.0),
        if (shrinkingButton != null) shrinkingButton!
      ],
    );
  }
}
