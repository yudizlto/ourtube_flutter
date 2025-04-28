import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/video_model.dart';
import '../providers/like_provider.dart';

class VideoActionButton extends ConsumerWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const VideoActionButton({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.read(currentUserProvider).value!;
    final addLike = ref.read(addLikeVideoProvider);
    final unLike = ref.read(unLikeVideoProvider);
    final isLiked = ref.watch(likeStatusStreamProvider(video.videoId));

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Like & dislike button
            isLiked.when(
              data: (data) => Container(
                margin: const EdgeInsets.only(right: 7.0),
                decoration: BoxDecoration(
                  color: context.secondarySurfaceColor,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Like button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          data
                              ? unLike.execute(video, userRef)
                              : addLike.execute(video, userRef);
                        },
                        borderRadius: BorderRadius.circular(30.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                data
                                    ? AppAssets.likeFilledIcon
                                    : AppAssets.likeIcon,
                                width: 18.0,
                                color: context.secondaryColor,
                              ),
                              const SizedBox(width: 8.0),
                              video.likesCount == 0
                                  ? const SizedBox()
                                  : Text(
                                      video.likesCount.toString(),
                                      style: AppTextStyles.bodyMedium,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Vertical Divider
                    Container(
                      height: 20.0,
                      width: 1.0,
                      color: context.ternaryColor,
                    ),

                    // Dislike button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: Image.asset(
                            AppAssets.dislikeIcon,
                            width: 18.0,
                            color: context.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Loader(),
              error: (error, stackTrace) => const SizedBox(),
            ),

            // Share button
            ShrinkingButton(
              text: localization.share,
              textColor: context.secondaryColor,
              buttonColor: context.secondarySurfaceColor,
              imagePath: AppAssets.shareIcon,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),

            // Download button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Material(
                color: context.secondarySurfaceColor,
                borderRadius: BorderRadius.circular(30.0),
                child: InkWell(
                  onTap: () {},
                  splashColor: AppColors.blackDark4,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.downloadIcon,
                          width: 18.0,
                          color: context.secondaryColor,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          localization.download_offline,
                          style: AppTextStyles.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Save button
            ShrinkingButton(
              text: localization.save,
              textColor: context.secondaryColor,
              buttonColor: context.secondarySurfaceColor,
              imagePath: AppAssets.bookmarkIcon,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),

            // Report button
            ShrinkingButton(
              text: localization.report,
              textColor: context.secondaryColor,
              buttonColor: context.secondarySurfaceColor,
              imagePath: AppAssets.flagIcon,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
