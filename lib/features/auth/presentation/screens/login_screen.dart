import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/auth_providers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_icon_button.dart';
import '../widgets/logo_section.dart';
import 'sign_up_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // OurTube Logo
              LogoSection(title: localization.login_to_ourtube),

              // Login With Google Button
              CustomIconButton(
                title: localization.continue_with_google,
                iconPath: AppAssets.googleIcon,
                onTap: () => _handleGoogleSignIn(context, ref),
              ),

              // Sign Up Text Button
              Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.dont_have_an_account,
                      style: AppTextStyles.bodyLarge,
                    ),
                    TextButton(
                      child: Text(
                        localization.sign_up,
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: context.activeColor),
                      ),
                      onPressed: () => NavigationHelpers.navigateToScreen(
                          context, const SignUpScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Handle Google Sign In
void _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
  try {
    await ref
        .read(authRepositoryProvider)
        .signInWithGoogle()
        .then((_) => ref.refresh(currentUserProvider));

    await SharedPreferencesHelper.setAuthenticationStatus(true);
    if (context.mounted) {
      NavigationHelpers.navigateWithRemoveUntil(context, const HomeScreen());
    }
  } catch (e) {
    await ref
        .read(authRepositoryProvider)
        .signOut()
        .then((_) => SnackbarHelpers.showSnackBarLoginFailed(context));
  }
}
