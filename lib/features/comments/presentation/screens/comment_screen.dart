import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../video/data/models/video_model.dart';
import '../providers/comment_provider.dart';
import '../widgets/add_comment_section.dart';
import '../widgets/comment_list.dart';
import '../widgets/empty_comment.dart';

class CommentScreen extends ConsumerWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const CommentScreen({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentStream = ref.watch(commentListStreamProvider(video.videoId));
    final isExpandedNotifier = ref.watch(isExpandedCommentProvider.notifier);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandleBottomSheet(),

              // Header section: Comments & Close button
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            localization.comments,
                            style: AppTextStyles.headlineSmall
                                .copyWith(fontSize: 22.0),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: CircularActionButton(
                              icon: Icons.close,
                              onTap: () {
                                isExpandedNotifier.state = false;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: context.ternaryColor),
                  ],
                ),
              ),

              // Body section: Comments list
              video.commentsCount == 0
                  ? EmptyComment(localization: localization)
                  : commentStream.when(
                      data: (comment) => Flexible(
                        child: ListView.builder(
                          itemCount: comment.length,
                          itemBuilder: (context, index) {
                            return CommentList(comment: comment[index]);
                          },
                        ),
                      ),
                      error: (error, stackTrace) => const SizedBox(),
                      loading: () => const Loader(),
                    ),
              const Spacer(),

              // Footer section: Textfield for adding a comment
              AddCommentSection(video: video, localization: localization),
            ],
          ),
        ),
      ),
    );
  }
}
