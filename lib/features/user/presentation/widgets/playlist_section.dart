import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../playlists/presentation/providers/playlist_provider.dart';
import '../../../playlists/presentation/screens/all_my_playlist_screen.dart';
import '../../../playlists/presentation/widgets/add_new_playlist_button.dart';
import '../../../playlists/presentation/widgets/liked_video_vertical_tile.dart';
import '../../../playlists/presentation/widgets/playlist_vertical_tile.dart';
import '../providers/user_provider.dart';
import 'section_with_list.dart';

class PlaylistSection extends ConsumerWidget {
  final AppLocalizations localization;

  const PlaylistSection({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentuserId = ref.watch(currentUserProvider).value!.userId;
    final playlistList = ref.watch(fetchAllMyPlaylistProvider(currentuserId));

    return SectionWithList(
      localization: localization,
      titleSection: localization.playlists,
      onViewAll: () {
        NavigationHelpers.navigateToScreen(
            context, const AllMyPlaylistScreen());
      },
      createWidget: Container(
        margin: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          onTap: () => ModalHelpers.showBottomSheetForCreatePlaylist(context),
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.add, color: context.ternaryColor, size: 30.0),
          ),
        ),
      ),

      // Horizontal list of playlists
      widgetList: playlistList.when(
        data: (data) {
          /// Display only the first 9 playlists if there are more than 9
          final displayedData = data.length > 9 ? data.sublist(0, 9) : data;

          return SizedBox(
            height: 185.0,
            child: ListView.builder(
              /// Include extra items for Liked Videos and Add New Playlist
              itemCount: displayedData.length + 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                if (index == 0) {
                  /// Tile for liked videos
                  return LikedVideoVerticalTile(
                    userId: currentuserId,
                    localization: localization,
                  );
                } else if (index == displayedData.length + 1) {
                  /// Button to create a new playlist
                  return AddNewPlaylistButton(localization: localization);
                } else {
                  //// Tile for individual playlist
                  final playlist = displayedData[index - 1];
                  return PlaylistVerticalTile(
                    index: index - 1,
                    playlist: playlist,
                    userId: currentuserId,
                    localization: localization,
                  );
                }
              },
            ),
          );
        },
        loading: () => const Loader(),
        error: (error, stackTrace) => const SizedBox(),
      ),
    );
  }
}
