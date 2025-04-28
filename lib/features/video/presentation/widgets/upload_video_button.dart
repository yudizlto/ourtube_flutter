import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/state/video_notifier.dart';
import '../providers/video_provider.dart';

class UploadVideoButton extends ConsumerWidget {
  final VideoType videoType;
  final File? thumbnailRef;
  final String titleRef;
  final String descriptionRef;
  final String visibilityRef;
  final bool commentRef;
  final bool audienceRef;
  final bool ageRef;
  final File videoFile;

  const UploadVideoButton({
    super.key,
    required this.videoType,
    required this.thumbnailRef,
    required this.titleRef,
    required this.descriptionRef,
    required this.visibilityRef,
    required this.commentRef,
    required this.audienceRef,
    required this.ageRef,
    required this.videoFile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final userRef = ref.watch(currentUserProvider);
    final titleErrorRef = ref.watch(titleErrorProvider);
    final descErrorRef = ref.watch(descriptionErrorProvider);

    final isButtonDisabled = descErrorRef != null || titleErrorRef != null;

    /// Function for upload thumbnail to storage
    Future<void> uploadThumbnail(String videoId) async {
      final currentUserId = userRef.value!.userId;
      final uploadThumbnailUseCase = ref.read(uploadThumbnailUseCaseProvider);

      if (thumbnailRef != null) {
        await uploadThumbnailUseCase.execute(
            thumbnailRef!, currentUserId, videoId);
      }
    }

    /// Function for upload video to storage
    Future<void> uploadVideo() async {
      final videoController = VideoPlayerController.file(videoFile);
      final formattedDate = StringHelpers.formattedDate(DateTime.now());
      final currentUserId = userRef.value!.userId;
      final videoId = const Uuid().v4();

      try {
        await videoController.initialize();
        final videoDurationInSeconds = videoController.value.duration.inSeconds;

        final uploadVideoUseCase = ref.read(uploadVideoUseCaseProvider);
        await uploadVideoUseCase.execute(
          videoFile,
          videoId,
          currentUserId,
          titleRef.isEmpty ? formattedDate : titleRef,
          descriptionRef,
          visibilityRef,
          commentRef,
          ageRef,
          audienceRef,
          videoDurationInSeconds,
          videoType == VideoType.long ? AppStrings.long : AppStrings.shorts,
        );

        /// Upload the thumbnail ONLY if the video type is "Long" and a thumbnail is provided
        if (videoType == VideoType.long && thumbnailRef != null) {
          await uploadThumbnail(videoId);
        }
      } finally {
        videoController.dispose();
      }
    }

    /// Funtion onpress upload button
    Future<void> handleUploadButton() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Loader(),
      );

      await uploadVideo()
          .then((_) => SnackbarHelpers.showSnackBarSuccessUploadVideo(context));

      /// reset state
      final videoNotifier = ref.read(createLongVideoNotifierProvider.notifier);
      ref.read(titleErrorProvider.notifier).state = null;
      ref.read(descriptionErrorProvider.notifier).state = null;

      videoNotifier.reset(null, false);

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

    return Container(
      width: double.infinity,
      height: 65.0,
      color: context.primaryColor,
      padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 5.0),
      child: ShrinkingButton(
        text: videoType == VideoType.long
            ? AppStrings.upload
            : localization.upload_short,
        textColor: context.primaryColor,
        buttonColor: isButtonDisabled
            ? context.disabledButtonColor
            : context.secondaryColor,
        width: 80.0,
        onPressed: isButtonDisabled ? null : () => handleUploadButton(),
      ),
    );
  }
}
