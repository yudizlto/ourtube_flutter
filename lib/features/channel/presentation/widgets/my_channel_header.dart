import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../user/data/models/user_model.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../screens/my_channel/more_info_screen.dart';
import '../screens/my_channel/my_channel_setting_screen.dart';
import '../screens/my_channel/my_video_screen.dart';

class MyChannelHeader extends StatelessWidget {
  final UserModel user;
  final AppLocalizations localization;

  const MyChannelHeader({
    super.key,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // My Channel Banner
        user.bannerUrl.isEmpty
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: 100.0,
                margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(user.bannerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

        // My Channel Info
        Container(
          margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile picture
                  InstaImageViewer(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 40.0,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Channel name
                        Text(
                          user.displayName,
                          style:
                              AppTextStyles.titleLarge.copyWith(fontSize: 24.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),

                        // Channel username
                        Text(
                          "@${user.username}",
                          style: AppTextStyles.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Channel subscribers
                            Flexible(
                              child: Text(
                                localization.channelSubscribers(
                                    user.subscriptions.length),
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: context.ternaryColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Channel videos count
                            Text(
                              " ⦁ ${user.videos.length} ${localization.videos}",
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: context.ternaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Channel description
              GestureDetector(
                onTap: () => NavigationHelpers.navigateToScreen(
                    context, MoreInfoScreen(user: user)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        user.description.isEmpty
                            ? localization.more_about_channel
                            : user.description,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: context.ternaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "...${localization.more}",
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Manage video & edit button
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ShrinkingButton(
                  text: localization.manage_videos,
                  textColor: context.secondaryColor,
                  buttonColor: context.buttonColor,
                  onPressed: () => NavigationHelpers.navigateToScreen(
                      context, const MyVideoScreen()),
                ),
              ),
              const SizedBox(width: 10.0),
              ShrinkingButton(
                icon: Icons.edit_outlined,
                buttonColor: context.buttonColor,
                onPressed: () {
                  NavigationHelpers.navigateToScreen(context,
                      MyChannelSettingScreen(localization: localization));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
