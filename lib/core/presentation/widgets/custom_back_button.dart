import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import 'circular_action_button.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? iconSize;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconSize = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircularActionButton(
      icon: Icons.arrow_back,
      iconSize: iconSize,
      color: context.secondaryColor,
      onTap: onPressed ?? () => Navigator.pop(context),
    );
  }
}
