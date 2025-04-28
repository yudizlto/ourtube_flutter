import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

class TopActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isSelected;

  const TopActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            isSelected ? context.secondaryColor : context.buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
