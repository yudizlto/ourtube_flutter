import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/models/playlist_model.dart';
import 'action_button_in_playlist.dart';

class PlaylistHeroWithBlurOverlay extends ConsumerWidget {
  final String videoId;
  final String userId;
  final String? playlistType;
  final PlaylistModel? playlist;

  const PlaylistHeroWithBlurOverlay({
    super.key,
    required this.videoId,
    required this.userId,
    this.playlistType,
    this.playlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRef = ref.watch(getVideoDetailsByIdProvider(videoId));
    final userRef = ref.watch(getUserDetailsByIdProvider(userId));

    return videoRef.when(
      data: (data) {
        return Stack(
          children: [
            // Blur overlay
            Container(
              height: playlistType == "likedVideos" ? 350.0 : 420.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 2.0),
              child: Container(
                height: playlistType == "likedVideos" ? 350.0 : 420.0,
                color: AppColors.black.withOpacity(0.2),
              ),
            ),

            // Playlist cover and details
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  margin: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: NetworkImage(data.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                userRef.when(
                  data: (user) {
                    return _playlistDetails(
                        context, playlist, user, playlistType);
                  },
                  loading: () => const Loader(),
                  error: (error, stackrace) => const SizedBox(),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Loader(),
      error: (error, stackrace) {
        return const SizedBox();
      },
    );
  }

  /// Widget to display the playlist details
  Widget _playlistDetails(BuildContext context, PlaylistModel? playlist,
      UserModel user, String? playlistType) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist name
          Text(
            playlistType == "likedVideos"
                ? localization.liked_videos
                : playlist!.name,
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 28.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),

          // Playlist's creator info
          playlistType == "likedVideos"
              ? Text(
                  user.displayName,
                  style: AppTextStyles.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        "${localization.by} ${user.displayName}",
                        style: AppTextStyles.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

          const SizedBox(height: 12.0),

          // Visibility status and number of videos
          playlistType == "likedVideos"
              ? Row(
                  children: [
                    Text(
                      "${user.likedVideos} ${localization.videos}",
                      style: const TextStyle(color: AppColors.white),
                    ),
                    const SizedBox(width: 10.0),
                    const Icon(
                      Icons.lock_outline_sharp,
                      size: 16.0,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      localization.private,
                      style: const TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      playlist!.isPublic
                          ? localization.public
                          : localization.private,
                      style: TextStyle(
                        color: playlist.videos.isEmpty
                            ? AppColors.blackDark2
                            : AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      playlist.videos.isEmpty
                          ? localization.no_videos
                          : "${playlist.videos.length} ${localization.videos}",
                      style: TextStyle(
                        color: playlist.videos.isEmpty
                            ? AppColors.blackDark2
                            : AppColors.white,
                      ),
                    ),
                  ],
                ),

          // Playlist description
          /// Display the playlist's description if it exists
          playlistType == "likedVideos"
              ? const SizedBox(height: 24.0)
              : playlist!.description.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        playlist.description,
                        style: TextStyle(color: context.ternaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

          // Action buttons
          playlistType == "likedVideos"
              ? const SizedBox()
              : ActionButtonInPlaylist(
                  titleColor: context.primaryColor,
                  buttonColor: context.secondaryColor,
                ),
        ],
      ),
    );
  }
}
