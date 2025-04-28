import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/styles/app_theme.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../user/presentation/providers/state/settings_notifier.dart';
import '../../data/models/playlist_model.dart';
import 'indicator_video_count_playlist.dart';

class EmptyPlaylistCover extends ConsumerWidget {
  final String playlistType;
  final PlaylistModel? playlist;
  final Color? color;

  const EmptyPlaylistCover({
    super.key,
    required this.playlistType,
    this.playlist,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeRef = ref.watch(settingsNotifier);

    return Column(
      children: [
        Container(
          width: 140.0,
          height: 5.0,
          decoration: BoxDecoration(
            color: themeRef.themeData == AppTheme.lightTheme
                ? AppColors.blackDark3
                : AppColors.blackDark4,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        if (playlistType == "likedVideos") ...[
          // Empty liked videos UI
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 158.0,
                height: 95.0,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey2,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Container(
                width: 158.0,
                height: 95.0,
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const Column(
                children: [
                  Icon(Icons.thumb_up, color: AppColors.white, size: 24.0),
                  Text(
                    "0",
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        ] else if (playlistType == "playlist" && playlist != null) ...[
          // Empty playlist UI
          Stack(
            children: [
              Container(
                width: 158.0,
                height: 95.0,
                decoration: BoxDecoration(
                  color: themeRef.themeData == AppTheme.lightTheme
                      ? AppColors.blackDark4
                      : AppColors.blackDark2,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              // Indicator for video count in the playlist
              IndicatorVideoCountPlaylist(playlist: playlist!),
            ],
          ),
        ],
      ],
    );
  }
}
