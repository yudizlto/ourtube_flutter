import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/video/presentation/screens/long_video/upload_video_screen.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/enums/get_image_from.dart';
import '../../utils/constants/enums/video_type.dart';
import '../../utils/helpers/image_picker_helper.dart';
import '../../utils/helpers/navigation_helpers.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../styles/app_text_style.dart';
import 'drag_handle_bottom_sheet.dart';

class UploadBottomSheet extends StatelessWidget {
  const UploadBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Material(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandleBottomSheet(),

            // Button for upload long video
            InkWell(
              onTap: () async {
                try {
                  final videoFile = await ImagePickerHelpers()
                      .pickVideo(GetImageFrom.gallery);

                  if (videoFile != null) {
                    if (context.mounted) {
                      NavigationHelpers.navigateToScreen(
                        context,
                        UploadVideoScreen(
                          videoType: VideoType.long,
                          videoFile: videoFile,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    SnackbarHelpers.showSnackBarInvalidVideoSize(context);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 30.0),
                    const Expanded(
                      child: Text(
                        AppStrings.uploadVideo,
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button for upload short video
            InkWell(
              onTap: () async {
                try {
                  final videoFile = await ImagePickerHelpers()
                      .pickShorts(GetImageFrom.gallery);

                  if (videoFile != null) {
                    if (context.mounted) {
                      NavigationHelpers.navigateToScreen(
                        context,
                        UploadVideoScreen(
                          videoType: VideoType.short,
                          videoFile: videoFile,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    SnackbarHelpers.showSnackBarInvalidVideoSize(context);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppAssets.shortIcon,
                      width: 24.0,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 30.0),
                    const Expanded(
                      child: Text(
                        AppStrings.uploadShort,
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button for create a post
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Text(
                        localization.create_a_post,
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
