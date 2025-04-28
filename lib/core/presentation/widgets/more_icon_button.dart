import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import 'circular_action_button.dart';

class MoreIconButton extends StatelessWidget {
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback onTap;

  const MoreIconButton({
    super.key,
    this.iconSize = 28.0,
    this.padding = const EdgeInsets.all(10.0),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircularActionButton(
      color: context.secondaryColor,
      icon: Icons.more_vert,
      iconSize: iconSize,
      padding: padding,
      onTap: onTap,
    );
  }
}
