import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/get_image_from.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/utils/helpers/image_picker_helper.dart';
import '../../../user/data/models/user_model.dart';
import '../providers/my_channel_provider.dart';

class BannerAndPhoto extends ConsumerWidget {
  final UserModel user;
  final AppLocalizations localization;

  const BannerAndPhoto({
    super.key,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.9),
            offset: const Offset(0, 0),
          ),
        ],
        image: DecorationImage(
          image: user.bannerUrl.isEmpty
              ? const AssetImage(AppAssets.banner)
              : NetworkImage(user.bannerUrl) as ImageProvider<Object>,
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          radius: 45.0,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 43.0,
            backgroundImage: user.bannerUrl.isEmpty
                ? const AssetImage(AppAssets.banner)
                : NetworkImage(user.bannerUrl) as ImageProvider<Object>,
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.95),
                    offset: const Offset(0, 0),
                  ),
                ],
                image: DecorationImage(
                  image: user.photoUrl.isEmpty
                      ? const AssetImage(AppAssets.banner)
                      : NetworkImage(user.photoUrl) as ImageProvider<Object>,
                  opacity: 0.75,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
              ),
              child: Center(
                child: IconButton(
                  onPressed: () => handleImageUpload(context, ref),
                  icon: const Icon(Icons.photo_camera_outlined),
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Handle to pick and upload photo profile
Future<void> handleImageUpload(BuildContext context, WidgetRef ref) async {
  final pickedFile = await ImagePickerHelpers().pickImage(GetImageFrom.gallery);

  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final updatePhoto = ref.watch(updatePhotoProvider);

    await updatePhoto.call(file).then((_) => SnackbarHelpers.showCommonSnackBar(
        context, AppStrings.profilePhotoUpdated));

    if (context.mounted) Navigator.pop(context);
  }
}
