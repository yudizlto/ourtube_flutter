import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../channel/presentation/screens/my_channel/my_channel_screen.dart';
import '../../data/models/user_model.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  final AppLocalizations localization;

  const UserInfo({super.key, required this.user, required this.localization});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationHelpers.navigateToScreen(
          context, MyChannelScreen(user: user, localization: localization)),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 40.0,
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: AppTextStyles.headlineLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "@${user.username}",
                          style: AppTextStyles.titleSmall.copyWith(
                              color: context.secondaryColor,
                              overflow: TextOverflow.ellipsis),
                        ),
                        TextSpan(
                            text: "  ⦁  ${localization.view_channel}",
                            style: AppTextStyles.titleSmall
                                .copyWith(color: context.ternaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
