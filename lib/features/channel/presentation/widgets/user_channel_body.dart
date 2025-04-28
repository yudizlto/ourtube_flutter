import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../home/presentation/widgets/empty_content_message.dart';
import '../../../user/data/models/user_model.dart';
import '../providers/user_channel_provider.dart';
import 'channel_shorts_grid.dart';
import 'custom_tab_bar.dart';
import 'my_video_list_tile.dart';

class UserChannelBody extends ConsumerStatefulWidget {
  final AppLocalizations localization;
  final UserModel user;

  const UserChannelBody({
    super.key,
    required this.localization,
    required this.user,
  });

  @override
  ConsumerState<UserChannelBody> createState() => _UserChannelBodyState();
}

class _UserChannelBodyState extends ConsumerState<UserChannelBody> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final sortByRef = ref.watch(videoSortByProvider);

    final videoRef = ref.watch(sortByRef
        ? latestVideosProvider(widget.user.userId)
        : oldestVideosProvider(widget.user.userId));
    final shortsRef = ref.watch(sortByRef
        ? latestShortsProvider(widget.user.userId)
        : oldestShortsProvider(widget.user.userId));

    final PageController pageController =
        PageController(initialPage: selectedIndex);

    final List<String> titles = [
      widget.localization.home,
      widget.localization.videos_label,
      widget.localization.shorts,
      widget.localization.playlists,
      widget.localization.community
    ];

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomTabBar(
            title: titles,
            selectedIndex: selectedIndex,
            onTap: (index) {
              ref.read(selectedIndexProvider.notifier).state = index;
              pageController.jumpToPage(index);
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 350.0,
          margin: const EdgeInsets.only(top: 10.0),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) =>
                ref.read(selectedIndexProvider.notifier).state = index,
            children: [
              // Channel's home content
              EmptyContentMessage(
                padding: const EdgeInsets.only(bottom: 10.0),
                imagePath: AppAssets.filmNegativeIcon,
                color: context.secondaryColor,
                message: widget.localization.no_content_on_this_channel,
              ),

              // Channel's videos content
              videoRef.when(
                data: (videos) {
                  return videos.isEmpty
                      ? EmptyContentMessage(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          imagePath: AppAssets.rollFilmIcon,
                          message:
                              widget.localization.no_content_on_this_channel,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              itemCount: videos.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final video = videos[index];

                                /// List of this channel's videos
                                return MyVideoListTile(
                                  video: video,
                                  screenType: ScreenType.myChannel,
                                );
                              },
                            ),
                          ],
                        );
                },
                loading: () => const Loader(),
                error: (error, stack) => const SizedBox(),
              ),

              // Channel's shorts content
              shortsRef.when(
                data: (shorts) {
                  return shorts.isEmpty
                      ? EmptyContentMessage(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          imagePath: AppAssets.shortsVideoIcon,
                          color: context.secondaryColor,
                          message:
                              widget.localization.no_content_on_this_channel,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChannelShortsGrid(
                              localization: widget.localization,
                              ref: ref,
                              shortsList: shorts,
                              onTap: () {},
                            ),
                          ],
                        );
                },
                loading: () => const Loader(),
                error: (error, stack) => const SizedBox(),
              ),

              // Channel's playlist content
              EmptyContentMessage(
                padding: const EdgeInsets.only(bottom: 10.0),
                imagePath: AppAssets.listIcon,
                message: widget.localization.no_content_on_this_channel,
              ),

              // Channel's community content
              EmptyContentMessage(
                padding: const EdgeInsets.only(bottom: 10.0),
                imagePath: AppAssets.postIcon,
                message: widget.localization.no_content_on_this_channel,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
