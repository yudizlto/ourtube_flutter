import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class VideoStatItem extends StatelessWidget {
  final String value;
  final String label;

  const VideoStatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(fontSize: 18.0),
        ),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: context.ternaryColor),
        ),
      ],
    );
  }
}
