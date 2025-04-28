import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';

class AddNewPlaylistButton extends StatelessWidget {
  final AppLocalizations localization;

  const AddNewPlaylistButton({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18.0),
      child: InkWell(
        onTap: () => ModalHelpers.showBottomSheetForCreatePlaylist(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
          child: SizedBox(
            width: 158.0,
            height: 95.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: context.buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: context.secondaryColor,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(localization.new_playlist, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
