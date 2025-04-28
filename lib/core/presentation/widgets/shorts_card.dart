import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';
import '../styles/app_text_style.dart';
import 'more_icon_button.dart';
import 'shorts_thumbnail_preview.dart';

class ShortsCard extends StatelessWidget {
  final String title;
  final String videoUrl;
  final double? width;
  final double? height;

  const ShortsCard({
    super.key,
    required this.title,
    required this.videoUrl,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          // Shorts video or the thumbnail
          ShortsThumbnailPreview(videoUrl: videoUrl),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // More button
          Positioned(
            right: 10.0,
            top: 10.0,
            child: Material(
              color: Colors.transparent,
              child: MoreIconButton(
                padding: EdgeInsets.zero,
                onTap: () {},
              ),
            ),
          ),

          // Shorts' video title
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 16.0,
                color: AppColors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
