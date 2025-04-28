import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class EditSection extends ConsumerWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  const EditSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: 5.0),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: context.ternaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              icon,
              size: 24.0,
              color: context.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
