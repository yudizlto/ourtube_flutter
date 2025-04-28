import 'package:flutter/material.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';

class LogoSection extends StatelessWidget {
  final String title;

  const LogoSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          Image.asset(AppAssets.logoOurtube, height: 100.0),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 28.0),
          ),
        ],
      ),
    );
  }
}
