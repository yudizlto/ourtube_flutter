import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'loader.dart';

class ShortsThumbnailPreview extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;

  const ShortsThumbnailPreview({
    super.key,
    required this.videoUrl,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  State<ShortsThumbnailPreview> createState() => _ShortsThumbnailPreviewState();
}

class _ShortsThumbnailPreviewState extends State<ShortsThumbnailPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const Loader(),
    );
  }
}
