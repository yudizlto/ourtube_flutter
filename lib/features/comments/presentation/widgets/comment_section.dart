import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../video/data/models/video_model.dart';
import '../screens/comment_screen.dart';
import 'public_comment_section.dart';

class CommentSection extends ConsumerWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const CommentSection({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 30.0),
      child: Material(
        color: context.secondarySurfaceColor,
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          onTap: () {
            ModalHelpers.showFractionalSheet(context,
                CommentScreen(video: video, localization: localization));
          },
          borderRadius: BorderRadius.circular(15.0),
          splashColor: AppColors.blackDark2,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      localization.comments,
                      style: AppTextStyles.titleSmall.copyWith(fontSize: 16.0),
                    ),
                    const SizedBox(width: 8.0),
                    video.commentsCount == 0
                        ? const SizedBox()
                        : Text(
                            "${video.commentsCount}",
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: context.ternaryColor),
                          ),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Show comments section based on video visibility type
                video.visibilityType == "Private"
                    ? _buildPrivateCommentSection()
                    : PublicCommentSection(localization: localization),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget to display when the video is private and comments are not supported
  Widget _buildPrivateCommentSection() {
    return Text(
      localization.comments_not_supported_on_private,
      style: AppTextStyles.bodyLarge,
    );
  }
}
