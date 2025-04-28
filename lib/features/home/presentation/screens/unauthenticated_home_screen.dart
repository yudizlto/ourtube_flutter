import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/main_app_bar.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../search/presentation/providers/state/search_notifier.dart';
import '../../../search/presentation/screens/search_result_screen.dart';
import '../widgets/home_drawer.dart';

class UnauthenticatedHomeScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UnauthenticatedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final notifier = ref.read(searchNotifier.notifier);

    final borderColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.blackDark2
        : AppColors.blackDark1;

    return Scaffold(
      key: _scaffoldKey,
      appBar: const MainAppBar(
        actions: [NotificationIconButton(), SearchIconButton()],
      ),
      drawer: const HomeDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // OurTube Logo
          Center(
            child: Container(
              width: 150.0,
              height: 100.0,
              margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(AppAssets.logoOurtube),
                fit: BoxFit.cover,
              )),
            ),
          ),

          // Trending Button & Search Bar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Trending drawer button
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: context.buttonColor,
                  ),
                  child: Image.asset(
                    AppAssets.compassIcon,
                    fit: BoxFit.cover,
                    color: context.secondaryColor,
                  ),
                ),
              ),

              // Search Bar
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextField(
                    cursorColor: context.secondaryColor,
                    decoration: InputDecoration(
                      hintText: localization.search_bar_placeholder,
                      hintStyle: AppTextStyles.bodyLarge
                          .copyWith(color: context.ternaryColor),
                      filled: true,
                      fillColor: context.buttonColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: context.buttonColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: context.buttonColor),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        notifier.updateQuery(value);
                        NavigationHelpers.navigateWithPushReplacement(
                            context, SearchResultScreen(query: value));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // Empty Content Message
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
            padding: const EdgeInsets.fromLTRB(15.0, 24.0, 15.0, 24.0),
            decoration: BoxDecoration(
              color: context.buttonColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2.0,
                  blurRadius: 5.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.unauthenticatedHomeTitle,
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  localization.unauthenticatedHomeContent,
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: context.ternaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Login Button
          ShrinkingButton(
            text: localization.sign,
            textColor: AppColors.white,
            buttonColor: context.activeColor,
            width: 80.0,
            onPressed: () => NavigationHelpers.navigateToScreen(
                context, const LoginScreen()),
          ),
        ],
      ),
    );
  }
}
