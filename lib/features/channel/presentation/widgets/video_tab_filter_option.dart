import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../providers/my_channel_provider.dart';

class VideoTabFilterOptions extends StatelessWidget {
  const VideoTabFilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Buttons for sorting videos by latest or oldest
            GestureDetector(
              onTap: () => ModalHelpers.showBottomSheetForSortingVideo(context),
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: context.buttonColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final sortByRef = ref.read(videoSortByProvider);
                        return Text(
                          sortByRef ? localization.latest : localization.oldest,
                          style: AppTextStyles.titleMedium,
                        );
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Image.asset(
                      AppAssets.downArrowIcon,
                      width: 20.0,
                      color: context.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),

            // Buttons for sorting videos by visibility type "Public"
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: context.buttonColor,
                ),
                child: Text(
                  localization.public,
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ),

            // Buttons for sorting videos by visibility type "Private"
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: context.buttonColor,
                ),
                child: Text(
                  localization.private,
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
