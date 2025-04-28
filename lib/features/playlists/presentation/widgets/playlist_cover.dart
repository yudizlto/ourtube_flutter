import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/models/playlist_model.dart';
import 'empty_playlist_cover.dart';
import 'indicator_video_count_playlist.dart';

class PlaylistCover extends ConsumerWidget {
  final PlaylistModel playlist;

  const PlaylistCover({super.key, required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (playlist.videos.isEmpty) {
      return EmptyPlaylistCover(playlist: playlist, playlistType: "playlist");
    }

    final videoRef = ref.watch(getVideoDetailsByIdProvider(playlist.videos[0]));

    return Column(
      children: [
        Container(
          width: 140.0,
          height: 5.0,
          decoration: const BoxDecoration(
            color: AppColors.blackDark3,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
        const SizedBox(height: 2.0),
        Stack(
          children: [
            videoRef.when(
              data: (data) {
                return Container(
                  width: 158.0,
                  height: 95.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(data.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              loading: () => const Loader(),
              error: (error, stackError) => const SizedBox(),
            ),

            // Indicator video count in the playlist
            IndicatorVideoCountPlaylist(playlist: playlist),
          ],
        ),
      ],
    );
  }
}
