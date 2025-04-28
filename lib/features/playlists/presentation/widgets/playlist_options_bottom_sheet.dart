import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/dialog_helper.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../../video/presentation/providers/like_provider.dart';
import '../../data/models/playlist_model.dart';
import '../providers/playlist_provider.dart';

/// A bottom sheet widget that displays playlist options
/// This widget dynamically builds action buttons based on the `screenType`
class PlaylistOptionsBottomSheet extends ConsumerWidget {
  final PlaylistModel? playlist;
  final ScreenType? screenType;
  final VideoModel? video;

  const PlaylistOptionsBottomSheet({
    super.key,
    this.playlist,
    this.screenType,
    this.video,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

            // Generates and displays action buttons based on the screen type
            ..._buildActionButtons(context, localization, ref),
          ],
        ),
      ),
    );
  }

  /// Generate action buttons based on screenType
  List<Widget> _buildActionButtons(
      BuildContext context, AppLocalizations localization, WidgetRef ref) {
    switch (screenType) {
      /// Action buttons for the "outsidePlaylist" screen type
      case ScreenType.outsidePlaylist:
        return [
          CustomActionRowButton(
            icon: Icons.delete,
            title: localization.delete,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            onTap: () {
              DialogHelpers.showDialogDeletePlaylist(
                context,
                () {
                  _handleDeletePlaylist(
                      context, localization, ref, playlist!.playlistId);
                },
              );
            },
          ),
          CustomActionRowButton(
            icon: Icons.edit,
            title: localization.edit,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            onTap: () {},
          ),
        ];

      /// Action buttons for the "likedPlaylist" screen type
      case ScreenType.likedPlaylist:
        return [
          _shareButton(localization.share),
          CustomActionRowButton(
            title: "${localization.remove_from} ${localization.liked_videos}",
            icon: Icons.not_interested_outlined,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            onTap: () {
              _handleUnLikeVideo(context, localization, ref, video!);
            },
          ),
        ];

      /// Default action buttons for other screen types
      default:
        return [
          CustomActionRowButton(
            title: "${localization.remove_from} ${playlist!.name}",
            maxLines: 1,
            icon: Icons.not_interested_outlined,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            onTap: () {
              _handleRemoveVideoFromPlaylist(context, localization, ref,
                  playlist!.playlistId, video!.videoId);
            },
          ),
          _shareButton(localization.share),
        ];
    }
  }

  /// Returns a reusable share button widget
  Widget _shareButton(String title) {
    return CustomActionRowButton(
      title: title,
      imagePath: AppAssets.shareIcon,
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      onTap: () {},
    );
  }

  /// Function to handle playlist deletion
  /// - `playlistId`: The ID of the playlist to be deleted
  Future<void> _handleDeletePlaylist(BuildContext context,
      AppLocalizations localization, WidgetRef ref, String playlistId) async {
    final userIdRef = ref.read(currentUserProvider).value!.userId;
    final deletePlaylist = ref.read(deletePlaylistProvider);

    await deletePlaylist.execute(playlistId, userIdRef).then((_) {
      Navigator.pop(context);
      SnackbarHelpers.showGlassySnackBar(
          context, localization.playlist_deleted);
      Navigator.pop(context);
    });
  }

  /// Handles removing a video from a specific playlist
  /// - `playlistId`: The ID of the playlist
  /// - `videoId`: The ID of the video to be removed
  Future<void> _handleRemoveVideoFromPlaylist(
      BuildContext context,
      AppLocalizations localization,
      WidgetRef ref,
      String playlistId,
      String videoId) async {
    final removeVideo = ref.read(removeVideoFromPlaylistProvider);
    await removeVideo.execute(playlistId, videoId).then((_) {
      Navigator.pop(context);
      SnackbarHelpers.showCommonSnackBar(
          context, "${localization.removed_from} ${playlist!.name}");
    });
  }

  /// Handles unliking a video from the liked videos playlist
  /// - `video`: The video to be unliked
  Future<void> _handleUnLikeVideo(BuildContext context,
      AppLocalizations localization, WidgetRef ref, VideoModel video) async {
    final currentUserRef = ref.watch(currentUserProvider).value;
    final unLike = ref.read(unLikeVideoProvider);

    await unLike.execute(video, currentUserRef!).then((value) {
      Navigator.pop(context);
      SnackbarHelpers.showCommonSnackBar(
          context, "${localization.removed_from} ${localization.liked_videos}");
    });
  }
}
