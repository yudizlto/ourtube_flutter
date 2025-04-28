import 'package:flutter/material.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

/// A widget that displays a friendly message when no content is available.
class EmptyContentMessage extends StatelessWidget {
  final String? imagePath;
  final String message;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const EmptyContentMessage({
    super.key,
    this.imagePath,
    required this.message,
    this.size = 150.0,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          imagePath != null
              ? Padding(
                  padding:
                      padding ?? const EdgeInsets.symmetric(vertical: 30.0),
                  child: Image.asset(
                    imagePath!,
                    width: size,
                    fit: BoxFit.cover,
                    color: color,
                  ),
                )
              : const SizedBox(),
          Text(
            message,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
