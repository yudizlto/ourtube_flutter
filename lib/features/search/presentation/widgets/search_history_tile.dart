import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/dialog_helper.dart';

/// A widget that represents a search history entry
///
/// This widget allows users to interact with a previous search by:
/// - **Tapping** to search for the selected history entry.
/// - **Long-pressing** to open a confirmation dialog for deleting the history entry
class SearchHistoryTile extends StatelessWidget {
  final AppLocalizations localization;

  const SearchHistoryTile({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /// Handles the tap action to search based on the history entry
      onTap: () {},

      /// Handles the long-press action to delete the history entry
      /// Opens a confirmation dialog before deletion
      onLongPress: () {
        DialogHelpers.showDialogDeleteSearchHistory(
          context,
          "titleaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
          localization,
          () {},
        );
      },
      child: ListTile(
        leading: Icon(
          Icons.history,
          color: context.secondaryColor,
          size: 28.0,
        ),
        title: const Text(
          "Lorem ipsum dolor sit amet",
          style: AppTextStyles.bodyLarge,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Image.asset(
          AppAssets.leftDiagonalArrow,
          width: 28.0,
          color: context.secondaryColor,
        ),
      ),
    );
  }
}
