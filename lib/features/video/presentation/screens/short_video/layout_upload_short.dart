import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/custom_error_label.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../../core/utils/helpers/validators.dart';
import '../../../data/models/video_model.dart';
import '../../providers/state/video_notifier.dart';
import '../../providers/video_provider.dart';

class LayoutUploadShort extends ConsumerStatefulWidget {
  final File? videoFile;
  final VideoModel? video;
  final ScreenType screenType;

  const LayoutUploadShort({
    super.key,
    this.videoFile,
    this.video,
    required this.screenType,
  });

  @override
  ConsumerState<LayoutUploadShort> createState() => _LayoutUploadShortState();
}

class _LayoutUploadShortState extends ConsumerState<LayoutUploadShort> {
  late TextEditingController _titleController;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    String initialTitle;
    if (widget.screenType == ScreenType.editVideo && widget.video != null) {
      initialTitle = ref.read(editVideoNotifierProvider(widget.video!)).title;
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.video!.videoUrl))
            ..initialize().then((_) => setState(() {}));
    } else {
      initialTitle = ref.read(createLongVideoNotifierProvider).title;
      _videoController = VideoPlayerController.file(widget.videoFile!)
        ..initialize().then((_) => setState(() {}));
    }

    _titleController = TextEditingController(text: initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final notifier = widget.screenType == ScreenType.editVideo
        ? ref.read(editVideoNotifierProvider(widget.video!).notifier)
        : ref.read(createLongVideoNotifierProvider.notifier);

    final titleRef = widget.screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(widget.video!)).title
        : ref.watch(createLongVideoNotifierProvider).title;

    /// Validate the title length and retrieve appropriate error messages.
    final titleError = widget.screenType == ScreenType.createVideo
        ? ValidationUtils.validateTitleCharacterCount(
            titleRef, localization.choose_shorter_title)
        : ValidationUtils.validateEditCurrentTitle(titleRef,
            localization.choose_shorter_title, localization.title_is_required);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.ternaryColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview video short
            SizedBox(
              width: 90.0,
              height: 130.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _videoController.value.isInitialized
                    ? VideoPlayer(_videoController)
                    : const Loader(),
              ),
            ),

            // Title text field
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLines: null,
                      controller: _titleController,
                      cursorColor: context.secondaryColor,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: localization.caption_for_short_hint_text,
                        counterStyle: AppTextStyles.bodyLarge
                            .copyWith(color: context.ternaryColor),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      style: AppTextStyles.bodyLarge,
                      onChanged: (value) {
                        final errMessage =
                            widget.screenType == ScreenType.createVideo
                                ? ValidationUtils.validateTitleCharacterCount(
                                    titleRef, localization.choose_shorter_title)
                                : ValidationUtils.validateEditCurrentTitle(
                                    titleRef,
                                    localization.choose_shorter_title,
                                    localization.title_is_required);

                        if (widget.screenType == ScreenType.editVideo) {
                          notifier.updateTitle(value);
                          ref.read(titleErrorProvider.notifier).state =
                              errMessage;
                        } else {
                          notifier.createTitle(value);
                          ref.read(titleErrorProvider.notifier).state =
                              errMessage;
                        }
                      },
                    ),

                    // Warning message and character count
                    CustomErrorLabel(
                      errorMessage: titleError,
                      charactersRef: titleRef,
                      maxCharacter: 100,
                      warningCount: 90,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
