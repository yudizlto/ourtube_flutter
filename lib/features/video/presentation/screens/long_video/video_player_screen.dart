import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../user/presentation/providers/user_provider.dart';
import '../../../data/models/video_model.dart';
import '../../providers/video_provider.dart';
import '../../widgets/video_player_section.dart';
import '../../widgets/video_suggestion_section.dart';
import '../../../../comments/presentation/widgets/comment_section.dart';
import '../../widgets/video_action_button.dart';
import '../../widgets/video_header_section.dart';

class VideoPlayerScreen extends ConsumerWidget {
  final VideoModel video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.read(currentUserProvider).value!.userId;
    final videoSuggestions = ref.watch(videoSuggestionsProvider(currentUserId));

    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player with control buttons
            VideoPlayerSection(video: video),

            // Video details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Video header: title, views, button for more info, etc
                    VideoHeaderSection(
                      video: video,
                      localization: localization,
                    ),

                    // Action buttons: like, dislike, share, save, etc
                    VideoActionButton(video: video, localization: localization),

                    // Comments section
                    CommentSection(video: video, localization: localization),

                    // Video suggestions list
                    videoSuggestions.when(
                      data: (videos) {
                        return Column(
                          children: videos
                              .map((video) => VideoSuggestionSection(
                                    video: video,
                                    localization: localization,
                                  ))
                              .toList(),
                        );
                      },
                      loading: () => const Loader(),
                      error: (error, stackTrace) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
