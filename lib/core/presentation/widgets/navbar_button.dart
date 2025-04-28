import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/user/data/models/user_model.dart';
import '../../utils/constants/app_colors.dart';
import '../styles/app_text_style.dart';
import 'loader.dart';

class NavbarButton extends StatelessWidget {
  final String? iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isProfile;
  final AsyncValue<UserModel?>? currentUserRef;

  const NavbarButton({
    super.key,
    this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProfile = false,
    this.currentUserRef,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isProfile
                ? _buildProfileIcon(context)
                : Image.asset(
                    iconPath!,
                    width: 30.0,
                    height: 30.0,
                    color: context.secondaryColor,
                  ),
            Text(
              label,
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    if (currentUserRef == null || currentUserRef!.value == null) {
      return const Icon(Icons.account_circle);
    }

    return currentUserRef!.when(
      data: (data) => CircleAvatar(
        backgroundColor: isSelected ? AppColors.black : Colors.transparent,
        radius: 13.0,
        child: CircleAvatar(
          radius: isSelected ? 11.0 : 13.0,
          backgroundColor: isSelected ? AppColors.white : Colors.transparent,
          child: CircleAvatar(
            backgroundImage: NetworkImage(data!.photoUrl),
            radius: isSelected ? 10.0 : 13.0,
            backgroundColor: AppColors.black,
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => const Icon(Icons.account_circle),
    );
  }
}
