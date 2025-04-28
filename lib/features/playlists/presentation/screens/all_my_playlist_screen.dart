import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/playlist_provider.dart';
import '../widgets/playlist_horizontal_tile.dart';

class AllMyPlaylistScreen extends ConsumerStatefulWidget {
  const AllMyPlaylistScreen({super.key});

  @override
  ConsumerState<AllMyPlaylistScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<AllMyPlaylistScreen> {
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

  @override
  Widget build(BuildContext context) {
    final userId = ref.read(currentUserProvider).value!.userId;
    final playlistList = ref.watch(fetchAllMyPlaylistProvider(userId));

    final buttonColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightGrey2
        : AppColors.blackDark1;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: AppStrings.playlists,
        showTitle: _showTitle,
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(ref),
          color: context.secondaryColor,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist title section
                const Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 10.0),
                  child: Text(
                    AppStrings.playlists,
                    style: AppTextStyles.headlineLarge,
                  ),
                ),

                // Vertical list of my playlists
                playlistList.when(
                  data: (data) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        /// Includes "Liked Videos" and "Create New Playlist"
                        itemCount: data.length + 2,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            /// Add "Liked Videos" section at the top
                            return PlaylistHorizontalTile(
                              playlistType: "likedVideos",
                              userId: userId,
                            );
                          } else if (index == data.length + 1) {
                            /// Add "Create New Playlist" button at the bottom
                            return ShrinkingButton(
                              text: AppStrings.createNewPlaylist,
                              buttonColor: buttonColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              onPressed: () {
                                ModalHelpers.showBottomSheetForCreatePlaylist(
                                    context);
                              },
                            );
                          } else {
                            /// Display individual playlists
                            final playlist = data[index - 1];
                            return PlaylistHorizontalTile(
                              playlistType: "playlist",
                              playlist: playlist,
                              userId: userId,
                            );
                          }
                        },
                      ),
                    );
                  },
                  loading: () => const Loader(),
                  error: (error, stackTrace) => const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Handles the pull-to-refresh action
Future<void> _onRefresh(WidgetRef ref) async {
  final userIdRef = ref.read(currentUserProvider).value!.userId;
  await Future.delayed(const Duration(seconds: 2)).then((_) {
    ref.invalidate(fetchAllMyPlaylistProvider(userIdRef));
    ref.invalidate(fetchMyLikesProvider(userIdRef));
  });
}
