import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/presentation/styles/app_text_style.dart';

class EmptySubsHeader extends StatelessWidget {
  const EmptySubsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 24.0),
      // decoration: const BoxDecoration(color: AppColors.blackDark5),
      decoration: BoxDecoration(color: context.ternaryColor),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              AppAssets.subsIcon,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Text(
                  AppStrings.newVideos,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: context.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppStrings.newVideosDescription,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: context.surfaceColor,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
