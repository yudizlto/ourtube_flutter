import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/playlist_model.dart';
import 'action_button_in_playlist.dart';

class EmptyPlaylist extends ConsumerWidget {
  final PlaylistModel? playlist;
  final String playlistType;

  const EmptyPlaylist({
    super.key,
    this.playlist,
    required this.playlistType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = playlistType == "likedVideos"
        ? ref.read(currentUserProvider)
        : ref.watch(getUserDetailsByIdProvider(playlist!.userId));

    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        userRef.when(
          data: (user) {
            return _playlistDetails(
                context, localization, playlist, user, playlistType);
          },
          loading: () => const Loader(),
          error: (error, stackrace) => const SizedBox(),
        ),
        Center(
          child: Text(
            localization.no_videos_in_playlist,
            style: AppTextStyles.bodyLarge.copyWith(
              color: context.ternaryColor,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _playlistDetails(BuildContext context, AppLocalizations localization,
      PlaylistModel? playlist, UserModel user, String? playlistType) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist name
          Text(
            playlistType == "likedVideos"
                ? localization.liked_videos
                : playlist!.name,
            style: AppTextStyles.headlineMedium
                .copyWith(fontWeight: FontWeight.bold),
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
                      localization.no_videos,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: context.ternaryColor),
                    ),
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.lock_outline,
                      size: 16.0,
                      color: context.ternaryColor,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      localization.private,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: context.ternaryColor),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      playlist!.isPublic
                          ? localization.public
                          : localization.private,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: context.ternaryColor),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      playlist.videos.isEmpty
                          ? localization.no_videos
                          : "${playlist.videos.length} ${localization.videos}",
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: context.ternaryColor),
                    ),
                  ],
                ),

          // Playlist description
          /// Display the playlist's description if it exists
          playlistType == "likedVideos"
              ? const SizedBox()
              : playlist!.description.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        playlist.description,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: context.ternaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

          // Action buttons
          playlistType == "likedVideos"
              ? const SizedBox()
              : const ActionButtonInPlaylist(),
        ],
      ),
    );
  }
}
