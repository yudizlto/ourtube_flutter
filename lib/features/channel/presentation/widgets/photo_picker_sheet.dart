import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/enums/get_image_from.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/helpers/image_picker_helper.dart';
import '../../../user/data/models/user_model.dart';
import '../providers/my_channel_provider.dart';

class PhotoPickerSheet extends ConsumerWidget {
  final UserModel user;
  final AppLocalizations localization;

  const PhotoPickerSheet({
    super.key,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

            // Button for taking photo from camera
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Text(
                        localization.take_photo,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button for choosing photo from gallery
            InkWell(
              onTap: () => pickAndUploadBannerFromGallery(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.photo_library,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Text(
                        localization.choose_from_your_photos,
                        style: AppTextStyles.bodyLarge,
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

  /// Handle to pick from gallery and upload banner
  Future<void> pickAndUploadBannerFromGallery(
      BuildContext context, WidgetRef ref) async {
    final pickedFile =
        await ImagePickerHelpers().pickImage(GetImageFrom.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final updateBannerUrl = ref.watch(updateBannerProvider);

      await updateBannerUrl.call(file).then((_) =>
          SnackbarHelpers.showCommonSnackBar(
              context, localization.banner_updated));

      if (context.mounted) Navigator.pop(context);
    }
  }
}
