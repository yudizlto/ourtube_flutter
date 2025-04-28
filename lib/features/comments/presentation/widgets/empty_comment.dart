import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class EmptyComment extends StatelessWidget {
  final AppLocalizations localization;

  const EmptyComment({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localization.no_comments_yet,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 10.0),
            Text(
              localization.no_comments_yet_description,
              style:
                  AppTextStyles.bodyLarge.copyWith(color: context.ternaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
