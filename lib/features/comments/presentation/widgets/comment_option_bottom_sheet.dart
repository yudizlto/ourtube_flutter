import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';

class CommentOptionBottomSheet extends StatelessWidget {
  const CommentOptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.blackDark4,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: Text(
                AppStrings.comment,
                style: AppTextStyles.titleSmall
                    .copyWith(color: context.ternaryColor),
              ),
            ),

            // Button for edit comment
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.edit_outlined, size: 24.0),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: Text(
                        AppStrings.edit,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button for delete comment
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.delete_outlined, size: 24.0),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: Text(
                        AppStrings.delete,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
