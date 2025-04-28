import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_error_label.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';
import '../providers/video_provider.dart';

class VideoTitleTextField extends ConsumerStatefulWidget {
  final ScreenType screenType;
  final VideoModel? video;

  const VideoTitleTextField({
    super.key,
    required this.screenType,
    this.video,
  });

  @override
  ConsumerState<VideoTitleTextField> createState() =>
      _VideoTitleTextFieldState();
}

class _VideoTitleTextFieldState extends ConsumerState<VideoTitleTextField> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    String initialValue;
    if (widget.screenType == ScreenType.editVideo && widget.video != null) {
      initialValue = ref.read(editVideoNotifierProvider(widget.video!)).title;
    } else {
      initialValue = ref.read(createLongVideoNotifierProvider).title;
    }

    _titleController = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final videoNotifier = widget.screenType == ScreenType.editVideo
        ? ref.read(editVideoNotifierProvider(widget.video!).notifier)
        : ref.read(createLongVideoNotifierProvider.notifier);

    /// Determine the correct title value based on screen type.
    final titleRef = widget.screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(widget.video!)).title
        : ref.watch(createLongVideoNotifierProvider).title;

    /// Validate the title length and retrieve appropriate error messages.
    final errorMessage = widget.screenType == ScreenType.editVideo
        ? ValidationUtils.validateEditCurrentTitle(titleRef,
            localization.choose_shorter_title, localization.title_is_required)
        : ValidationUtils.validateTitleCharacterCount(
            titleRef, localization.choose_shorter_title);

    return Container(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: context.ternaryColor, width: 1.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextField for title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              maxLines: null,
              controller: _titleController,
              cursorColor: context.secondaryColor,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                hintText: localization.create_a_title,
                counterStyle: AppTextStyles.bodyLarge
                    .copyWith(color: context.ternaryColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(12.0),
              ),
              style: AppTextStyles.bodyLarge,
              onChanged: (value) {
                /// When the text changes, update the relevant state.
                /// And validate the new title length and update the error message.
                final titleError = widget.screenType == ScreenType.editVideo
                    ? ValidationUtils.validateEditCurrentTitle(
                        value,
                        localization.choose_shorter_title,
                        localization.title_is_required)
                    : ValidationUtils.validateTitleCharacterCount(
                        value, localization.choose_shorter_title);

                if (widget.screenType == ScreenType.editVideo) {
                  videoNotifier.updateTitle(value);
                  ref.read(titleErrorProvider.notifier).state = titleError;
                } else {
                  videoNotifier.createTitle(value);
                  ref.read(titleErrorProvider.notifier).state = titleError;
                }
              },
            ),
          ),

          // Warning message and character count
          CustomErrorLabel(
            errorMessage: errorMessage,
            charactersRef: titleRef,
            maxCharacter: 100,
            warningCount: 90,
          ),
        ],
      ),
    );
  }
}
