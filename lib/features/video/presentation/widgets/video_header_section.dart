import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';
import 'video_details_bottom_sheet.dart';

class VideoHeaderSection extends ConsumerWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const VideoHeaderSection({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRef = ref.watch(currentUserProvider);
    final userDataRef = ref.watch(getUserDetailsProvider(video.videoId));

    final formattedDate = StringHelpers.timeAgo(context, video.uploadedAt);
    final formattedViewCount =
        StringHelpers.formattedViewCount(ref, video.viewsCount, localization);

    return userDataRef.when(
      data: (userData) {
        final formattedSubsCount = StringHelpers.formattedSubsCount(
            context, userDataRef.value!.subscribers);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video details: Title, Views count, Uploaded at
            InkWell(
              onTap: () {
                ModalHelpers.showFractionalSheet(
                    context,
                    VideoDetailsBottomSheet(
                      video: video,
                      user: userData!,
                      localization: localization,
                    ));
              },
              highlightColor: AppColors.blackDark4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video title
                    Text(
                      video.title,
                      style: AppTextStyles.titleLarge
                          .copyWith(fontSize: 20.0, height: 1.1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10.0),

                    // Video views count & uploaded at
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          formattedViewCount,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: context.ternaryColor, fontSize: 13.0),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          formattedDate,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: context.ternaryColor, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Channel info and subscribe button
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Channel's name & subscribers count
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(userData!.photoUrl),
                          ),
                          const SizedBox(width: 10.0),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                userData.displayName,
                                style: AppTextStyles.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            formattedSubsCount,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: context.ternaryColor),
                          ),
                        ],
                      ),
                    ),

                    // Subscribe button
                    // If the video is uploaded by the current user, hide the subscribe button
                    currentUserRef.value!.userId == userData.userId
                        ? const SizedBox()
                        : ShrinkingButton(
                            text: localization.subscribe_button,
                            textColor: context.primaryColor,
                            buttonColor: context.secondaryColor,
                            onPressed: () {},
                          ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Loader(),
      error: (error, stack) =>
          const Center(child: Text("Unable to load content at the moment")),
    );
  }
}
