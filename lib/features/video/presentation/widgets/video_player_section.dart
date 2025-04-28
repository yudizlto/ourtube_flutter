import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';

class VideoPlayerSection extends ConsumerStatefulWidget {
  final VideoModel video;

  const VideoPlayerSection({super.key, required this.video});

  @override
  ConsumerState<VideoPlayerSection> createState() => _VideoPlayerSectionState();
}

class _VideoPlayerSectionState extends ConsumerState<VideoPlayerSection> {
  late VideoPlayerController _controller;
  late Duration _lastWatchedPosition;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            setState(() {
              _controller.play();
            });
          })
          ..addListener(() {
            if (_controller.value.isInitialized) {
              _lastWatchedPosition = _controller.value.position;
              ref.read(durationWatchedProvider.notifier).state =
                  _lastWatchedPosition.inSeconds;
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the visibility of the video controls
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  /// Toggles between play and pause for the video
  void _playPauseVideo() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  /// Restarts the video playback from the beginning
  void _reloadVideo() {
    setState(() {
      _controller.seekTo(Duration.zero);
      _controller.play();
    });
  }

  /// Closes the video player and updates the history
  void _handleMinimizeVideoScreen() {
    final updateHistoryRef = ref.read(updateHistoryUseCaseProvider);
    final durationRef = ref.watch(durationWatchedProvider);
    final userId = ref.read(currentUserProvider).value!.userId;
    Navigator.pop(context);
    updateHistoryRef.excute(widget.video.videoId, userId, durationRef);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          // Video player
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      // The video player
                      VideoPlayer(_controller),

                      // Video control buttons
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Control buttons: Minimize, Settings
                              Container(
                                margin: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () =>
                                            _handleMinimizeVideoScreen(),
                                        splashColor: AppColors.blackDark2
                                            .withOpacity(0.1),
                                        customBorder: const CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            AppAssets.downArrowIcon,
                                            width: 30.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: AppColors.blackDark2
                                            .withOpacity(0.1),
                                        customBorder: const CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            AppAssets.settingOutlinedIcon,
                                            width: 30.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Control buttons: Previous, Play/Pause, Next
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Previous button
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      onTap: () {},
                                      customBorder: const CircleBorder(),
                                      splashColor:
                                          AppColors.lightGrey2.withOpacity(0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              AppColors.black.withOpacity(0.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            AppAssets.previousIcon,
                                            width: 40.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Play/Pause button
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      onTap: _controller.value.position ==
                                              _controller.value.duration
                                          ? _reloadVideo
                                          : _playPauseVideo,
                                      customBorder: const CircleBorder(),
                                      splashColor:
                                          AppColors.lightGrey2.withOpacity(0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              AppColors.black.withOpacity(0.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            _controller.value.position ==
                                                    _controller.value.duration
                                                ? AppAssets.reloadIcon
                                                : (_controller.value.isPlaying
                                                    ? AppAssets.pauseIcon
                                                    : AppAssets.playIcon),
                                            width: 60.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Next button
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      onTap: () {},
                                      customBorder: const CircleBorder(),
                                      splashColor:
                                          AppColors.lightGrey2.withOpacity(0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              AppColors.black.withOpacity(0.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            AppAssets.nextIcon,
                                            width: 40.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Control buttons: Duration, Fullscreen
                              Container(
                                margin: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Spacer(),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: AppColors.blackDark2
                                            .withOpacity(0.1),
                                        customBorder: const CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            AppAssets.fullscreenIcon,
                                            width: 35.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Video progress indicator
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 8.5,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: _showControls
                                  ? AppColors.red
                                  : AppColors.white,
                              bufferedColor: AppColors.blackDark4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blackDark5,
                  ),
                ),
        ],
      ),
    );
  }
}
