import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/history/presentation/providers/history_provider.dart';
import '../../../features/video/data/models/video_model.dart';
import '../../../features/video/presentation/providers/video_provider.dart';
import '../../../features/video/presentation/widgets/duration_indicator.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/enums/screen_type.dart';
import '../../utils/helpers/modal_helpers.dart';
import '../../utils/helpers/navigation_helpers.dart';
import '../providers/firebase_provider.dart';
import '../styles/app_text_style.dart';
import 'loader.dart';
import 'more_icon_button.dart';

class ContentCard extends ConsumerWidget {
  final String? thumbnail;
  final String title;

  /// Optional channel name (used only if the data comes from YouTube API)
  final String? channelName;

  /// Optional user ID (used only if the data comes from Firebase)
  final String? userId;

  final ScreenType? screenType;
  final VideoModel? video;

  const ContentCard({
    super.key,
    this.thumbnail,
    required this.title,
    this.channelName,

    /// If `null`, data is assumed to be from YouTube API
    this.userId,
    this.screenType,
    this.video,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef =
        userId != null ? ref.watch(getUserDetailsByIdProvider(userId!)) : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            screenType == ScreenType.home ||
                    screenType == ScreenType.subscriptions
                ? _openVideoPlayerScreen(context, ref, userId!)
                : null;
          },
          child: SizedBox(
            child: Column(
              children: [
                // Thumbnail
                screenType == ScreenType.home ||
                        screenType == ScreenType.subscriptions
                    ? Stack(
                        children: [
                          _buildContentThumbnail(),

                          // Video's duration
                          DurationIndicator(
                            video: video!,
                            bottomPosition: 5.0,
                            rightPosition: 28.0,
                          ),
                        ],
                      )
                    : _buildContentThumbnail(),

                // Content details
                /// If [userId] is provided, fetch user data from Firebase, otherwise use [channelName]
                userId != null
                    ? userRef!.when(
                        data: (user) => _buildContentDetails(
                            context, user.displayName, user.photoUrl),
                        loading: () => const Loader(),
                        error: (Object error, StackTrace stackTrace) =>
                            const Loader(),
                      )
                    : _buildContentDetails(context, channelName!, null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the video thumbnail
  Widget _buildContentThumbnail() {
    return Container(
      width: double.infinity,
      height: 230.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: thumbnail == null || thumbnail!.isEmpty
              ? const AssetImage(AppAssets.imagePlaceholder)
              : NetworkImage(thumbnail!) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Builds the video details section including channel avatar, title, and channel name
  Widget _buildContentDetails(
      BuildContext context, String name, String? avatarUrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Channel's picture
          CircleAvatar(
            radius: 20.0,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          ),
          const SizedBox(width: 10.0),

          // Title and channel name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  name,
                  style: AppTextStyles.labelMedium
                      .copyWith(color: context.ternaryColor),
                ),
              ],
            ),
          ),

          // More button
          screenType == ScreenType.home ||
                  screenType == ScreenType.subscriptions
              ? MoreIconButton(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    ModalHelpers.showBottomSheetForMyVideosOptions(
                        context, video!, screenType!);
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _openVideoPlayerScreen(
      BuildContext context, WidgetRef ref, String userId) {
    final updateViewsCountRef = ref.read(updateViewsCountUseCaseProvider);
    final addToHistoryRef = ref.read(addToHistoryUseCaseProvider);
    final durationRef = ref.watch(durationWatchedProvider);

    NavigationHelpers.openBottomSheetForVideoPlayerScreen(
        context, video!, ref, userId, durationRef);
    updateViewsCountRef.execute(video!);
    addToHistoryRef.excute(video!, userId);
  }
}
