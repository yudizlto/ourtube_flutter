import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_error_label.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';
import '../providers/video_provider.dart';

class EditVideoDescriptionTextFormField extends ConsumerStatefulWidget {
  final ScreenType screenType;
  final VideoModel? video;

  const EditVideoDescriptionTextFormField({
    super.key,
    required this.screenType,
    this.video,
  });

  @override
  ConsumerState<EditVideoDescriptionTextFormField> createState() =>
      _EditVideoDescriptionTextFormFieldState();
}

class _EditVideoDescriptionTextFormFieldState
    extends ConsumerState<EditVideoDescriptionTextFormField> {
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();

    /// Fetch the initial description from the provider.
    final intialDescription =
        ref.read(createLongVideoNotifierProvider).description;

    /// Determine the initial text value based on screen type.
    /// If in edit mode and the video exists, get the existing description from state.
    /// Otherwise, use the default description from the provider.
    String initialValue;
    if (widget.screenType == ScreenType.editVideo && widget.video != null) {
      initialValue =
          ref.read(editVideoNotifierProvider(widget.video!)).description;
    } else {
      initialValue = intialDescription;
    }

    /// Initialize the text controller with the determined value.
    _descController = TextEditingController(text: initialValue);

    /// Add a listener to update the provider state when text changes.
    _descController.addListener(() {
      if (widget.screenType == ScreenType.editVideo && widget.video != null) {
        ref
            .read(editVideoNotifierProvider(widget.video!).notifier)
            .updateDescription(_descController.text);
      } else {
        ref
            .read(createLongVideoNotifierProvider.notifier)
            .createDescription(_descController.text);
      }
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    /// Get the current description value from the provider.
    final descRef = widget.screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(widget.video!)).description
        : ref.watch(createLongVideoNotifierProvider).description;

    /// Validate the description character count.
    final errorMessage = widget.screenType == ScreenType.editVideo
        ? ValidationUtils.validateDescriptionCharacterCount(
            descRef, localization.use_shorter_description)
        : ValidationUtils.validateDescriptionCharacterCount(
            descRef, localization.text_is_too_long);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomSliverAppBar(
        title: widget.screenType == ScreenType.editVideo
            ? localization.edit_description
            : localization.add_description,
        showTitle: true,
        leading: CustomBackButton(
          onPressed: widget.screenType == ScreenType.editVideo
              ? () => Navigator.pop(context, descRef)
              : () => Navigator.pop(context, descRef),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Textfield for description
            TextField(
              maxLines: null,
              controller: _descController,
              cursorColor: context.secondaryColor,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(12.0),
              ),
              style: AppTextStyles.bodyLarge,
              onChanged: (value) {
                /// When text changes, update the corresponding provider.
                /// And validate the new description length and update the error state.
                final descError = widget.screenType == ScreenType.editVideo
                    ? ValidationUtils.validateDescriptionCharacterCount(
                        descRef, localization.use_shorter_description)
                    : ValidationUtils.validateDescriptionCharacterCount(
                        descRef, localization.text_is_too_long);

                if (widget.screenType == ScreenType.editVideo) {
                  ref.read(descriptionErrorProvider.notifier).state = descError;
                } else {
                  ref.read(descriptionErrorProvider.notifier).state = descError;
                }
              },
            ),

            // Warning message and character count
            CustomErrorLabel(
              errorMessage: errorMessage,
              charactersRef: descRef,
              maxCharacter: 5000,
              warningCount: 4950,
            ),
          ],
        ),
      ),
    );
  }
}
