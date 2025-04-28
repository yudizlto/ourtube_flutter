import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../data/models/video_model.dart';

class DurationIndicator extends StatelessWidget {
  final VideoModel video;
  final double? bottomPosition;
  final double? rightPosition;

  const DurationIndicator({
    super.key,
    required this.video,
    this.bottomPosition = 18.0,
    this.rightPosition = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDuration =
        StringHelpers.formatDuration(video.duration);

    return Positioned(
      bottom: bottomPosition,
      right: rightPosition,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          formattedDuration,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
