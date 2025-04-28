import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> title;
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: title.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    title,
                    style: isSelected
                        ? AppTextStyles.titleMedium.copyWith(fontSize: 18.0)
                        : AppTextStyles.titleMedium.copyWith(
                            color: context.ternaryColor, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 2.0,
                    color: isSelected
                        ? context.secondaryColor
                        : Colors.transparent,
                    constraints: BoxConstraints(
                      minWidth: _calculateTextWidth(title, context),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Helper function to calculate the width of the text.
  /// This ensures that the underline matches the text width dynamically
  double _calculateTextWidth(String text, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width + 1.5;
  }
}
