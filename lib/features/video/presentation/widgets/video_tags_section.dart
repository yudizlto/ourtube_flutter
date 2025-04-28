import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_colors.dart';

class VideoTagsSection extends StatelessWidget {
  const VideoTagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShrinkingButton(
              text: "#Flutter",
              textColor: AppColors.black,
              buttonColor: AppColors.lightGrey1,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),
            ShrinkingButton(
              text: "#aaaaaaaaaaaaaaa",
              textColor: AppColors.black,
              buttonColor: AppColors.lightGrey1,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),
            ShrinkingButton(
              text: "#aaaaaaaaaaaaaaa",
              textColor: AppColors.black,
              buttonColor: AppColors.lightGrey1,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),
            ShrinkingButton(
              text: "#aaaaaaaaaaaaaaa",
              textColor: AppColors.black,
              buttonColor: AppColors.lightGrey1,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
