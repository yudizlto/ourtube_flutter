import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/presentation/widgets/preview_thumbnail_video.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../history/data/models/history_model.dart';

class MyHistoryTile extends ConsumerWidget {
  final int index;
  final HistoryModel history;

  const MyHistoryTile({
    super.key,
    required this.index,
    required this.history,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRef = ref.watch(getVideoDetailsByIdProvider(history.videoId));
    final userRef = ref.watch(getUserDetailsByIdProvider(history.userId));

    return videoRef.when(
      data: (video) => Container(
        margin: EdgeInsets.only(
          left: index == 0 ? 18.0 : 0.0,
          right: index == 15 ? 18.0 : 0.0,
        ),
        child: InkWell(
          onTap: () {},
          onLongPress: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video thumbnail
                PreviewThumbnailVideo(
                  video: video,
                  screenType: ScreenType.history,
                ),
                const SizedBox(height: 8.0),

                // Video details and more button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video details
                    SizedBox(
                      width: 150.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Video's title
                          Text(
                            video.title,
                            style:
                                AppTextStyles.bodyLarge.copyWith(height: 1.1),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Channel's name
                          userRef.when(
                            data: (user) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  user.displayName,
                                  style: AppTextStyles.labelMedium
                                      .copyWith(color: context.ternaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            loading: () => const Loader(),
                            error: (error, stackTrace) => const SizedBox(),
                          ),
                        ],
                      ),
                    ),

                    // More button
                    MoreIconButton(
                      iconSize: 20.0,
                      padding: EdgeInsets.zero,
                      onTap: () {
                        ModalHelpers.showBottomSheetForMyVideosOptions(
                            context, video, ScreenType.history,
                            historyId: history.historyId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}
