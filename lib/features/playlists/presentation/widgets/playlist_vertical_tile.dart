import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../data/models/playlist_model.dart';
import '../screens/playlist_screen.dart';
import 'playlist_cover.dart';

class PlaylistVerticalTile extends StatelessWidget {
  final int index;
  final PlaylistModel playlist;
  final String userId;
  final AppLocalizations localization;

  const PlaylistVerticalTile({
    super.key,
    required this.index,
    required this.playlist,
    required this.userId,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: index == 0 ? 5.0 : 0.0,
        right: index == 15 ? 18.0 : 0.0,
      ),
      child: InkWell(
        onTap: () {
          NavigationHelpers.navigateToScreen(
            context,
            PlaylistScreen(
                playlistType: "playlist", playlist: playlist, userId: userId),
          );
        },
        onLongPress: () {
          ModalHelpers.showBottomSheetForPlaylistOption(
              context, playlist, ScreenType.outsidePlaylist);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Playlist Cover
              PlaylistCover(playlist: playlist),

              const SizedBox(height: 8.0),

              // Playlist details, create new playlist and view more button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playlist details
                  SizedBox(
                    width: 140.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Playlist name
                        Text(
                          playlist.name,
                          style: AppTextStyles.bodyLarge.copyWith(height: 1.1),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Playlist visibility or creator channel
                        Row(
                          children: [
                            Flexible(
                              flex: 0,
                              child: Text(
                                playlist.isPublic
                                    ? localization.public
                                    : localization.private,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: context.ternaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "⋅ ${localization.playlist_label}",
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: context.ternaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // More button
                  MoreIconButton(
                    iconSize: 20.0,
                    padding: EdgeInsets.zero,
                    onTap: () {
                      ModalHelpers.showBottomSheetForPlaylistOption(
                          context, playlist, ScreenType.outsidePlaylist);
                    },
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
