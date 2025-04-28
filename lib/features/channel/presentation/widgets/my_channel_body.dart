import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/my_channel_provider.dart';
import 'channel_shorts_grid.dart';
import 'empty_body_content.dart';
import 'custom_tab_bar.dart';
import 'my_video_list_tile.dart';
import 'video_tab_filter_option.dart';

class MyChannelBody extends ConsumerStatefulWidget {
  final AppLocalizations localization;

  const MyChannelBody({super.key, required this.localization});

  @override
  ConsumerState<MyChannelBody> createState() => _MyChannelBodyState();
}

class _MyChannelBodyState extends ConsumerState<MyChannelBody> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final userRef = ref.read(currentUserProvider);
    final sortByRef = ref.watch(videoSortByProvider);

    final videoRef = ref.watch(sortByRef
        ? latestLongVidsProvider(userRef.value!.userId)
        : oldestLongVidsProvider(userRef.value!.userId));
    final shortsRef = ref.watch(sortByRef
        ? latestShortsProvider(userRef.value!.userId)
        : oldestShortsProvider(userRef.value!.userId));

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
              EmptyBodyContent(
                imagePath: AppAssets.videoIcon,
                title: widget.localization.empty_my_home,
                description: widget.localization.empty_my_home_description,
                shrinkingButton: ShrinkingButton(
                  text: widget.localization.create,
                  width: 100.0,
                  buttonColor: context.buttonColor,
                  textColor: context.secondaryColor,
                  fontWeight: FontWeight.bold,
                  onPressed: () {},
                ),
              ),

              // Channel's videos content
              videoRef.when(
                data: (videos) {
                  return videos.isEmpty
                      ? EmptyBodyContent(
                          imagePath: AppAssets.rollFilmIcon,
                          title: widget.localization.empty_videos,
                          description:
                              widget.localization.empty_videos_description,
                          shrinkingButton: ShrinkingButton(
                            text: widget.localization.create,
                            width: 100.0,
                            buttonColor: context.buttonColor,
                            textColor: context.secondaryColor,
                            fontWeight: FontWeight.bold,
                            onPressed: () {},
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VideoTabFilterOptions(),
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
                      ? EmptyBodyContent(
                          imagePath: AppAssets.shortsVideoIcon,
                          title: widget.localization.empty_shorts,
                          description:
                              widget.localization.empty_shorts_description,
                          shrinkingButton: ShrinkingButton(
                            text: widget.localization.create,
                            width: 100.0,
                            buttonColor: context.buttonColor,
                            textColor: context.secondaryColor,
                            fontWeight: FontWeight.bold,
                            onPressed: () {},
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VideoTabFilterOptions(),
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
              EmptyBodyContent(
                imagePath: AppAssets.listIcon,
                title: widget.localization.empty_playlist,
                description: widget.localization.empty_playlist_description,
                shrinkingButton: ShrinkingButton(
                  text: widget.localization.create,
                  width: 100.0,
                  buttonColor: context.buttonColor,
                  textColor: context.secondaryColor,
                  fontWeight: FontWeight.bold,
                  onPressed: () {},
                ),
              ),

              // Channel's community content
              EmptyBodyContent(
                imagePath: AppAssets.postIcon,
                title: widget.localization.empty_community,
                description: widget.localization.empty_community_description,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
