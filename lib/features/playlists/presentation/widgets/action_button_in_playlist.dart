import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_assets.dart';

class ActionButtonInPlaylist extends StatelessWidget {
  final Color? titleColor;
  final Color? buttonColor;

  const ActionButtonInPlaylist({
    super.key,
    this.titleColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: ShrinkingButton(
              text: localization.add_videos,
              textColor: context.primaryColor,
              buttonColor: context.secondaryColor,
              onPressed: () {},
            ),
          ),
          ShrinkingButton(
            icon: Icons.edit_outlined,
            margin: const EdgeInsets.only(left: 10.0),
            buttonColor: context.buttonColor,
            onPressed: () {},
          ),
          ShrinkingButton(
            imagePath: AppAssets.shareIcon,
            margin: const EdgeInsets.only(left: 10.0),
            buttonColor: context.buttonColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
