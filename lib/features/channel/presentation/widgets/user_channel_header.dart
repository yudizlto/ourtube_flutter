import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/presentation/providers/subscription_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../screens/my_channel/more_info_screen.dart';

class UserChannelHeader extends ConsumerWidget {
  final UserModel user;
  final AppLocalizations localization;

  const UserChannelHeader({
    super.key,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRef = ref.watch(currentUserProvider);
    final currentUserId = currentUserRef.value!.userId;
    final isSubscribed = ref.watch(isSubscribedProvider(user.userId));

    /// Subscribes the current user to the displayed user's channel.
    ///
    /// This function performs the following steps:
    /// 1. Calls the `subscribeOtherChannelUseCase` to create a new subscription in Firestore.
    /// 2. Adds the `currentUserId` to the `subscribers` array of the target user.
    /// 3. Adds the `userId` (target user) to the `subscriptions` array of the current user.
    /// 4. Displays a success snackbar once the subscription is complete.
    Future<void> subscribeThisChannel() async {
      final subscribe = ref.read(subcribeOtherChannelUseCaseProvider);
      await subscribe.execute(user.userId, currentUserId).then((_) =>
          SnackbarHelpers.showCommonSnackBar(
              context, localization.subscription_added_message));
    }

    /// Unsubscribes the current user from the displayed user's channel.
    ///
    /// This function performs the following steps:
    /// 1. Calls the `unsubscribeChannelUseCase` to remove the subscription document from Firestore.
    /// 2. Removes the `currentUserId` from the target user's `subscribers` array.
    /// 3. Removes the `userId` (target user) from the current user's `subscriptions` array.
    /// 4. Refreshes the `currentUserProvider` to update the UI.
    /// 5. Displays a snackbar with an "Undo" option, allowing the user to resubscribe immediately.
    Future<void> unsubscribeThisChannel() async {
      final unsubscribe = ref.read(unsubscribeChannelProvider);
      await unsubscribe
          .execute(user.userId, currentUserId)
          .then((_) => ref.refresh(currentUserProvider))
          .then(
            (_) => SnackbarHelpers.showCommonSnackBar(
                context, localization.unsubscribed_message(user.displayName),
                action: SnackBarAction(
                  label: localization.undo_button,
                  textColor: context.activeColor,
                  onPressed: () => subscribeThisChannel(),
                )),
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Channel Banner
        user.bannerUrl.isEmpty
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: 100.0,
                margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(user.bannerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

        // Channel Info
        Container(
          margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Channel Profile Picture
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Channel's name
                        Text(
                          user.displayName,
                          style: AppTextStyles.headlineLarge
                              .copyWith(fontSize: 24.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),

                        // Channel's username
                        Text(
                          "@${user.username}",
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: context.ternaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Channel's subscribers count
                            Flexible(
                              child: Text(
                                localization.channelSubscribers(
                                    user.subscriptions.length),
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: context.ternaryColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Channel's videos count
                            Text(
                              " ⦁ ${user.videos.length} ${localization.videos}",
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: context.ternaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Channel Description
              GestureDetector(
                onTap: () => NavigationHelpers.navigateToScreen(
                    context, MoreInfoScreen(user: user)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        user.description.isEmpty
                            ? localization.more_about_channel
                            : user.description,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: context.ternaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "...${localization.more}",
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Subscribe or Unsubscribe Button
        isSubscribed.when(
          data: (isSubscribed) {
            /// Displays the Subscribe or Unsubscribe button depending on the user's subscription status.
            ///
            /// This uses the `AsyncValue<bool>` returned by the `isSubscribedProvider` to determine
            /// whether the current user is subscribed to the displayed user's channel.
            ///   - If `isSubscribed` is `true`, the button shows "Unsubscribe" with an icon and colors
            ///     indicating an active subscription.
            ///   - If `isSubscribed` is `false`, the button shows "Subscribe" with appropriate styling
            ///     to indicate the user is not currently subscribed.
            ///   - The `onPressed` handler toggles the subscription state:
            ///     - If already subscribed, it calls `unsubscribeThisChannel`.
            ///     - If not subscribed, it calls `subscribeThisChannel`.
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ShrinkingButton(
                icon: isSubscribed ? Icons.person_remove_outlined : null,
                text: isSubscribed
                    ? localization.unsubscribe
                    : localization.subscribe_button,
                textColor: isSubscribed
                    ? context.secondaryColor
                    : context.primaryColor,
                fontWeight: FontWeight.bold,
                buttonColor:
                    isSubscribed ? context.buttonColor : context.secondaryColor,
                onPressed: () {
                  isSubscribed
                      ? unsubscribeThisChannel()
                      : subscribeThisChannel();
                },
              ),
            );
          },
          loading: () => const Loader(),
          error: (error, stackTrace) => const SizedBox(),
        ),
      ],
    );
  }
}
