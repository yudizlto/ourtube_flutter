import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/custom_list_tile_button.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../widgets/settings_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: SettingsAppBar(appBarTitle: localization.settings),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomListTileButton(
            title: localization.app_version,
            titleStyle: AppTextStyles.titleMedium.copyWith(fontSize: 18.0),
            subtitle: AppStrings.appVersion,
            subtitleStyle:
                AppTextStyles.bodyLarge.copyWith(color: context.ternaryColor),
            onTap: () {},
          ),
          CustomListTileButton(
            title: localization.app_description,
            titleStyle: AppTextStyles.titleMedium.copyWith(fontSize: 18.0),
            subtitleStyle:
                AppTextStyles.bodyLarge.copyWith(color: context.ternaryColor),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
