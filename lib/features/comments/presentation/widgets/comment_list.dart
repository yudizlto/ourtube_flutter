import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/models/comment_model.dart';
import '../providers/comment_provider.dart';

class CommentList extends ConsumerWidget {
  final CommentModel comment;

  const CommentList({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataRef = ref.watch(getUserDetailsProvider(comment.commentId));
    final currentUserId = ref.watch(currentUserProvider).value!.userId;
    final isExpanded = ref.watch(isExpandedCommentProvider);

    final formattedDate = StringHelpers.timeAgo(context, comment.createdAt);

    return userDataRef.when(
      data: (user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Comments
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Material(
                  color: AppColors.white,
                  child: InkWell(
                    onTap: () {},
                    splashColor: AppColors.blackDark4,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User's avatar
                              CircleAvatar(
                                radius: 14.0,
                                backgroundImage: NetworkImage(user!.photoUrl),
                              ),

                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // User's info
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (comment.userId == currentUserId)
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 5.0,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: AppColors.blackDark1,
                                                ),
                                                child: Text(
                                                  "@${user.username}",
                                                  style:
                                                      AppTextStyles.bodyMedium,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          else
                                            Text(
                                              "@${user.username}",
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                      color:
                                                          context.ternaryColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          Text(
                                            "  ⦁ $formattedDate",
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                    color:
                                                        context.ternaryColor),
                                          ),
                                        ],
                                      ),

                                      // Comment text
                                      Text(
                                        comment.text,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                                color: context.ternaryColor),
                                        maxLines: isExpanded ||
                                                comment.text.length <= 100
                                            ? null
                                            : 2,
                                        textAlign: TextAlign.start,
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                      ),

                                      // Read more button
                                      if (comment.text.length > 100 &&
                                          !isExpanded)
                                        InkWell(
                                          onTap: () {
                                            ref
                                                .read(isExpandedCommentProvider
                                                    .notifier)
                                                .state = !isExpanded;
                                          },
                                          child: Text(
                                            AppStrings.readMore,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                    color: context.ternaryColor)
                                                .copyWith(
                                                    color:
                                                        AppColors.blackDark2),
                                          ),
                                        ),

                                      // Buttons: Like comment, Dislike comment & Reply comment
                                      Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: [
                                            // Like comment button
                                            InkWell(
                                              onTap: () {},
                                              customBorder:
                                                  const CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  AppAssets.likeIcon,
                                                  width: 20.0,
                                                ),
                                              ),
                                            ),

                                            // Like comment count
                                            comment.likesCount == 0
                                                ? const SizedBox()
                                                : Text(
                                                    "${comment.likesCount}",
                                                    style: AppTextStyles
                                                        .bodyMedium
                                                        .copyWith(
                                                            color: AppColors
                                                                .blackDark1),
                                                  ),
                                            const SizedBox(width: 10.0),

                                            // Dislike comment button
                                            InkWell(
                                              onTap: () {},
                                              customBorder:
                                                  const CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  AppAssets.dislikeIcon,
                                                  width: 20.0,
                                                ),
                                              ),
                                            ),

                                            // Reply comment button
                                            const SizedBox(width: 20.0),
                                            InkWell(
                                              onTap: () {},
                                              customBorder:
                                                  const CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  AppAssets.commentIcon,
                                                  width: 24.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Button for more options
                              InkWell(
                                onTap: () => ModalHelpers
                                    .showBottomSheetForCommentOption(context),
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.more_vert_outlined,
                                    color: AppColors.blackDark3,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // If the comment has replies show this widget
          comment.repliesCount == 0
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(left: 35.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 15.0),
                        child: Text(
                          "${comment.repliesCount} replies",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}
