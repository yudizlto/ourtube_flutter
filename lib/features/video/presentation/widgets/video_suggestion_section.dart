import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';
import 'short_suggestion_section.dart';

class VideoSuggestionSection extends ConsumerStatefulWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const VideoSuggestionSection({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  ConsumerState<VideoSuggestionSection> createState() =>
      _VideoSuggestionSectionState();
}

class _VideoSuggestionSectionState
    extends ConsumerState<VideoSuggestionSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataRef = ref.watch(getUserDetailsProvider(widget.video.videoId));
    final formattedDate =
        StringHelpers.timeAgo(context, widget.video.uploadedAt);

    return userDataRef.when(
      data: (userData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Short video suggestions section
            ShortSuggestionSection(localization: widget.localization),

            // Long video suggestions section
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: Column(
                  children: [
                    // Thumbnail cover
                    /// Check if the video has a thumbnail URL
                    /// If no thumbnail URL is provided, display a video player preview
                    /// If a thumbnail URL is provided, display the thumbnail image
                    widget.video.thumbnailUrl.isEmpty
                        ? SizedBox(
                            width: double.infinity,
                            height: 220.0,
                            child: VideoPlayer(_controller),
                          )
                        : Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.video.thumbnailUrl)
                                    as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                    // Video suggestion details
                    Container(
                      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Channel's avatar
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(userData!.photoUrl),
                          ),

                          // Video details: Title, Channel's name, views, uploaded date
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(
                                  15.0, 0.0, 10.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.video.title,
                                    style: AppTextStyles.bodyLarge
                                        .copyWith(height: 1.1),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8.0),
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.bodyLarge.copyWith(
                                          color: context.ternaryColor,
                                          overflow: TextOverflow.ellipsis),
                                      children: [
                                        TextSpan(
                                            text:
                                                userDataRef.value!.displayName),
                                        TextSpan(
                                            text:
                                                "  ⦁ ${widget.video.viewsCount} views"),
                                        TextSpan(text: "  ⦁ $formattedDate"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // More button
                          MoreIconButton(
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}
