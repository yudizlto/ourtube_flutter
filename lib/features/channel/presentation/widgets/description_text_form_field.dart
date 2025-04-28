import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/dialog_helper.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../providers/my_channel_provider.dart';

class DescriptionTextFormField extends ConsumerStatefulWidget {
  final String initialValue;
  final AppLocalizations localization;

  const DescriptionTextFormField({
    super.key,
    required this.initialValue,
    required this.localization,
  });

  @override
  ConsumerState<DescriptionTextFormField> createState() =>
      _DescriptionTextFormFieldState();
}

class _DescriptionTextFormFieldState
    extends ConsumerState<DescriptionTextFormField> {
  late TextEditingController _descController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    /// Request focus on the text field after the widget is built
    /// and reset the isDescriptionChangedProvider state to false
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      ref.read(isDescriptionChangedProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Handles the back navigation behavior.
  /// If there are unsaved changes, it prompts the user with a confirmation dialog.
  Future<void> _handlePopInvoked(bool didPop) async {
    if (didPop) return;
    final bool shouldPop =
        await DialogHelpers.showDiscardChangesDialog(context: context) ?? false;

    if (mounted && shouldPop) {
      Navigator.pop(context);
    }
  }

  /// Handles text changes in the description field.
  /// Updates the state in Riverpod providers and validates the maximum length.
  void _handleDescriptionChange(String value, AppLocalizations localization) {
    ref.read(myChannelDescriptionProvider.notifier).state = value;
    final hasChanged = value.trim() != widget.initialValue.trim();
    ref.read(isDescriptionChangedProvider.notifier).state = hasChanged;

    final newErrorMessage = ValidationUtils.validateMaxLength(value, 1000,
        message: localization.use_shorter_description);
    ref.read(myChannelDescriptionErrorProvider.notifier).state =
        newErrorMessage;
  }

  /// Handles the save button press.
  /// Updates the user's description and displays a success snackbar.
  Future<void> _onSavePressed() async {
    final updatedDesc = _descController.text;
    await ref
        .read(updateUserProvider)
        .call(AppStrings.description.toLowerCase(), updatedDesc)
        .then((_) => Navigator.pop(context))
        .then((_) => SnackbarHelpers.showCommonSnackBar(
            context, widget.localization.description_changed));
  }

  @override
  Widget build(BuildContext context) {
    final isChanged = ref.watch(isDescriptionChangedProvider);
    final descRef = ref.watch(myChannelDescriptionProvider);

    final errorMessage = ValidationUtils.validateMaxLength(descRef, 1000,
        message: widget.localization.use_shorter_description);

    return PopScope(
      canPop: false,
      onPopInvoked: _handlePopInvoked,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomSliverAppBar(
          title: widget.localization.description,
          showTitle: true,
          actions: [
            ShrinkingButton(
              text: widget.localization.save,
              textColor: context.primaryColor,
              buttonColor: (isChanged && errorMessage == null)
                  ? context.secondaryColor
                  : AppColors.blackDark3,
              width: 70.0,
              onPressed:
                  (isChanged && errorMessage == null) ? _onSavePressed : null,
            ),
            const SizedBox(width: 18.0),
          ],
        ),
        body: ListView(
          children: [
            TextField(
              maxLines: null,
              controller: _descController,
              focusNode: _focusNode,
              cursorColor: context.secondaryColor,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                counterStyle: AppTextStyles.bodySmall
                    .copyWith(color: context.ternaryColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(12.0),
              ),
              style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              onChanged: (value) =>
                  _handleDescriptionChange(value, widget.localization),
            ),

            // Warning message and character count
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Warning message (only show if there is an error)
                  if (errorMessage != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outlined,
                              color: context.errorColor,
                              size: 18.0,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                errorMessage,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: context.errorColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  /// Character count (only show when length >= 950)
                  if (descRef.length >= 950)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "${descRef.length} / 1000",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: errorMessage != null
                              ? context.errorColor
                              : AppColors.blackDark2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
