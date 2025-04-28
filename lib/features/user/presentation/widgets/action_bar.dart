import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import 'setting_options.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const NotificationIconButton(),
          const SearchIconButton(),
          CircularActionButton(
            icon: Icons.settings_outlined,
            color: context.secondaryColor,
            onTap: () {
              NavigationHelpers.navigateWithSlideTransition(
                  context, const SettingOptions());
            },
          ),
        ],
      ),
    );
  }
}
