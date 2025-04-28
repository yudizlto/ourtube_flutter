import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/playlist_model.dart';
import '../providers/playlist_provider.dart';
import '../widgets/empty_playlist.dart';
import '../widgets/playlist_hero_with_blur_overlay.dart';
import '../widgets/video_tile_in_playlist.dart';

class PlaylistScreen extends ConsumerWidget {
  final PlaylistModel? playlist;
  final String? playlistType;
  final String? userId;

  const PlaylistScreen({
    super.key,
    this.playlist,
    this.playlistType,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(fetchMyLikesProvider(userId!));

    return Scaffold(
      appBar: const CustomSliverAppBar(
        title: null,
        actions: [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(ref),
          color: context.secondaryColor,
          child: playlistType == "likedVideos"
              ? likes.when(
                  data: (like) {
                    if (like.isEmpty) {
                      return const EmptyPlaylist(playlistType: "likedVideos");
                    }

                    final lastVideoLiked = like.first;
                    final videoId = lastVideoLiked.videoId;
                    final userId = lastVideoLiked.userId;

                    return _buildPlaylistContent(
                      context,
                      videoId: videoId,
                      userId: userId,
                      items: like,
                      itemBuilder: (context, index) {
                        final likes = like[index];
                        return VideoTileInPlaylist(
                          videoId: likes.videoId,
                          userId: likes.userId,
                          screenType: ScreenType.likedPlaylist,
                        );
                      },
                    );
                  },
                  loading: () => const Loader(),
                  error: (error, stackTrace) => const SizedBox(),
                )
              : playlist == null || playlist!.videos.isEmpty
                  ? EmptyPlaylist(playlist: playlist!, playlistType: "playlist")
                  : _buildPlaylistContent(
                      context,
                      videoId: playlist!.videos.first,
                      userId: playlist!.userId,
                      items: playlist!.videos,
                      itemBuilder: (context, index) {
                        final videoId = playlist!.videos[index];

                        return VideoTileInPlaylist(
                          videoId: videoId,
                          userId: playlist!.userId,
                          playlist: playlist,
                          screenType: ScreenType.insidePlaylist,
                        );
                      },
                    ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  /// Reusable Playlist Content Builder
  Widget _buildPlaylistContent(
    BuildContext context, {
    required String videoId,
    required String userId,
    required List items,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaylistHeroWithBlurOverlay(
            videoId: videoId,
            userId: userId,
            playlistType: playlistType,
            playlist: playlist,
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the pull-to-refresh action
  Future<void> _onRefresh(WidgetRef ref) async {
    final userIdRef = ref.watch(currentUserProvider).value!.userId;
    await Future.delayed(const Duration(seconds: 2)).then((_) {
      ref.invalidate(fetchAllMyPlaylistProvider(userIdRef));
      ref.invalidate(fetchMyLikesProvider(userIdRef));
    });
  }
}
