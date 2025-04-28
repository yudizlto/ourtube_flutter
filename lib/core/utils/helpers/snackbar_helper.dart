import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/channel/presentation/screens/my_channel/my_video_screen.dart';
import '../../presentation/styles/app_text_style.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/video_constants.dart';
import 'clipboard_helper.dart';
import 'navigation_helpers.dart';

class SnackbarHelpers {
  static void showSnackBarWithClipboardCopy(BuildContext context, String text) {
    final localization = AppLocalizations.of(context)!;

    ClipboardHelpers.copyText(text).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.secondaryColor,
          content: Text(
            localization.copied,
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ),
    );
  }

  static void showCommonSnackBar(BuildContext context, String message,
      {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.secondaryColor,
        content: Text(
          message,
          style: AppTextStyles.bodyLarge,
        ),
        action: action,
      ),
    );
  }

  static void showSnackBarSuccessUploadVideo(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.secondaryColor,
        content: Text(
          localization.video_uploaded_to_your_videos,
          style: AppTextStyles.bodyLarge,
        ),
        action: SnackBarAction(
          label: localization.see_video,
          textColor: context.activeColor,
          onPressed: () => NavigationHelpers.navigateToScreen(
              context, const MyVideoScreen()),
        ),
      ),
    );
  }

  static void showSnackBarLoginFailed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: const Text(
        AppStrings.youreNotRegisteredYet,
        style: TextStyle(color: AppColors.black),
      ),
      backgroundColor: AppColors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
    ));
  }

  static void showSnackBarInvalidVideoSize(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    const vidMaxSize = VideoConstants.longVidMaxSize;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 10,
          right: 10,
        ),
        backgroundColor: context.secondaryColor,
        behavior: SnackBarBehavior.floating,
        content: Text(
          localization.video_size_error(vidMaxSize),
          style: AppTextStyles.bodyLarge,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0.0,
      ),
    );
  }

  static void showGlassySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.9),
            border: Border.all(color: AppColors.blackDark3),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackDark2.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.black),
          ),
        ),
      ),
    ));
  }
}
