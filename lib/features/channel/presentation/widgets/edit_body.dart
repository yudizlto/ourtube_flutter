import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/my_channel_provider.dart';
import 'description_text_form_field.dart';
import 'edit_privacy_section.dart';
import 'edit_section.dart';

class EditBody extends ConsumerStatefulWidget {
  final AppLocalizations localization;

  const EditBody({super.key, required this.localization});

  @override
  ConsumerState<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends ConsumerState<EditBody> {
  @override
  Widget build(BuildContext context) {
    final currentUserRef = ref.watch(currentUserProvider);

    return currentUserRef.when(
      data: (data) => Column(
        children: [
          // Edit name section
          EditSection(
            title: widget.localization.name,
            subtitle: data.displayName,
            icon: Icons.edit_outlined,
            onTap: () {
              ModalHelpers.showBottomSheetForEditName(
                widget.localization,
                context,
                currentUserRef.value!.displayName,
              );
            },
          ),

          // Edit username section
          EditSection(
            title: widget.localization.handle,
            subtitle: "@${data.username}",
            icon: Icons.edit_outlined,
            onTap: () {
              ModalHelpers.showBottomSheetForEditUsername(
                widget.localization,
                context,
                currentUserRef.value!.username,
              );
            },
          ),

          // Edit channel url section
          EditSection(
              title: widget.localization.channel_url,
              subtitle: "${AppStrings.userChannelUrl}${data.username}",
              icon: Icons.copy_sharp,
              onTap: () {
                SnackbarHelpers.showSnackBarWithClipboardCopy(
                  context,
                  "${AppStrings.userChannelUrl}${data.username}",
                );
              }),

          // Edit description section
          EditSection(
              title: widget.localization.description,
              subtitle: data.description.isEmpty
                  ? widget.localization.add_a_description
                  : data.description,
              icon: Icons.edit_outlined,
              onTap: () {
                NavigationHelpers.navigateToScreen(
                  context,
                  DescriptionTextFormField(
                    initialValue: data.description,
                    localization: widget.localization,
                  ),
                );
              }),

          // Edit privacy section
          EditPrivacySection(
            localization: widget.localization,
            value: ref.watch(isSwitchedProvider),
            onChanged: (value) =>
                ref.read(isSwitchedProvider.notifier).state = value,
          ),
        ],
      ),
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const Loader(),
    );
  }
}
