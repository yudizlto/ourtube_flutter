import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class SignInForContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const SignInForContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Logo
        Center(
          child: Container(
            width: 130.0,
            height: 130.0,
            margin: const EdgeInsets.symmetric(vertical: 50.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.blackDark4,
              border: Border.all(color: AppColors.blackDark3),
              shape: BoxShape.circle,
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),

        // Empty Content Message
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 24.0),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 10.0),
              Text(
                subtitle,
                style: AppTextStyles.bodyLarge
                    .copyWith(color: context.ternaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),

        // Login Button
        ShrinkingButton(
          text: localization.sign,
          textColor: AppColors.white,
          buttonColor: context.activeColor,
          width: 80.0,
          onPressed: () =>
              NavigationHelpers.navigateToScreen(context, const LoginScreen()),
        ),
      ],
    );
  }
}
