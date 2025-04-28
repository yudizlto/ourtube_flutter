import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/presentation/widgets/preview_thumbnail_video.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../../video/presentation/providers/video_provider.dart';

class MyVideoListTile extends ConsumerWidget {
  final VideoModel video;
  final ScreenType screenType;

  const MyVideoListTile({
    super.key,
    required this.video,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final formattedViewCount =
        StringHelpers.formattedViewCount(ref, video.viewsCount, localization);
    final formattedDate = StringHelpers.timeAgo(context, video.uploadedAt);

    return GestureDetector(
      onTap: () => _openVideoPlayerScreen(context, ref),
      onLongPress: () {
        ModalHelpers.showBottomSheetForMyVideosOptions(
            context, video, screenType);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail
            PreviewThumbnailVideo(video: video),

            // Video details
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video title
                    Text(
                      video.title,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Video views and upload date
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Video views
                          Text(
                            formattedViewCount,
                            style: AppTextStyles.labelLarge
                                .copyWith(color: context.ternaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Video upload date
                          Flexible(
                            child: Text(
                              "  ⦁  $formattedDate",
                              style: AppTextStyles.labelLarge
                                  .copyWith(color: context.ternaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Video visibility, likes count, comments count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          video.visibilityType == AppStrings.public
                              ? Icons.public_outlined
                              : video.visibilityType == AppStrings.unlisted
                                  ? Icons.link_outlined
                                  : Icons.lock_outline,
                          size: 20.0,
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(Icons.thumb_up_outlined, size: 20.0),
                        const SizedBox(width: 10.0),
                        Text(
                          video.likesCount.toString(),
                          style: AppTextStyles.labelLarge
                              .copyWith(color: context.ternaryColor),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(Icons.comment_outlined, size: 20.0),
                        const SizedBox(width: 10.0),
                        Text(
                          video.commentsCount.toString(),
                          style: AppTextStyles.labelLarge
                              .copyWith(color: context.ternaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // More button
            MoreIconButton(
              iconSize: 20.0,
              padding: EdgeInsets.zero,
              onTap: () {
                ModalHelpers.showBottomSheetForMyVideosOptions(
                    context, video, screenType);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Open a bottom sheet with the video player screen
  /// Execute the view count update for the video
  /// Execute adding the video to the user's history
  void _openVideoPlayerScreen(BuildContext context, WidgetRef ref) {
    final userIdRef = ref.read(currentUserProvider).value!.userId;
    final updateViewsCountRef = ref.read(updateViewsCountUseCaseProvider);
    final addToHistoryRef = ref.read(addToHistoryUseCaseProvider);
    final durationRef = ref.watch(durationWatchedProvider);

    NavigationHelpers.openBottomSheetForVideoPlayerScreen(
        context, video, ref, userIdRef, durationRef);
    updateViewsCountRef.execute(video);
    addToHistoryRef.excute(video, userIdRef);
  }
}
