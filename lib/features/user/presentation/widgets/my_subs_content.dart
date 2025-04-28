import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/content_card.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/long_videos_list.dart';
import '../../../../core/presentation/widgets/shorts_grid.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/content_category.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../home/presentation/widgets/empty_content_message.dart';
import '../providers/subscription_provider.dart';

class MySubsContent extends ConsumerWidget {
  final AppLocalizations localization;

  const MySubsContent({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mySubsContent = ref.watch(getMySubsContentsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return mySubsContent.when(
      data: (content) {
        /// Filter out videos with type 'Long'
        final videosList =
            content.where((video) => video.type == AppStrings.long).toList();

        /// Filter out videos with type 'Shorts'
        final shortsList =
            content.where((video) => video.type == AppStrings.shorts).toList();

        /// Display content based on the selected category
        switch (selectedCategory) {
          /// Show all content as a list
          case ContentCategory.all:
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: content.length,
              itemBuilder: (context, index) {
                final data = content[index];
                return ContentCard(
                  title: data.title,
                  thumbnail: data.thumbnailUrl,
                  userId: data.userId,
                  screenType: ScreenType.subscriptions,
                  video: data,
                );
              },
            );

          /// Show only long-form videos in a vertical list
          case ContentCategory.videos:
            return LongVideosList(
              videosList: videosList,
              screenType: ScreenType.subscriptions,
            );

          /// Show only short-form videos in a grid layout
          case ContentCategory.shorts:
            return ShortsGrid(
              shortsList: shortsList,
              onTap: () {},
            );

          /// Show only posts in a vertical list
          case ContentCategory.posts:
            return EmptyContentMessage(
                message: localization.category_no_content_message);

          /// No posts available for now — show empty state
          default:
            return EmptyContentMessage(
                message: localization.category_no_content_message);
        }
      },
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const Loader(),
    );
  }
}
