import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/tile_checkbox.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../playlists/presentation/providers/playlist_provider.dart';
import '../../../playlists/presentation/providers/state/playlist_notifier.dart';
import '../../../user/presentation/providers/user_provider.dart';

class AddVideoToPlaylistBottomSheet extends ConsumerWidget {
  final String videoId;

  const AddVideoToPlaylistBottomSheet({super.key, required this.videoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.read(currentUserProvider).value!.userId;

    final localization = AppLocalizations.of(context)!;

    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            // Save video to playlist title section & button create playlist
            _buildHeaderSection(context, localization),

            // Playlists checkbox
            _buildPlaylistsCheckbox(localization, ref, currentUserId, videoId),

            // Done button
            _buildDoneButton(context, localization, ref, videoId),
          ],
        ),
      ),
    );
  }
}

/// Builds the header section with a title and a button to create a new playlist
Widget _buildHeaderSection(
    BuildContext context, AppLocalizations localization) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: context.ternaryColor, width: 1.5),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localization.save_video_to,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
        ),

        // Button create new playlist
        InkWell(
          onTap: () {
            Navigator.pop(context);
            ModalHelpers.showBottomSheetForCreatePlaylist(context);
          },
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.add, color: context.activeColor, size: 24.0),
                const SizedBox(width: 8.0),
                Text(
                  localization.new_playlist,
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: context.activeColor),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// Builds the section displaying the list of playlists as checkboxes
///
/// - [ref]: A reference to the provider
/// - [userId]: The current user's ID
/// - [videoId]: The ID of the video to be added to playlists
Widget _buildPlaylistsCheckbox(AppLocalizations localization, WidgetRef ref,
    String userId, String videoId) {
  final playlists = ref.watch(fetchAllMyPlaylistProvider(userId));

  return playlists.when(
    data: (data) {
      /// If there are no playlists available, display a message to the user
      return data.isEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: Text(
                localization.you_dont_have_any_playlists,
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              ),
            )
          : Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (_, index) {
                  final playlist = data[index];
                  final playlistId = playlist.playlistId;

                  final isVideoInPlaylist = ref
                      .read(playlistRepositoryProvider)
                      .isVideoInPlaylist(playlistId, videoId);

                  /// If you have any playlists show this
                  /// And check if the video is in the playlist
                  return StreamBuilder(
                    stream: isVideoInPlaylist,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Loader();
                      }
                      if (snapshot.hasData) {
                        final isChecked = snapshot.data!;
                        return TileCheckbox(
                          title: playlist.name,
                          isChecked: isChecked,
                          icon: playlist.isPublic
                              ? Icons.public_outlined
                              : Icons.lock_outlined,
                          onChanged: (value) {
                            /// Update playlist selection state when the checkbox is toggled
                            /// If the checkbox is checked, add the playlist to the selectedPlaylists list
                            /// If the checkbox is unchecked, remove the playlist from the selectedPlaylists list
                            final notifier =
                                ref.read(playlistNotifier.notifier);
                            value
                                ? notifier.toggleSelected(playlistId)
                                : notifier.toggleUnselected(playlistId);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            );
    },
    loading: () => const Loader(),
    error: (error, stackTrace) => const SizedBox(),
  );
}

/// Builds the "Done" button for saving the selected playlists
///
/// - [context]: The build context for navigation and snackbar
/// - [ref]: A reference to the provider
/// - [videoId]: The ID of the video to be added to playlists
Widget _buildDoneButton(BuildContext context, AppLocalizations localization,
    WidgetRef ref, String videoId) {
  return InkWell(
    onTap: () {
      /// Handle playlist updates and reset states
      /// Close the bottom sheet
      /// And show a success snackbar
      _doneOnTap(ref, videoId);
      Navigator.pop(context);
      SnackbarHelpers.showCommonSnackBar(
          context, localization.video_added_to_playlist);
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.ternaryColor, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.check, color: context.secondaryColor, size: 24.0),
          const SizedBox(width: 12.0),
          Text(
            localization.done,
            style: AppTextStyles.bodyLarge,
          )
        ],
      ),
    ),
  );
}

/// Handles the logic for updating playlists when the "Done" button is tapped
void _doneOnTap(WidgetRef ref, String videoId) {
  final playlistState = ref.watch(playlistNotifier);
  final notifier = ref.watch(playlistNotifier.notifier);
  final addToPlaylist = ref.read(addVideoToPlaylistProvider);
  final removeFromPlaylist = ref.read(removeVideoFromPlaylistProvider);

  /// Loop through selected playlists and add the video to each
  for (var playlistId in playlistState.selectedPlaylists) {
    addToPlaylist.execute(playlistId, videoId);
  }

  /// Loop through unselected playlists and remove the video from each
  for (var playlistId in playlistState.unSelectedPlaylists) {
    removeFromPlaylist.execute(playlistId, videoId);
  }

  /// Reset the states
  notifier.reset();
}
