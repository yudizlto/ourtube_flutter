import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../utils/constants/app_colors.dart';

class ShrinkingButton extends StatefulWidget {
  final String? text;
  final double? width;
  final IconData? icon;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final String? imagePath;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const ShrinkingButton({
    super.key,
    this.text,
    this.width,
    this.icon,
    this.imagePath,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(8.0),
    this.buttonColor = AppColors.blackDark5,
    this.textColor,
    this.borderColor = Colors.transparent,
    this.fontWeight = FontWeight.w500,
    required this.onPressed,
  });

  @override
  State<ShrinkingButton> createState() => _ShrinkingButtonState();
}

class _ShrinkingButtonState extends State<ShrinkingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = context.secondaryColor;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            border: Border.all(color: widget.borderColor!),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Padding(
                  padding:
                      EdgeInsets.only(right: widget.text != null ? 8.0 : 0.0),
                  child: Icon(widget.icon, color: iconColor, size: 20.0),
                ),
              if (widget.imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(widget.imagePath!,
                      width: 18.0, color: iconColor),
                ),
              if (widget.text != null)
                Text(
                  widget.text!,
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: widget.fontWeight,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
