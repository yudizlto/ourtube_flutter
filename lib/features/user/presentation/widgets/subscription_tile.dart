import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../channel/presentation/screens/user_channel/users_channel_screen.dart';
import '../../data/models/user_model.dart';

class SubscriptionTile extends StatelessWidget {
  final UserModel user;

  const SubscriptionTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationHelpers.navigateToScreen(
            context, UsersChannelScreen(user: user));
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Text(
                user.displayName,
                style: AppTextStyles.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(context.buttonColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    color: context.secondaryColor,
                    size: 24.0,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: context.secondaryColor,
                    size: 24.0,
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
