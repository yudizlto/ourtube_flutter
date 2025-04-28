import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_strings.dart';
import '../styles/app_text_style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const MainAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      backgroundColor: context.primaryColor,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Image.asset(AppAssets.logoOurtube),
      ),
      title: const Text(AppStrings.appName),
      titleTextStyle: AppTextStyles.titleLarge
          .copyWith(color: context.secondaryColor, fontSize: 20.0),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
