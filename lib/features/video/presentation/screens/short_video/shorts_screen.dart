import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../home/presentation/providers/home_provider.dart';
import '../../widgets/overlay_shorts_player.dart';

class ShortsVideoScreen extends ConsumerStatefulWidget {
  const ShortsVideoScreen({super.key});

  @override
  ConsumerState<ShortsVideoScreen> createState() => _ShortsVideoScreenState();
}

class _ShortsVideoScreenState extends ConsumerState<ShortsVideoScreen> {
  late PageController _pageController;
  List<VideoPlayerController> _videoControllers = [];
  int _currentPage = 0;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  /// Called when the user scrolls to a different page
  void _onPageChanged(int index) {
    if (_videoControllers.isNotEmpty) {
      /// Pause the previous video
      _videoControllers[_currentPage].pause();

      /// Play the new video
      _videoControllers[index].play();
    }
    setState(() {
      _currentPage = index;
      _showControls = true;
    });
    _showControlsTemporarily();
  }

  /// Show controls temporarily (e.g. play/pause button)
  void _showControlsTemporarily() {
    setState(() => _showControls = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  /// Toggles between play and pause on tap
  void _playPauseVideo() {
    if (_videoControllers.isEmpty) return;
    final controller = _videoControllers[_currentPage];

    if (controller.value.isPlaying) {
      controller.pause();
      _showControlsTemporarily();
    } else {
      controller.play();
      _showControlsTemporarily();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortsList = ref.watch(getShortsVideos);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: shortsList.when(
          data: (shorts) {
            /// Re-initialize the video controllers if the list of shorts changes
            if (_videoControllers.length != shorts.length) {
              /// Dispose old controllers
              for (var controller in _videoControllers) {
                controller.dispose();
              }

              /// Create new controllers from the Firestore data
              _videoControllers = shorts.map((short) {
                final controller =
                    VideoPlayerController.networkUrl(Uri.parse(short.videoUrl))
                      ..initialize().then((_) => setState(() {}));
                return controller;
              }).toList();

              /// Auto-play the first video after all are initialized
              Future.microtask(() {
                if (_videoControllers[_currentPage].value.isInitialized) {
                  _videoControllers[_currentPage].play();
                }
              });
            }

            return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: shorts.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final controller = _videoControllers[index];
                final data = shorts[index];

                return controller.value.isInitialized
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          // Video player with cover fit
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),

                          // Overlay component for controls and video info
                          OverlayShortsPlayer(
                            handlePlayPauseButton: _playPauseVideo,
                            isPlaying: controller.value.isPlaying,
                            showControls: _showControls,
                            video: data,
                          ),
                        ],
                      )
                    : const Loader();
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
