import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../data/models/playlist_model.dart';
import '../providers/playlist_provider.dart';
import '../screens/playlist_screen.dart';
import 'empty_playlist_cover.dart';
import 'liked_video_cover.dart';
import 'playlist_cover.dart';

class PlaylistHorizontalTile extends ConsumerWidget {
  final PlaylistModel? playlist;
  final String? playlistType;
  final String? userId;

  const PlaylistHorizontalTile({
    super.key,
    this.playlist,
    this.playlistType,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(fetchMyLikesProvider(userId!));

    return InkWell(
      onTap: () {
        final targetScreen = playlistType == "likedVideos"
            ? PlaylistScreen(playlistType: "likedVideos", userId: userId)
            : PlaylistScreen(playlist: playlist!, userId: userId);
        NavigationHelpers.navigateToScreen(context, targetScreen);
      },
      onLongPress: playlistType == "likedVideos"
          ? null
          : () {
              ModalHelpers.showBottomSheetForPlaylistOption(
                  context, playlist, ScreenType.outsidePlaylist);
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Playlist Cover
            /// If it is a liked video playlist
            /// then show the latest liked video cover
            /// otherwise show the playlist cover
            playlistType == "likedVideos"
                ? likes.when(
                    data: (like) {
                      if (like.isEmpty) {
                        return const EmptyPlaylistCover(
                          playlistType: "likedVideos",
                        );
                      }
                      final lastVideoLiked = like.first;
                      final videoId = lastVideoLiked.videoId;
                      return LikedVideoCover(videoId: videoId);
                    },
                    loading: () => const Loader(),
                    error: (error, stackTrace) => const SizedBox(),
                  )
                : PlaylistCover(playlist: playlist!),

            const SizedBox(width: 18.0),

            // Playlist details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlistType == "likedVideos"
                        ? AppStrings.likedVideos
                        : playlist!.name,
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.1),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),

                  // Playlist visibility or creator channel
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          playlistType == "likedVideos"
                              ? AppStrings.private
                              : playlist!.isPublic
                                  ? AppStrings.public
                                  : AppStrings.private,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      playlistType == "likedVideos"
                          ? const SizedBox()
                          : Text(
                              "⋅ Playlist",
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: context.ternaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),

                  // Created or Updated At
                  playlistType == "likedVideos"
                      ? const SizedBox()
                      : Text(
                          StringHelpers.formatDate(
                                  context, playlist!.createdAt) ??
                              "",
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                        ),
                ],
              ),
            ),

            // More button
            playlistType == "likedVideos"
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(left: 24.0),
                    child: InkWell(
                      onTap: () {
                        ModalHelpers.showBottomSheetForPlaylistOption(
                            context, playlist!, ScreenType.outsidePlaylist);
                      },
                      borderRadius: BorderRadius.circular(30.0),
                      child: Icon(
                        Icons.more_vert,
                        color: context.secondaryColor,
                        size: 20.0,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
