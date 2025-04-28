import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/constants/enums/get_image_from.dart';
import '../../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../../core/utils/constants/enums/video_type.dart';
import '../../../../../core/utils/helpers/dialog_helper.dart';
import '../../../../../core/utils/helpers/image_picker_helper.dart';
import '../../../../user/presentation/providers/user_provider.dart';
import '../../providers/state/video_notifier.dart';
import '../../widgets/create_video_details.dart';
import '../../widgets/upload_video_button.dart';
import '../short_video/layout_upload_short.dart';

class UploadVideoScreen extends ConsumerWidget {
  final VideoType videoType;
  final File videoFile;

  const UploadVideoScreen({
    super.key,
    required this.videoType,
    required this.videoFile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(currentUserProvider);

    final videoState = ref.watch(createLongVideoNotifierProvider);
    final notifier = ref.read(createLongVideoNotifierProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomSliverAppBar(
        title: AppStrings.addDetails,
        showTitle: true,
        leading: CustomBackButton(
          onPressed: () => _handleBackButton(context, ref),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail cover
              videoType == VideoType.long
                  ? Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            image: videoState.selectedThumbnail != null
                                ? DecorationImage(
                                    image: FileImage(
                                        videoState.selectedThumbnail!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image:
                                        AssetImage(AppAssets.imagePlaceholder),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        // Edit / choose thumbnail button
                        Positioned(
                          left: 24.0,
                          top: 24.0,
                          child: IconButton(
                            onPressed: () async {
                              final thumbnail = await ImagePickerHelpers()
                                  .pickImage(GetImageFrom.gallery);
                              if (thumbnail != null) {
                                notifier.setThumbnail(thumbnail);
                              } else {
                                notifier.setThumbnail(null);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.blackDark1)),
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    )
                  : LayoutUploadShort(
                      videoFile: videoFile,
                      screenType: ScreenType.createVideo,
                    ),

              // User info
              Consumer(
                builder: (context, ref, child) {
                  return userRef.when(
                    data: (data) => Container(
                      margin: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(data.photoUrl),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.displayName,
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                data.username,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    error: (error, stackTrace) => const SizedBox(),
                    loading: () => const Loader(),
                  );
                },
              ),

              Divider(color: context.ternaryColor),

              // Create video detail section
              CreateVideoDetails(videoType: videoType),
            ],
          ),
        ),
      ),

      // Upload video button
      bottomSheet: UploadVideoButton(
        videoType: videoType,
        thumbnailRef: videoState.selectedThumbnail,
        videoFile: videoFile,
        titleRef: videoState.title,
        descriptionRef: videoState.description,
        visibilityRef: videoState.visibilityType,
        commentRef: videoState.commentsEnabled,
        audienceRef: videoState.audienceRestricted,
        ageRef: videoState.ageRestricted,
      ),
    );
  }

  // Function for handle back button
  void _handleBackButton(BuildContext context, WidgetRef ref) {
    DialogHelpers.showDiscardUploadVideoDialog(context, ref);
  }
}
