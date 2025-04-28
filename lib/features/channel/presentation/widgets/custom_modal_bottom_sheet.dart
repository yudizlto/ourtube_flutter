import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../providers/my_channel_provider.dart';
import 'custom_text_field.dart';

class CustomModalBottomSheet extends ConsumerStatefulWidget {
  final AppLocalizations localization;
  final String label;
  final String initialValue;
  final String message;
  final String otherMessage;
  final String field;
  final String snackbarMessage;
  final String type;
  final String? Function(String?)? validator;

  const CustomModalBottomSheet({
    super.key,
    required this.localization,
    required this.label,
    required this.initialValue,
    required this.message,
    required this.otherMessage,
    required this.field,
    required this.snackbarMessage,
    required this.type,
    this.validator,
  });

  @override
  ConsumerState<CustomModalBottomSheet> createState() =>
      _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState
    extends ConsumerState<CustomModalBottomSheet> {
  late TextEditingController _textEditingController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
    _errorMessage = widget.validator?.call(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: keyboardVisible),
        padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            // Label section
            Text(widget.label,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0)),
            const SizedBox(height: 8.0),

            // Text field
            CustomTextField(
              textEditingController: _textEditingController,
              validator: widget.validator,
              errorMessage: _errorMessage,
              type: widget.type,
              onChanged: (value) {
                setState(() => _errorMessage = widget.validator?.call(value));
              },
            ),

            // Warning messages
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.visibility_sharp, color: context.secondaryColor),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTextStyles.bodyLarge
                        .copyWith(wordSpacing: 0.0, height: 0.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: context.secondaryColor),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.otherMessage,
                    style: AppTextStyles.bodyLarge
                        .copyWith(wordSpacing: 0.0, height: 0.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Save button
            ShrinkingButton(
              text: widget.localization.save,
              textColor: context.primaryColor,
              fontWeight: FontWeight.w600,
              buttonColor: _errorMessage == null
                  ? context.secondaryColor
                  : AppColors.blackDark3,
              onPressed: () async {
                try {
                  final updatedValue = _textEditingController.text;
                  await ref
                      .read(updateUserProvider)
                      .call(widget.field, updatedValue)
                      .then((_) => Navigator.pop(context))
                      .then((_) => SnackbarHelpers.showCommonSnackBar(
                          context, widget.snackbarMessage));
                } catch (e) {
                  if (context.mounted) {
                    SnackbarHelpers.showCommonSnackBar(
                        context, AppStrings.somethingWentWrong);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
