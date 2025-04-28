import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/more_icon_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';

class OverlayShortsPlayer extends ConsumerWidget {
  final Function() handlePlayPauseButton;
  final bool isPlaying;
  final bool showControls;
  final VideoModel video;

  const OverlayShortsPlayer({
    super.key,
    required this.handlePlayPauseButton,
    required this.isPlaying,
    required this.showControls,
    required this.video,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataRef = ref.watch(getUserDetailsProvider(video.videoId));

    return Stack(
      children: [
        // Black container for the header
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 75.0,
            color: AppColors.black,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: CustomBackButton(
                      onPressed: () => _handleBackButton(context),
                    ),
                  ),

                  // More button
                  Material(
                    color: Colors.transparent,
                    child: MoreIconButton(
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Black container for the channel's details
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(height: 60.0, color: AppColors.black),
        ),

        // Channel's details
        Positioned(
          bottom: 30.0,
          child: Container(
            width: 380.0,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel avatar and username
                userDataRef.when(
                  data: (user) => Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: user!.photoUrl.isEmpty
                            ? const AssetImage(AppAssets.profileIcon)
                            : NetworkImage(user.photoUrl)
                                as ImageProvider<Object>,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          "@${user.username}",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  error: (error, stackTrace) => const SizedBox(),
                  loading: () => const Loader(),
                ),

                const SizedBox(height: 15.0),

                // Shorts' title
                Text(
                  video.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        // Button layout
        Positioned(
          bottom: 250.0,
          right: 2.0,
          child: _buildButtonLayout(context),
        ),

        // Play/Pause button
        Center(
          child: AnimatedOpacity(
            opacity: showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
              child: InkWell(
                onTap: handlePlayPauseButton,
                customBorder: const CircleBorder(),
                splashColor: AppColors.lightGrey2.withOpacity(0.2),
                child: Container(
                  width: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.black.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      isPlaying ? AppAssets.pauseIcon : AppAssets.playIcon,
                      width: 60.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the button layout for the overlay player
  Widget _buildButtonLayout(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SizedBox(
      child: Column(
        children: [
          // Like button
          Material(
            color: Colors.transparent,
            child: CircularActionButton(
              icon: Icons.thumb_up_alt_outlined,
              iconSize: 30.0,
              color: AppColors.white,
              padding: const EdgeInsets.all(15.0),
              titleButton: video.likesCount.toString(),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 5.0),

          // Dislike button
          Column(
            children: [
              Material(
                color: Colors.transparent,
                child: CircularActionButton(
                  icon: Icons.thumb_down_alt_outlined,
                  iconSize: 30.0,
                  color: AppColors.white,
                  padding: const EdgeInsets.all(12.0),
                  onTap: () {},
                ),
              ),
              Text(
                localization.dislike_label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),

          // Comment button
          Material(
            color: Colors.transparent,
            child: CircularActionButton(
              icon: Icons.comment_outlined,
              iconSize: 30.0,
              color: AppColors.white,
              padding: const EdgeInsets.all(15.0),
              titleButton: video.commentsCount.toString(),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }

  /// Function for handle back button
  void _handleBackButton(BuildContext context) {
    NavigationHelpers.navigateWithRemoveUntil(context, const HomeScreen());
  }
}
