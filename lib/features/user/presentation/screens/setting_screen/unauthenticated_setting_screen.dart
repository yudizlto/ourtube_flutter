import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../auth/presentation/screens/login_screen.dart';
import '../../widgets/setting_options.dart';

class UnAuthenticatedSettingScreen extends StatelessWidget {
  const UnAuthenticatedSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Close Button
            Container(
              margin: const EdgeInsets.only(left: 10.0, top: 15.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.cancel_outlined, size: 50),
                ),
              ),
            ),

            // Icon Illustration
            Center(child: Image.asset(AppAssets.loginIcon, width: 200.0)),

            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50.0, bottom: 24.0),
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.doMoreWithOurTube,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      AppStrings.signInToUploadSaveAndComment,
                      style: AppTextStyles.bodyLarge.copyWith(height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Login Button
            Center(
              child: ShrinkingButton(
                text: AppStrings.signIn,
                textColor: AppColors.white,
                buttonColor: AppColors.blue,
                width: 100.0,
                onPressed: () => NavigationHelpers.navigateToScreen(
                    context, const LoginScreen()),
              ),
            ),

            const SizedBox(height: 18.0),
            const Divider(),

            // Setting Button
            CustomActionRowButton(
              icon: Icons.settings_outlined,
              title: AppStrings.settings,
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
              onTap: () => NavigationHelpers.navigateWithSlideTransition(
                  context, const SettingOptions()),
            ),

            // Help Button
            CustomActionRowButton(
              icon: Icons.help_outline_rounded,
              title: AppStrings.help,
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
              onTap: () {},
            ),

            const Divider(),
            const SizedBox(height: 18.0),
          ],
        ),
      ),
    );
  }
}
