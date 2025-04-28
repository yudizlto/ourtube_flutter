import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/constants/enums/video_type.dart';
import '../../../../home/presentation/widgets/empty_content_message.dart';
import '../../../../user/presentation/providers/user_provider.dart';
import '../../providers/my_channel_provider.dart';
import '../../widgets/my_channel_video_heading.dart';
import '../../widgets/my_channel_videos.dart';

class MyVideoScreen extends ConsumerStatefulWidget {
  const MyVideoScreen({super.key});

  @override
  ConsumerState<MyVideoScreen> createState() => _MyVideoScreenState();
}

class _MyVideoScreenState extends ConsumerState<MyVideoScreen> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      /// Update visibility based on scroll position
      if (_scrollController.offset > 100.0 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 100.0 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Function to handle refresh
  /// Refreshes the latest video
  Future<void> _onRefresh() async {
    final userRef = ref.watch(currentUserProvider);
    final userId = userRef.value!.userId;
    await Future.delayed(const Duration(seconds: 2)).then((_) {
      ref.invalidate(latestVideosProvider(userId));
    });
  }

  /// Back button handler
  /// Pops the current screen and clears any selected video type filter
  void _backButtonPressed() {
    Navigator.pop(context);
    ref.read(selectedFilterProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final userRef = ref.watch(currentUserProvider);
    final videoRef = ref.watch(latestVideosProvider(userRef.value!.userId));

    final selectedType = ref.watch(selectedFilterProvider);

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: localization.your_videos,
        showTitle: _showTitle,
        actions: const [SearchIconButton(), MenuButton()],
        leading:
            CustomBackButton(iconSize: 24.0, onPressed: _backButtonPressed),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: context.secondaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading and action buttons
                MyChannelVideoHeading(localization: localization),

                // List of videos
                videoRef.when(
                  data: (videos) {
                    /// Filter out videos with type 'Long'
                    final longVids =
                        videos.where((e) => e.type == AppStrings.long).toList();

                    /// Filter out videos with type 'Shorts'
                    final shorts = videos
                        .where((e) => e.type == AppStrings.shorts)
                        .toList();

                    // Display videos based on selected filter
                    switch (selectedType) {
                      case null:

                        /// Show all videos
                        return MyChannelVideos(videosList: videos);
                      case VideoType.long:

                        /// Show only long-form videos
                        return MyChannelVideos(videosList: longVids);
                      case VideoType.short:

                        /// Show only short-form (shorts) videos
                        return MyChannelVideos(videosList: shorts);
                      default:

                        /// Fallback empty message
                        return EmptyContentMessage(
                          imagePath: AppAssets.creativeIcon,
                          message: localization.share_your_videos_with_anyone,
                        );
                    }
                  },
                  loading: () => const Loader(),
                  error: (error, stack) => Center(child: Text("Error: $error")),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
