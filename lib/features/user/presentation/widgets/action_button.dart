import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ActionButton extends ConsumerWidget {
  final AppLocalizations localization;

  const ActionButton({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ShrinkingButton(
              text: localization.sign_out,
              icon: Icons.logout_rounded,
              buttonColor: context.buttonColor,
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Loader(),
                );

                await Future.delayed(const Duration(seconds: 2));
                await ref.read(authRepositoryProvider).signOut();

                await SharedPreferencesHelper.clearPreferences();
                await SharedPreferencesHelper.setAuthenticationStatus(false);

                if (context.mounted) {
                  NavigationHelpers.navigateWithRemoveUntil(
                      context, const LoginScreen());
                }
              },
            ),
            const SizedBox(width: 10.0),
            ShrinkingButton(
              text: localization.google_account,
              textColor: context.secondaryColor,
              buttonColor: context.buttonColor,
              icon: Icons.facebook,
              onPressed: () {},
            ),
            const SizedBox(width: 10.0),
            ShrinkingButton(
              text: localization.turn_on_incognito,
              icon: Icons.visibility,
              buttonColor: context.buttonColor,
              onPressed: () {},
            ),
            const SizedBox(width: 10.0),
            ShrinkingButton(
              text: localization.share_channel,
              icon: Icons.share,
              buttonColor: context.buttonColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
