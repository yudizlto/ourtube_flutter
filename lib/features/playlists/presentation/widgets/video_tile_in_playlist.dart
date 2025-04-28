import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../video/presentation/widgets/duration_indicator.dart';
import '../../data/models/playlist_model.dart';

class VideoTileInPlaylist extends ConsumerWidget {
  final String videoId;
  final String userId;
  final PlaylistModel? playlist;
  final ScreenType? screenType;

  const VideoTileInPlaylist({
    super.key,
    required this.videoId,
    required this.userId,
    this.playlist,
    this.screenType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRef = ref.watch(getVideoDetailsByIdProvider(videoId));
    final userRef = ref.watch(getUserDetailsByIdProvider(userId));

    final localization = AppLocalizations.of(context)!;

    return videoRef.when(
      data: (video) {
        final formattedDate = StringHelpers.timeAgo(context, video.uploadedAt);
        final formattedViewCount = StringHelpers.formattedViewCount(
            ref, video.viewsCount, localization);

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video thumbnail
              Stack(
                children: [
                  Container(
                    width: 158.0,
                    height: 95.0,
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: AppColors.blackDark5,
                      image: DecorationImage(
                        image: video.thumbnailUrl.isEmpty
                            ? const AssetImage(AppAssets.banner)
                            : NetworkImage(video.thumbnailUrl)
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Video's duration
                  DurationIndicator(
                    video: video,
                    bottomPosition: 5.0,
                    rightPosition: 28.0,
                  ),
                ],
              ),

              // Video details
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video title
                      Text(
                        video.title,
                        style: AppTextStyles.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),

                      // Channel's name
                      userRef.when(
                        data: (user) => Text(
                          user.displayName,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        loading: () => const Loader(),
                        error: (error, stackTrace) => const SizedBox(),
                      ),

                      // Video views and upload date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Video views
                          Text(
                            formattedViewCount,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: context.ternaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Video upload date
                          Flexible(
                            child: Text(
                              "  ⦁  $formattedDate",
                              style: AppTextStyles.labelLarge
                                  .copyWith(color: context.ternaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // More button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ModalHelpers.showBottomSheetForPlaylistOption(
                        context, playlist, screenType,
                        video: video);
                  },
                  borderRadius: BorderRadius.circular(30.0),
                  child: Icon(
                    Icons.more_vert,
                    color: context.secondaryColor,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}
