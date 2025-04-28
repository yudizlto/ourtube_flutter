import 'package:flutter/material.dart';

import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../video/data/models/video_model.dart';
import 'my_video_list_tile.dart';

class MyChannelVideos extends StatelessWidget {
  final List<VideoModel> videosList;

  const MyChannelVideos({super.key, required this.videosList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videosList.length,
      itemBuilder: (context, index) {
        final video = videosList[index];
        return MyVideoListTile(
          video: video,
          screenType: ScreenType.myVideoUploads,
        );
      },
    );
  }
}
