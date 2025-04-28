import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/constants/enums/get_image_from.dart';
import '../../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../../core/utils/helpers/dialog_helper.dart';
import '../../../../../core/utils/helpers/image_picker_helper.dart';
import '../../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../user/presentation/providers/user_provider.dart';
import '../../../data/models/video_model.dart';
import '../../providers/state/video_notifier.dart';
import '../../providers/video_provider.dart';
import '../../widgets/duration_indicator.dart';
import '../../widgets/edit_video_details.dart';
import '../short_video/layout_upload_short.dart';

class EditVideoScreen extends ConsumerWidget {
  final VideoModel video;

  const EditVideoScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final userIdRef = ref.watch(currentUserProvider).value!.userId;
    final videoState = ref.watch(editVideoNotifierProvider(video));
    final videoNotifier = ref.read(editVideoNotifierProvider(video).notifier);

    final titleErrorRef = ref.watch(titleErrorProvider);
    final descErrorRef = ref.watch(descriptionErrorProvider);

    final isButtonDisabled = videoState.isDataUnchanged ||
        videoState.title.isEmpty ||
        descErrorRef != null ||
        titleErrorRef != null;

    /// Function for update thumbnail to storage
    Future<void> updateThumbnail(String videoId) async {
      final updateThumbnailUseCase = ref.read(updateThumbnailUseCaseProvider);
      await updateThumbnailUseCase.execute(
          videoState.selectedThumbnail!, userIdRef, videoId);
    }

    /// Function for save and update the video changes
    Future<void> updateChanges() async {
      final updateVideoChanges = ref.read(updateVideoChangesUseCaseProvider);
      await updateVideoChanges.execute(
        video.videoId,
        videoState.title,
        videoState.description,
        videoState.visibilityType,
        videoState.commentsEnabled,
        videoState.ageRestricted,
        videoState.audienceRestricted,
      );

      if (videoState.selectedThumbnail != null) {
        await updateThumbnail(video.videoId);
      }
    }

    /// Funtion onpress upload button
    Future<void> handleSaveButton() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Loader(),
      );

      await updateChanges().then((_) => SnackbarHelpers.showGlassySnackBar(
          context, localization.video_updated));

      /// reset state
      ref.read(titleErrorProvider.notifier).state = null;
      ref.read(descriptionErrorProvider.notifier).state = null;
      videoNotifier.reset(video, true);

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomSliverAppBar(
        title: AppStrings.editVideo,
        showTitle: true,
        actions: [
          // Button for save the video changes
          ShrinkingButton(
            text: localization.save,
            textColor: AppColors.white,
            buttonColor:
                isButtonDisabled ? AppColors.blackDark3 : context.activeColor,
            width: 80.0,
            margin: const EdgeInsets.only(right: 18.0),
            onPressed: isButtonDisabled ? null : () => handleSaveButton(),
          ),
        ],
        leading:
            CustomBackButton(onPressed: () => _handleBackButton(context, ref)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail cover
              video.type == AppStrings.long
                  ? Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240.0,
                          decoration: BoxDecoration(
                            image: videoState.selectedThumbnail != null
                                ? DecorationImage(
                                    image: FileImage(
                                        videoState.selectedThumbnail!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(video.thumbnailUrl),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        // Edit or choose thumbnail button
                        Positioned(
                          left: 24.0,
                          top: 24.0,
                          child: IconButton(
                            onPressed: () async {
                              final thumbnail = await ImagePickerHelpers()
                                  .pickImage(GetImageFrom.gallery);
                              if (thumbnail != null) {
                                videoNotifier
                                    .updateSelectedThumbnail(thumbnail);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.blackDark1)),
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.white,
                          ),
                        ),

                        // Video's duration
                        DurationIndicator(video: video),
                      ],
                    )
                  : LayoutUploadShort(
                      video: video,
                      screenType: ScreenType.editVideo,
                    ),

              // Edit video detail section
              EditVideoDetails(video: video),
            ],
          ),
        ),
      ),
    );
  }

  /// Function for handle back button
  void _handleBackButton(BuildContext context, WidgetRef ref) {
    DialogHelpers.showDiscardEditVideoDialog(context, ref, video);
  }
}
