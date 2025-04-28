import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/notification/presentation/screens/notification_screen.dart';
import '../../utils/helpers/navigation_helpers.dart';
import 'circular_action_button.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularActionButton(
      icon: Icons.notifications_none_rounded,
      color: context.secondaryColor,
      onTap: () => NavigationHelpers.navigateToScreen(
          context, const NotificationScreen()),
    );
  }
}
