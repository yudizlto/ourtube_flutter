import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../screens/setting_screen/about_screen.dart';
import '../screens/setting_screen/general_setting_screen.dart';
import 'settings_app_bar.dart';

class SettingOptions extends ConsumerWidget {
  const SettingOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: SettingsAppBar(appBarTitle: localization.settings),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: context.ternaryColor, width: 1.3),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      localization.account,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                    ),
                  ),

                  // General section button
                  CustomActionRowButton(
                    icon: Icons.settings_outlined,
                    title: localization.general,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onTap: () {
                      NavigationHelpers.navigateToScreen(
                        context,
                        GeneralSettingScreen(localization: localization),
                      );
                    },
                  ),

                  // Switch account section button
                  FutureBuilder<bool>(
                    future: SharedPreferencesHelper.getAuthenticationStatus(),
                    builder: (contex, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }

                      final bool isAuthenticated = snapshot.data ?? false;
                      return isAuthenticated
                          ? CustomActionRowButton(
                              icon: Icons.switch_account_outlined,
                              title: localization.switchAccount,
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              onTap: () {},
                            )
                          : const SizedBox();
                    },
                  ),

                  // Notification section button
                  CustomActionRowButton(
                    icon: Icons.notifications_none_rounded,
                    title: localization.notifications,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Help And Policy Section
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: context.ternaryColor, width: 1.3),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      localization.help_and_policy,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                    ),
                  ),

                  // Help section button
                  CustomActionRowButton(
                    icon: Icons.help_outline_rounded,
                    title: localization.help,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onTap: () {},
                  ),

                  // Send feedback section button
                  CustomActionRowButton(
                    icon: Icons.feedback_outlined,
                    title: localization.send_feedback,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onTap: () {},
                  ),

                  // About section button
                  CustomActionRowButton(
                    icon: Icons.info_outline_rounded,
                    title: localization.about,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onTap: () => NavigationHelpers.navigateToScreen(
                        context, const AboutScreen()),
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
