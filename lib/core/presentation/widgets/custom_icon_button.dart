import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/app_text_style.dart';

class CustomIconButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                iconPath,
                semanticsLabel: "$title Icon",
                height: 24.0,
                width: 24.0,
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.titleMedium,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
