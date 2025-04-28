import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../providers/playlist_provider.dart';
import '../screens/playlist_screen.dart';
import 'empty_playlist_cover.dart';
import 'liked_video_cover.dart';

class LikedVideoVerticalTile extends ConsumerWidget {
  final String userId;
  final AppLocalizations localization;

  const LikedVideoVerticalTile({
    super.key,
    required this.userId,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(fetchMyLikesProvider(userId));

    return Container(
      margin: const EdgeInsets.only(left: 18.0),
      child: InkWell(
        onTap: () {
          NavigationHelpers.navigateToScreen(context,
              PlaylistScreen(playlistType: "likedVideos", userId: userId));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Like Playlist Cover
              /// Based on the latest liked video
              likes.when(
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
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.liked_videos,
                          style: AppTextStyles.bodyLarge.copyWith(height: 1.1),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          localization.private,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
