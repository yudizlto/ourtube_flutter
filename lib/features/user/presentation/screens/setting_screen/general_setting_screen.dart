import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/custom_list_tile_button.dart';
import '../../../../../core/utils/helpers/dialog_helper.dart';
import '../../widgets/settings_app_bar.dart';
import '../../widgets/settings_app_language_option.dart';
import '../../widgets/settings_theme_option.dart';

class GeneralSettingScreen extends StatelessWidget {
  final AppLocalizations localization;

  const GeneralSettingScreen({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsAppBar(appBarTitle: localization.general),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General setting: Appearance (Theme mode)
          CustomListTileButton(
            title: localization.appearance,
            titleStyle: AppTextStyles.titleMedium.copyWith(fontSize: 18.0),
            subtitle: localization.appearance_description,
            subtitleStyle:
                AppTextStyles.bodyLarge.copyWith(color: context.ternaryColor),
            onTap: () {
              DialogHelpers.showCustomDialog(
                context: context,
                title: localization.appearance,
                content: SettingsThemeOption(localization: localization),
              );
            },
          ),

          // General setting: App language
          CustomListTileButton(
            title: localization.app_language,
            titleStyle: AppTextStyles.titleMedium.copyWith(fontSize: 18.0),
            subtitle: localization.app_language_description,
            subtitleStyle:
                AppTextStyles.bodyLarge.copyWith(color: context.ternaryColor),
            onTap: () {
              DialogHelpers.showCustomDialog(
                context: context,
                title: localization.app_language,
                content: SettingAppLanguageOption(localization: localization),
              );
            },
          ),
        ],
      ),
    );
  }
}
