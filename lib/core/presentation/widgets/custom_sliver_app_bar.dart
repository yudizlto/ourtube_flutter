import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../styles/app_text_style.dart';

class CustomSliverAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool showTitle;
  final List<Widget>? actions;
  final double elevation;
  final double scrolledUnderElevation;
  final Widget? leading;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.showTitle = false,
    this.actions,
    this.elevation = 0.0,
    this.scrolledUnderElevation = 0.0,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.primaryColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: showTitle ? 1.0 : 0.0,
        child: Text(
          title ?? '',
          style: AppTextStyles.titleLarge,
        ),
      ),
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
