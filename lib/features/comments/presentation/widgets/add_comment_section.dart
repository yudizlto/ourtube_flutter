import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../data/models/comment_model.dart';
import '../providers/comment_provider.dart';

class AddCommentSection extends ConsumerStatefulWidget {
  final VideoModel video;
  final AppLocalizations localization;

  const AddCommentSection({
    super.key,
    required this.video,
    required this.localization,
  });

  @override
  ConsumerState<AddCommentSection> createState() => _AddCommentSectionState();
}

class _AddCommentSectionState extends ConsumerState<AddCommentSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Function to create a new comment and upload it to the database
  Future<void> _createComment() async {
    final firebaseRef = ref.read(firebaseFirestoreProvider);
    final userRef = ref.watch(currentUserProvider);
    final userId = userRef.value!.userId;
    final videoId = widget.video.videoId;
    final commentId = firebaseRef.collection("comments").doc().id;

    final comment = CommentModel(
      commentId: commentId,
      videoId: videoId,
      userId: userId,
      text: _controller.text,
      likesCount: 0,
      dislikesCount: 0,
      repliesCount: 0,
      createdAt: DateTime.now(),
      isEdited: false,
    );
    final uploadCommentUseCase = ref.read(createCommentUseCaseProvider);
    await uploadCommentUseCase.call(comment, widget.video, videoId, userId);
  }

  /// Function to handle the comment upload process
  Future<void> _handleUploadComment() async {
    await _createComment().then((value) {
      _controller.clear();
      SnackbarHelpers.showCommonSnackBar(
          context, widget.localization.comment_added);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(currentUserProvider);

    return Container(
      height: 60.0,
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: context.primaryColor,
        border: Border(
          top: BorderSide(color: context.ternaryColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(userRef.value!.photoUrl),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.localization.comment_placeholder,
                filled: true,
                fillColor: context.secondarySurfaceColor,
                contentPadding: const EdgeInsets.only(top: 10.0, left: 15.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.secondaryColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Material(
            color: Colors.transparent,
            child: CircularActionButton(
              onTap: () {
                _handleUploadComment();
              },
              padding: const EdgeInsets.all(8.0),
              imagePath: AppAssets.sendIcon,
            ),
          ),
        ],
      ),
    );
  }
}
