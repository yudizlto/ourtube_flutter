import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class EditVideoOptionTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? label;
  final VoidCallback? onTap;
  final bool chevronRight;
  final String? errorMessage;

  const EditVideoOptionTile({
    super.key,
    this.icon,
    required this.title,
    this.label,
    this.onTap,
    this.chevronRight = true,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 24.0),
            if (icon != null) const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: context.ternaryColor),
                    ),
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Show error message if any
                  if (errorMessage != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outlined,
                          color: context.errorColor,
                          size: 18.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          errorMessage!,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.errorColor),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Icon(
              chevronRight ? Icons.chevron_right : Icons.add,
              color: context.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
