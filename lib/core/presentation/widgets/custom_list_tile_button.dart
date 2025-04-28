import 'package:flutter/material.dart';

class CustomListTileButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry padding;

  const CustomListTileButton({
    super.key,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
