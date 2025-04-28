import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/home/presentation/providers/bottom_navigation_provider.dart';
import '../../../features/user/presentation/providers/user_provider.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/helpers/modal_helpers.dart';
import '../../utils/helpers/navigation_helpers.dart';
import '../../utils/helpers/shared_preferences_helper.dart';
import 'navbar_button.dart';

class BottomNavbar extends ConsumerWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final selectedIndexRef = ref.watch(selectedNavbarProvider);
    final currentUserRef = ref.watch(currentUserProvider);

    return Container(
      width: double.infinity,
      height: 55.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: context.ternaryColor,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Home page button
          /// Navigates to the home page when tapped.
          NavbarButton(
            iconPath: selectedIndexRef == 0
                ? AppAssets.homeSelectedIcon
                : AppAssets.homeIcon,
            label: localization.home,
            isSelected: selectedIndexRef == 0,
            onTap: () {
              ref.read(selectedNavbarProvider.notifier).state = 0;
              NavigationHelpers.handleNavbarTap(context, 0);
            },
          ),

          /// Shorts video page button
          /// Navigates to the Shorts page when tapped.
          NavbarButton(
            iconPath: AppAssets.shortIcon,
            label: localization.shorts,
            isSelected: selectedIndexRef == 1,
            onTap: () {
              ref.read(selectedNavbarProvider.notifier).state = 1;
              NavigationHelpers.handleNavbarTap(context, 1);
            },
          ),

          /// Add / upload button
          /// This button is only visible if the user is authenticated.
          /// When tapped, it opens a bottom sheet for media uploads.
          FutureBuilder<bool>(
            future: SharedPreferencesHelper.getAuthenticationStatus(),
            builder: (context, snapshot) {
              final bool isAuthenticated = snapshot.data ?? false;

              return isAuthenticated
                  ? InkWell(
                      onTap: () =>
                          ModalHelpers.showBottomSheetForUpload(context),
                      customBorder: const CircleBorder(),
                      highlightColor: AppColors.blackDark5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: context.buttonColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 30.0,
                            color: context.secondaryColor,
                          ),
                        ),
                      ),
                    )

                  /// Returns an empty widget if not authenticated
                  : const SizedBox();
            },
          ),

          /// Subscriptions page button
          /// Navigates to the Subscriptions page when tapped.
          NavbarButton(
            iconPath: selectedIndexRef == 2
                ? AppAssets.subSelectedIcon
                : AppAssets.subIcon,
            label: localization.subscriptions,
            isSelected: selectedIndexRef == 2,
            onTap: () {
              ref.read(selectedNavbarProvider.notifier).state = 2;
              NavigationHelpers.handleNavbarTap(context, 2);
            },
          ),

          /// Library / Profile page button
          /// Navigates to the Profile (Library) page when tapped.
          /// Displays the user's profile picture if logged in.
          NavbarButton(
            isProfile: true,
            isSelected: selectedIndexRef == 3,
            label: localization.you,
            currentUserRef: currentUserRef,
            onTap: () {
              ref.read(selectedNavbarProvider.notifier).state = 3;
              NavigationHelpers.handleNavbarTap(context, 3);
            },
          ),
        ],
      ),
    );
  }
}
