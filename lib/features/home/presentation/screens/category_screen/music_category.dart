import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widgets/content_card.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../providers/home_provider.dart';

class MusicCategory extends ConsumerWidget {
  const MusicCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getMusicVideos = ref.watch(categoryVideosProvider("10"));

    return getMusicVideos.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const Center(child: Text("No videos found in this category"));
        }
        return Column(
          children: List.generate(videos.length, (index) {
            final video = videos[index];
            final thumbnail = video.thumbnailUrl;
            final title = video.title;
            final channelName = video.channelTitle;

            return ContentCard(
              thumbnail: thumbnail,
              title: title,
              channelName: channelName,
            );
          }),
        );
      },
      loading: () => const Loader(),
      error: (err, _) => Center(child: Text("Error: $err")),
    );
  }
}
