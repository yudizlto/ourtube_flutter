import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../screens/category_screen/category_screen.dart';
import '../screens/category_screen/music_category.dart';
import '../screens/category_screen/trending_category.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Drawer(
      elevation: 0.0,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // OurTube Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 0.0, 5.0, 0.0),
                    child: Image.asset(AppAssets.logoOurtube, width: 40.0),
                  ),
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 24.0),
                  ),
                ],
              ),
            ),

            // Drawer Items
            // Trending Videos Category
            CustomActionRowButton(
              icon: Icons.trending_up_outlined,
              title: localization.trending_category,
              textStyle: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onTap: () {
                NavigationHelpers.navigateToScreen(
                    context,
                    CategoryScreen(
                      icon: AppAssets.fireIcon,
                      titleCategory: localization.trending_category,
                      content: const TrendingCategory(),
                    ));
              },
            ),

            // Music Videos Category
            CustomActionRowButton(
              icon: Icons.music_note_outlined,
              title: localization.music_category,
              textStyle: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onTap: () {
                NavigationHelpers.navigateToScreen(
                    context,
                    CategoryScreen(
                      icon: AppAssets.musicIcon,
                      titleCategory: localization.music_category,
                      content: const MusicCategory(),
                    ));
              },
            ),

            // Movie Category
            CustomActionRowButton(
              icon: Icons.movie_outlined,
              title: localization.movies_category,
              textStyle: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onTap: () {},
            ),

            // Sports Category
            CustomActionRowButton(
              icon: Icons.sports_soccer_outlined,
              title: localization.sports_category,
              textStyle: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
