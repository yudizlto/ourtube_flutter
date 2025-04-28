import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../providers/state/video_notifier.dart';
import '../providers/video_provider.dart';
import 'edit_video_description_textfield.dart';
import 'edit_video_option_tile.dart';
import 'set_audience.dart';
import 'set_comment.dart';
import 'set_visibility.dart';
import 'video_title_textfield.dart';

class CreateVideoDetails extends ConsumerWidget {
  final VideoType videoType;

  const CreateVideoDetails({super.key, required this.videoType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final videoState = ref.watch(createLongVideoNotifierProvider);
    final notifier = ref.read(createLongVideoNotifierProvider.notifier);

    final descErrorRef = ref.watch(descriptionErrorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create title section
        videoType == VideoType.long
            ? const VideoTitleTextField(screenType: ScreenType.createVideo)
            : const SizedBox(),

        // Create Body section
        Container(
          margin: const EdgeInsets.only(bottom: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add description
              videoType == VideoType.long
                  ? EditVideoOptionTile(
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
                          const EditVideoDescriptionTextFormField(
                              screenType: ScreenType.createVideo),
                        );

                        if (updatedDescription != null) {
                          notifier.createDescription(updatedDescription);

                          final error =
                              ValidationUtils.validateDescriptionCharacterCount(
                                  updatedDescription,
                                  localization.text_is_too_long);
                          ref.read(descriptionErrorProvider.notifier).state =
                              error;
                        }
                      },
                    )
                  : const SizedBox(),

              // Visibility option
              EditVideoOptionTile(
                label: localization.visibility,
                title: StringHelpers.getVisibilityStatus(
                    videoState.visibilityType, localization),
                icon: _getVisibilityIcon(videoState.visibilityType),
                onTap: () => NavigationHelpers.navigateToScreen(context,
                    const SetVisibility(screenType: ScreenType.createVideo)),
              ),

              // Select audience option
              EditVideoOptionTile(
                label: localization.select_audience,
                title: videoState.audienceRestricted
                    ? localization.yes_its_made_for_kids
                    : localization.no_its_not_made_for_kids,
                icon: Icons.people_outline_outlined,
                onTap: () => NavigationHelpers.navigateToScreen(context,
                    const SetAudience(screenType: ScreenType.createVideo)),
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
                    const SetComment(screenType: ScreenType.createVideo)),
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
      case AppStrings.unlisted:
        return Icons.link_outlined;
      case AppStrings.private:
        return Icons.lock_outline;
      default:
        return Icons.public_outlined;
    }
  }
}
