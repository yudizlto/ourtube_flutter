import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;

  const SettingsAppBar({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      backgroundColor: context.primaryColor,
      title: Text(appBarTitle),
      titleTextStyle:
          AppTextStyles.titleLarge.copyWith(color: context.secondaryColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
