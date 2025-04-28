import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';
import '../providers/video_provider.dart';
import 'edit_video_description_textfield.dart';
import 'edit_video_option_tile.dart';
import 'set_audience.dart';
import 'set_comment.dart';
import 'set_visibility.dart';
import 'video_title_textfield.dart';

class EditVideoDetails extends ConsumerWidget {
  final VideoModel video;

  const EditVideoDetails({super.key, required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final videoState = ref.watch(editVideoNotifierProvider(video));
    final videoNotifier = ref.read(editVideoNotifierProvider(video).notifier);

    final descErrorRef = ref.watch(descriptionErrorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create title section
        video.type == AppStrings.long
            ? VideoTitleTextField(
                screenType: ScreenType.editVideo, video: video)
            : const SizedBox(),

        // Create Body section
        Container(
          margin: const EdgeInsets.only(bottom: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add description
              EditVideoOptionTile(
                title: videoState.description.isEmpty
                    ? localization.add_description
                    : videoState.description,
                label: videoState.description.isEmpty
                    ? null
                    : localization.description,
                icon: Icons.view_headline_sharp,
                errorMessage: descErrorRef,
                onTap: () async {
                  final updatedDescription =
                      await NavigationHelpers.navigateToScreen(
                    context,
                    EditVideoDescriptionTextFormField(
                      screenType: ScreenType.editVideo,
                      video: video,
                    ),
                  );

                  if (updatedDescription != null) {
                    videoNotifier.updateDescription(updatedDescription);

                    final error =
                        ValidationUtils.validateDescriptionCharacterCount(
                            updatedDescription,
                            localization.use_shorter_description);
                    ref.read(descriptionErrorProvider.notifier).state = error;
                  }
                },
              ),

              // Visibility option
              EditVideoOptionTile(
                label: localization.visibility,
                title: StringHelpers.getVisibilityStatus(
                    videoState.visibilityType, localization),
                icon: _getVisibilityIcon(videoState.visibilityType),
                onTap: () => NavigationHelpers.navigateToScreen(
                    context,
                    SetVisibility(
                        screenType: ScreenType.editVideo, video: video)),
              ),

              // Select audience and age restrictions option
              EditVideoOptionTile(
                label: localization.select_audience,
                title: videoState.audienceRestricted
                    ? localization.yes_its_made_for_kids
                    : localization.no_its_not_made_for_kids,
                icon: Icons.people_outline_outlined,
                onTap: () => NavigationHelpers.navigateToScreen(
                    context,
                    SetAudience(
                        screenType: ScreenType.editVideo, video: video)),
              ),

              // Add to playlist option
              EditVideoOptionTile(
                title: localization.add_to_playlist,
                icon: Icons.playlist_add,
                chevronRight: false,
                onTap: () {},
              ),

              // Comments option
              EditVideoOptionTile(
                label: localization.comments,
                title: videoState.commentsEnabled
                    ? localization.on
                    : localization.off,
                icon: Icons.comment_outlined,
                onTap: () => NavigationHelpers.navigateToScreen(context,
                    SetComment(screenType: ScreenType.editVideo, video: video)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Function to get the icon based on the visibility
  IconData _getVisibilityIcon(String visibility) {
    switch (visibility) {
      case "Unlisted":
        return Icons.link_outlined;
      case "Private":
        return Icons.lock_outline;
      default:
        return Icons.public_outlined;
    }
  }
}
