import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/presentation/widgets/shorts_thumbnail_preview.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/string_helper.dart';

class ChannelShortsGrid extends StatelessWidget {
  final AppLocalizations localization;
  final WidgetRef ref;
  final List shortsList;
  final VoidCallback onTap;

  const ChannelShortsGrid({
    super.key,
    required this.localization,
    required this.ref,
    required this.shortsList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 9.0 / 16.0,
        ),
        itemCount: shortsList.length,
        itemBuilder: (context, index) {
          final data = shortsList[index];

          final formattedViewCount = StringHelpers.formattedViewCount(
              ref, data.viewsCount, localization);

          return GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                // Shorts video or the thumbnail
                ShortsThumbnailPreview(videoUrl: data.videoUrl),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),

                // Visibility icon
                data.visibilityType == AppStrings.private
                    ? Positioned(
                        left: 10.0,
                        top: 10.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.white,
                                size: 15.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                localization.private,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),

                // More button
                Positioned(
                  right: 10.0,
                  top: 10.0,
                  child: Material(
                    color: Colors.transparent,
                    child: MoreIconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20.0,
                      onTap: () {},
                    ),
                  ),
                ),

                // Shorts' views count
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                  child: Text(
                    formattedViewCount,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
