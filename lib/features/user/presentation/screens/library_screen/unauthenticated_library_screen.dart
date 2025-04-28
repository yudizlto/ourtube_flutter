import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../../core/presentation/widgets/main_app_bar.dart';
import '../../widgets/sign_in_for_content.dart';
import '../setting_screen/setting_screen.dart';

class UnAuthenticatedLibraryScreen extends StatelessWidget {
  const UnAuthenticatedLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // App Bar
          MainAppBar(
            actions: [
              const NotificationIconButton(),
              const SearchIconButton(),
              CircularActionButton(
                icon: Icons.settings_outlined,
                onTap: () => NavigationHelpers.navigateToScreen(
                    context, const SettingScreen()),
              ),
            ],
          ),

          // Please Sign In For More Features
          SignInForContent(
            imagePath: AppAssets.libraryIcon,
            title: localization.unauthenticatedLibraryTitle,
            subtitle: localization.unauthenticatedLibraryContent,
          ),
        ],
      ),
    );
  }
}
