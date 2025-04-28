import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../providers/my_channel_provider.dart';

class SortingVideoOptionBottomSheet extends ConsumerWidget {
  const SortingVideoOptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortByRef = ref.watch(videoSortByProvider);

    final localization = AppLocalizations.of(context)!;

    return Material(
      color: context.surfaceColor,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandleBottomSheet(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24.0, bottom: 10.0),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.blackDark4)),
              ),
              child: Text(
                localization.sort_by,
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              ),
            ),
            ListTile(
              title:
                  Text("${localization.latest} (${AppStrings.defaultLabel})"),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<bool>(
                value: true,
                groupValue: sortByRef,
                activeColor: context.secondaryColor,
                splashRadius: 20.0,
                onChanged: (value) {
                  ref.read(videoSortByProvider.notifier).state = value!;
                },
              ),
              onTap: () {
                ref.read(videoSortByProvider.notifier).state = true;
              },
            ),
            ListTile(
              title: Text(localization.oldest),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<bool>(
                value: false,
                groupValue: sortByRef,
                activeColor: context.secondaryColor,
                splashRadius: 20.0,
                onChanged: (value) {
                  ref.read(videoSortByProvider.notifier).state = value!;
                },
              ),
              onTap: () {
                ref.read(videoSortByProvider.notifier).state = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
