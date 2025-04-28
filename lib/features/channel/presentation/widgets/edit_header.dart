import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../user/presentation/providers/user_provider.dart';
import 'banner_and_photo.dart';

class EditHeader extends ConsumerWidget {
  final AppLocalizations localization;

  const EditHeader({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRef = ref.watch(currentUserProvider);

    return GestureDetector(
      onTap: () {
        ModalHelpers.showBottomSheetForEditBanner(
            context, currentUserRef.value!, localization);
      },
      child: Stack(
        children: [
          // Camera button at the center for changing the photo profile
          Consumer(
            builder: (context, ref, child) {
              return currentUserRef.when(
                data: (currentUser) => BannerAndPhoto(
                  user: currentUser,
                  localization: localization,
                ),
                error: (error, stackTrace) => const SizedBox(),
                loading: () => const Loader(),
              );
            },
          ),

          // Camera button at the top right for changing the banner
          Positioned(
            right: 10.0,
            top: 10.0,
            child: IconButton(
              onPressed: () {
                ModalHelpers.showBottomSheetForEditBanner(
                    context, currentUserRef.value!, localization);
              },
              icon: const Icon(Icons.photo_camera_outlined),
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
