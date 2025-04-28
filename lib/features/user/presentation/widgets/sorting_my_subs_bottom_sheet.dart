import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_action_row_button.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../providers/subscription_provider.dart';

class SortingMySubsBottomSheet extends ConsumerWidget {
  const SortingMySubsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortByRef = ref.watch(subsSortByProvider);

    final localization = AppLocalizations.of(context)!;

    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            ListTile(
              title: Text(localization.most_relevant_order),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<String>(
                value: AppStrings.mostRelevantOrder,
                groupValue: sortByRef,
                activeColor: context.secondaryColor,
                splashRadius: 20.0,
                onChanged: (value) {
                  ref.read(subsSortByProvider.notifier).state = value!;
                },
              ),
              onTap: () {
                ref.read(subsSortByProvider.notifier).state =
                    AppStrings.mostRelevantOrder;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(localization.ascending_order),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<String>(
                value: AppStrings.ascendingOrder,
                groupValue: sortByRef,
                activeColor: context.secondaryColor,
                splashRadius: 20.0,
                onChanged: (value) {
                  ref.read(subsSortByProvider.notifier).state = value!;
                },
              ),
              onTap: () {
                ref.read(subsSortByProvider.notifier).state =
                    AppStrings.ascendingOrder;
                Navigator.pop(context);
              },
            ),
            Divider(color: context.ternaryColor),

            // Button for close the bottom sheet
            CustomActionRowButton(
              title: localization.cancel,
              icon: Icons.cancel_outlined,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              onTap: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
