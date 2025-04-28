import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/enums/category.dart';
import '../../../../core/presentation/widgets/for_you_shorts.dart';
import '../../../../core/presentation/widgets/long_videos_list.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../providers/home_provider.dart';
import 'empty_content_message.dart';

/// A widget that displays video content based on the selected category.
/// If "All" is selected, it fetches videos from Firestore.
/// If a specific category is selected, a placeholder text is shown.
class ContentList extends ConsumerWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final allVideosRef = ref.watch(getAllVideosFromFirestore);
    final shortVideosRef = ref.watch(getShortsVideos);

    switch (selectedCategory) {
      case Category.all:
        return allVideosRef.when(
          data: (longVideos) {
            return shortVideosRef.when(
              data: (shortVideos) {
                return ListView(
                  children: [
                    // Long videos
                    if (longVideos.isNotEmpty) ...[
                      LongVideosList(
                        videosList: longVideos,
                        screenType: ScreenType.home,
                      ),
                    ],

                    // Grid Shorts
                    if (shortVideos.isNotEmpty) ...[
                      ForYouShortsVideo(shortsList: shortVideos),
                    ],
                  ],
                );
              },
              loading: () => const Loader(),
              error: (error, stackTrace) =>
                  const Center(child: Text("Error loading shorts videos")),
            );
          },
          loading: () => const Loader(),
          error: (error, stackTrace) =>
              const Center(child: Text("Error loading videos")),
        );

      case Category.gaming:
        return EmptyContentMessage(
            message: localization.category_no_content_message);

      default:
        return const Center(child: Text("Unknown Category"));
    }
  }
}
