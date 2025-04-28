import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/channel/presentation/widgets/custom_modal_bottom_sheet.dart';
import '../../../features/channel/presentation/widgets/my_video_option_bottom_sheet.dart';
import '../../../features/channel/presentation/widgets/photo_picker_sheet.dart';
import '../../../features/channel/presentation/widgets/sorting_video_option_bottom_sheet.dart';
import '../../../features/comments/presentation/widgets/comment_option_bottom_sheet.dart';
import '../../../features/playlists/data/models/playlist_model.dart';
import '../../../features/playlists/presentation/widgets/create_playlist_modal.dart';
import '../../../features/playlists/presentation/widgets/playlist_options_bottom_sheet.dart';
import '../../../features/playlists/presentation/widgets/set_visibility_playlist.dart';
import '../../../features/user/data/models/user_model.dart';
import '../../../features/user/presentation/widgets/sorting_my_subs_bottom_sheet.dart';
import '../../../features/video/data/models/video_model.dart';
import '../../../features/video/presentation/widgets/add_video_to_playlist_bottom_sheet.dart';
import '../../presentation/widgets/notification_bottom_sheet.dart';
import '../../presentation/widgets/upload_bottom_sheet.dart';
import '../constants/app_strings.dart';
import '../constants/enums/screen_type.dart';
import 'validators.dart';

class ModalHelpers {
  static void _showCustomModal({
    required BuildContext context,
    required Widget child,
  }) {
    showModalBottomSheet(
      elevation: 0.0,
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: context.surfaceColor),
          child: child,
        );
      },
    );
  }

  static void showBottomSheetForEditBanner(
      BuildContext context, UserModel user, AppLocalizations localization) {
    _showCustomModal(
      context: context,
      child: PhotoPickerSheet(user: user, localization: localization),
    );
  }

  static void showBottomSheetForEditName(AppLocalizations localization,
      BuildContext context, String currentDisplayName) {
    _showCustomModal(
      context: context,
      child: CustomModalBottomSheet(
        localization: localization,
        label: localization.name,
        message: localization.name_changes_visible_warning,
        otherMessage: localization.name_changes_warning,
        field: "displayName",
        type: "displayName",
        snackbarMessage: localization.name_changed,
        initialValue: currentDisplayName,
        validator: (value) => ValidationUtils.validateEditDisplayName(
          value,
          localization.enter_name_validation,
          localization.choose_shorter_name,
        ),
      ),
    );
  }

  static void showBottomSheetForEditUsername(AppLocalizations localization,
      BuildContext context, String currentUsername) {
    _showCustomModal(
      context: context,
      child: CustomModalBottomSheet(
        localization: localization,
        label: localization.handle,
        message: localization.handle_changes_visible_warning,
        otherMessage: localization.handle_changes_warning,
        field: AppStrings.username,
        type: AppStrings.username,
        snackbarMessage: localization.handle_changed,
        initialValue: currentUsername,
        validator: (value) => ValidationUtils.validateEditHandle(
            value,
            localization.add_handle_validation,
            localization.choose_longer_handle,
            localization.handle_unsupported_characters,
            localization.handel_cannot_end_with_dot),
      ),
    );
  }

  static void showBottomSheetForUpload(BuildContext context) {
    _showCustomModal(
      context: context,
      child: const UploadBottomSheet(),
    );
  }

  static void showBottomSheetForCommentOption(BuildContext context) {
    _showCustomModal(
      context: context,
      child: const CommentOptionBottomSheet(),
    );
  }

  static void showBottomSheetForMyVideosOptions(
      BuildContext context, VideoModel video, ScreenType screenType,
      {String? historyId}) {
    _showCustomModal(
      context: context,
      child: MyVideoOptionBottomSheet(
        video: video,
        screenType: screenType,
        historyId: historyId,
      ),
    );
  }

  static void showBottomSheetForNotification(BuildContext context) {
    _showCustomModal(context: context, child: const NotificationBottomSheet());
  }

  static void showBottomSheetForAddToPlaylist(
      BuildContext context, String videoId) {
    _showCustomModal(
      context: context,
      child: AddVideoToPlaylistBottomSheet(videoId: videoId),
    );
  }

  static void showBottomSheetForSortingVideo(BuildContext context) {
    _showCustomModal(
      context: context,
      child: const SortingVideoOptionBottomSheet(),
    );
  }

  static void showBottomSheetForSortingSubs(BuildContext context) {
    _showCustomModal(
      context: context,
      child: const SortingMySubsBottomSheet(),
    );
  }

  static void showFractionalSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.67,
          child: Container(
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  static void showBottomSheetForCreatePlaylist(BuildContext context) {
    _showCustomModal(context: context, child: const CreatePlaylistModal());
  }

  static void showBottomSheetForPlaylistVisibility(BuildContext context) {
    _showCustomModal(context: context, child: const SetVisibilityPlaylist());
  }

  static void showBottomSheetForPlaylistOption(
      BuildContext context, PlaylistModel? playlist, ScreenType? screenType,
      {VideoModel? video}) {
    _showCustomModal(
      context: context,
      child: PlaylistOptionsBottomSheet(
        playlist: playlist,
        screenType: screenType,
        video: video,
      ),
    );
  }
}
