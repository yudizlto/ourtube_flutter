import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/dialog_helper.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../../video/presentation/providers/video_provider.dart';
import '../../../video/presentation/screens/long_video/edit_video_screen.dart';

class MyVideoOptionBottomSheet extends ConsumerWidget {
  final VideoModel video;
  final String? historyId;
  final ScreenType screenType;

  const MyVideoOptionBottomSheet({
    super.key,
    required this.video,
    this.historyId,
    required this.screenType,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            // Button for save the video to playlist
            CustomActionRowButton(
              title: localization.save_to_playlist,
              imagePath: AppAssets.bookmarkIcon,
              imageWidth: 24.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              onTap: () {
                Navigator.pop(context);
                ModalHelpers.showBottomSheetForAddToPlaylist(
                    context, video.videoId);
              },
            ),

            // Button for share the video
            CustomActionRowButton(
              title: localization.share_video,
              imagePath: AppAssets.shareIcon,
              imageWidth: 24.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              onTap: () {},
            ),

            // Button for report the video
            /// (only visible when screenType is "home")
            screenType == ScreenType.home
                ? CustomActionRowButton(
                    title: localization.report,
                    icon: Icons.flag_outlined,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    onTap: () {},
                  )
                : const SizedBox(),

            // Button for edit the video details
            /// Option: Edit video details (visible only when screenType is NOT "history" and NOT "home")
            (screenType == ScreenType.history || screenType == ScreenType.home)
                ? const SizedBox()
                : CustomActionRowButton(
                    title: localization.edit,
                    icon: Icons.edit_outlined,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    onTap: () {
                      Navigator.pop(context);
                      NavigationHelpers.navigateWithSlideTransition(
                          context, EditVideoScreen(video: video));
                    },
                  ),

            // Button for save the video to device
            /// Option: Save video to device (visible only when screenType is NOT "history" and NOT "home")
            (screenType == ScreenType.history || screenType == ScreenType.home)
                ? const SizedBox()
                : CustomActionRowButton(
                    title: localization.save_to_device,
                    icon: Icons.save_alt_outlined,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    onTap: () {},
                  ),

            // Button for delete
            /// The button is for delete the video
            /// If `screenType` is "history", the button is for remove the video from watch history
            screenType == ScreenType.home
                ? const SizedBox()
                : CustomActionRowButton(
                    title: screenType == ScreenType.history
                        ? localization.remove_from_watch_history
                        : localization.delete,
                    icon: Icons.delete_outline_rounded,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    onTap: screenType == ScreenType.history
                        ? () => _handleRemoveFromWatchHistory(
                            context, ref, historyId!, localization)
                        : () => _handleDeleteVideo(
                            context, ref, video, screenType, localization),
                  ),

            // Button for close the bottom sheet
            /// Visible only when screenType is NOT "history" and NOT "home"
            (screenType == ScreenType.history || screenType == ScreenType.home)
                ? const SizedBox()
                : CustomActionRowButton(
                    title: localization.cancel,
                    icon: Icons.cancel_outlined,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    onTap: () => Navigator.pop(context),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Function to handle the deletion of a video
Future<void> _handleDeleteVideo(
    BuildContext context,
    WidgetRef ref,
    VideoModel video,
    ScreenType screenType,
    AppLocalizations localization) async {
  final userIdRef = ref.watch(currentUserProvider).value!.userId;
  final deleteVideoRef = ref.watch(deleteVideoUseCaseProvider);

  /// Show a confirmation dialog before deleting the video
  /// Show success message after deleting the video
  DialogHelpers.showDialogDeleteVideo(context, () async {
    await deleteVideoRef.execute(video.videoId, userIdRef).then((_) {
      /// Show a snackbar based on which screen the delete is triggered from
      if (screenType == ScreenType.myChannel) {
        SnackbarHelpers.showCommonSnackBar(
            context, localization.upload_deleted);
      } else {
        SnackbarHelpers.showCommonSnackBar(
            context, localization.video_upload_deleted);
      }

      Navigator.pop(context, true);
    });
    if (context.mounted) Navigator.pop(context);
  });
}

/// Function to handle removing a video from watch history
Future<void> _handleRemoveFromWatchHistory(BuildContext context, WidgetRef ref,
    String historyId, AppLocalizations localization) async {
  final removeFromWatchHistoryRef = ref.read(removeFromWatchHistoryProvider);

  await removeFromWatchHistoryRef.execute(historyId).then((_) {
    Navigator.pop(context);
    SnackbarHelpers.showCommonSnackBar(
        context, localization.all_views_of_this_video_removed_from_history);
  });
}
