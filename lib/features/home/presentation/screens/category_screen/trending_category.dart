import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widgets/content_card.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../providers/home_provider.dart';

class TrendingCategory extends ConsumerWidget {
  const TrendingCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getVideosTrending = ref.watch(trendingVideosProvider);

    return getVideosTrending.when(
      data: (videos) {
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
