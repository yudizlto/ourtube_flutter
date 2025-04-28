import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../channel/presentation/screens/my_channel/my_video_screen.dart';

class UserMenuSection extends StatelessWidget {
  final AppLocalizations localization;

  const UserMenuSection({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User Actions
        CustomActionRowButton(
          icon: Icons.video_collection_outlined,
          title: localization.your_videos,
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onTap: () {
            NavigationHelpers.navigateToScreen(context, const MyVideoScreen());
          },
        ),

        Divider(thickness: 0.3, color: context.ternaryColor),

        // Support & Insights
        CustomActionRowButton(
          icon: Icons.help_outline_rounded,
          title: localization.help_and_feedback,
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onTap: () {},
        ),
      ],
    );
  }
}
