import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Channel avatar
            const CircleAvatar(
              radius: 18.0,
            ),
            const SizedBox(width: 15.0),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbcccccccccccccccdddddddddddddddd",
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.1),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "33 minutes ago",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: context.ternaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),

            // Video thumbnail
            Container(
              width: 115.0,
              height: 65.0,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.imagePlaceholder),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // More button
            MoreIconButton(
              iconSize: 24.0,
              padding: EdgeInsets.zero,
              onTap: () {
                ModalHelpers.showBottomSheetForNotification(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
