import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';
import 'package:video_player/video_player.dart';

import '../../../features/video/data/models/video_model.dart';
import '../../../features/video/presentation/widgets/duration_indicator.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/enums/screen_type.dart';
import 'loader.dart';

class PreviewThumbnailVideo extends StatefulWidget {
  final VideoModel video;
  final ScreenType? screenType;

  const PreviewThumbnailVideo({
    super.key,
    required this.video,
    this.screenType,
  });

  @override
  State<PreviewThumbnailVideo> createState() => _PreviewThumbnailVideoState();
}

class _PreviewThumbnailVideoState extends State<PreviewThumbnailVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 158.0,
          height: 95.0,
          margin: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: context.buttonColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: widget.video.type == AppStrings.shorts

              /// If video is a 'Shorts' type, show the video player directly (vertically framed).
              ? Center(
                  child: SizedBox(
                    width: 55.0,
                    height: 95.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _controller.value.isInitialized
                          ? VideoPlayer(_controller)
                          : const Loader(),
                    ),
                  ),
                )

              /// For 'Long' videos, check if a thumbnail URL is provided.
              /// If no thumbnail is available, show a placeholder image.
              /// Otherwise, show the provided thumbnail from network.
              : (widget.video.thumbnailUrl.isEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        AppAssets.imagePlaceholder,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.video.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
        ),

        /// If the video is a 'Shorts' type, show the colored icon at the bottom right corner.
        /// If the video is a 'Long' type, show the duration indicator at the bottom right corner.
        widget.screenType == ScreenType.history &&
                widget.video.type == AppStrings.shorts
            ? Positioned(
                bottom: 5.0,
                right: 28.0,
                child: Image.asset(
                  AppAssets.coloredShortIcon,
                  width: 30.0,
                ),
              )
            : DurationIndicator(
                video: widget.video,
                bottomPosition: 5.0,
                rightPosition: 28.0,
              ),
      ],
    );
  }
}
