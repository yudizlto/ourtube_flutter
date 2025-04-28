import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../user/presentation/providers/user_provider.dart';

class PublicCommentSection extends ConsumerWidget {
  final AppLocalizations localization;

  const PublicCommentSection({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Current user's avatar
        CircleAvatar(
          radius: 15.0,
          backgroundImage: NetworkImage(currentUser.value!.photoUrl),
        ),

        // Add comment button
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0),
            child: Material(
              color: context.buttonColor,
              borderRadius: BorderRadius.circular(30.0),
              child: InkWell(
                onTap: () {},
                splashColor: AppColors.blackDark4,
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    localization.add_a_comment,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: context.ternaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
