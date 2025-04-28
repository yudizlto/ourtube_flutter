import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/user/presentation/widgets/setting_options.dart';
import '../../utils/helpers/navigation_helpers.dart';
import '../styles/app_text_style.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      color: context.popUpMenuColor,
      elevation: 2.0,
      icon: Icon(Icons.more_vert, color: context.secondaryColor),
      iconSize: 28.0,
      onSelected: (value) {
        if (value == "settings") {
          NavigationHelpers.navigateWithSlideTransition(
              context, const SettingOptions());
        } else if (value == "help") {
          null;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "settings",
            child: Text(localization.settings, style: AppTextStyles.bodyLarge),
          ),
          PopupMenuItem<String>(
            value: "help",
            child: Text(localization.help_and_feedback,
                style: AppTextStyles.bodyLarge),
          ),
        ];
      },
    );
  }
}
