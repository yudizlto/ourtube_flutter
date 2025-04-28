import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../channel/presentation/screens/my_channel/more_info_screen.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/models/video_model.dart';
import 'video_description_box.dart';
import 'video_stat_item.dart';
import 'video_tags_section.dart';

class BodySectionVideoDetailsBottomSheet extends StatelessWidget {
  final VideoModel video;
  final UserModel user;
  final AppLocalizations localization;

  const BodySectionVideoDetailsBottomSheet({
    super.key,
    required this.video,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video details: Title, Views count, Likes count, uploaded date
            _buildVideoDetailsSection(),

            // Video hastags
            /// If the video has tags, show them
            video.tags.isNotEmpty ? const VideoTagsSection() : const SizedBox(),

            // Video description
            /// If description is not empty, show description box
            video.description.isNotEmpty
                ? VideoDescriptionBox(localization: localization, video: video)
                : const SizedBox(),

            // Channel info section
            _buildChannelInfo(context),
          ],
        ),
      ),
    );
  }

  /// Build the video details section
  Widget _buildVideoDetailsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video title
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            child: Text(
              video.title,
              style: AppTextStyles.titleSmall
                  .copyWith(fontSize: 20.0, height: 1.2),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Video likes count, views count, uploaded date
          _buildVideoStatsSection(),
        ],
      ),
    );
  }

  /// Build the video stats section
  Widget _buildVideoStatsSection() {
    final formattedDate = StringHelpers.splitVideoUploadDate(video.uploadedAt);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Likes count
        VideoStatItem(
          value: video.likesCount.toString(),
          label: localization.likes_label,
        ),

        // Views count
        VideoStatItem(
          value: video.viewsCount.toString(),
          label: localization.views_label,
        ),

        // Uploaded date
        VideoStatItem(
          value: formattedDate[0],
          label: formattedDate[1],
        ),
      ],
    );
  }

  /// Build the channel info section
  Widget _buildChannelInfo(BuildContext context) {
    final formattedSubsCount =
        StringHelpers.formattedSubsCount(context, user.subscribers);

    return Material(
      color: context.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Button to show the channel
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: AppTextStyles.titleMedium
                              .copyWith(fontSize: 18.0),
                          maxLines: 3,
                        ),
                        Text(
                          formattedSubsCount,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons: show all the channel videos and about
          Container(
            margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShrinkingButton(
                  text: localization.videos_label,
                  imagePath: AppAssets.videoFrameIcon,
                  borderColor: context.ternaryColor,
                  textColor: context.secondaryColor,
                  buttonColor: context.primaryColor,
                  width: 100.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 10.0,
                  ),
                  onPressed: () {},
                ),
                ShrinkingButton(
                  text: localization.about_channel,
                  imagePath: AppAssets.aboutIcon,
                  borderColor: context.ternaryColor,
                  textColor: context.secondaryColor,
                  buttonColor: context.primaryColor,
                  width: 100.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 10.0,
                  ),
                  onPressed: () => NavigationHelpers.navigateToScreen(
                      context, MoreInfoScreen(user: user)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
