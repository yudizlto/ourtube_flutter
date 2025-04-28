import 'package:flutter/material.dart';

import '../../../features/video/data/models/video_model.dart';
import '../../utils/constants/enums/screen_type.dart';
import 'content_card.dart';

class LongVideosList extends StatelessWidget {
  final List<VideoModel> videosList;
  final ScreenType screenType;

  const LongVideosList({
    super.key,
    required this.videosList,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videosList.length,
      itemBuilder: (context, index) {
        final video = videosList[index];
        return ContentCard(
          title: video.title,
          thumbnail: video.thumbnailUrl,
          userId: video.userId,
          screenType: screenType,
          video: video,
        );
      },
    );
  }
}
