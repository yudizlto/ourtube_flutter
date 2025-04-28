import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/enums/content_category.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/widgets/top_action_button.dart';
import '../../../channel/presentation/screens/user_channel/users_channel_screen.dart';
import '../../data/models/user_model.dart';
import '../providers/subscription_provider.dart';
import '../screens/subscription_screen/all_my_subscription_screen.dart';

class SubsListHeader extends ConsumerWidget {
  final AppLocalizations localization;
  final String currentUserId;
  final UserModel user;

  const SubsListHeader({
    super.key,
    required this.localization,
    required this.currentUserId,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final displayedSubs = user.subscriptions.take(60).toList();

    const contentCategory = ContentCategory.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subscriptions List
        Stack(
          children: [
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: displayedSubs.length,
                itemBuilder: (context, index) {
                  final isLastItem = index == 59;
                  final rightMargin = isLastItem ? 95.0 : 12.0;

                  final userId = displayedSubs[index];
                  final userRef = ref.watch(getUserDetailsByIdProvider(userId));

                  return userRef.when(
                    data: (data) {
                      return InkWell(
                        onTap: () {
                          NavigationHelpers.navigateToScreen(
                              context, UsersChannelScreen(user: data));
                        },
                        child: Container(
                          width: 60.0,
                          margin: EdgeInsets.fromLTRB(
                              15.0, 12.0, rightMargin, 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Channel Avatar
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(data.photoUrl),
                              ),
                              const SizedBox(height: 10.0),

                              // Channel Name
                              Text(
                                data.displayName,
                                style: AppTextStyles.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Loader(),
                    error: (error, stackTrace) => const SizedBox(),
                  );
                },
              ),
            ),

            // 'All' Button
            Positioned(
              right: 0.0,
              child: Container(
                width: 70.0,
                height: 120.0,
                color: context.primaryColor,
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () => NavigationHelpers.navigateToScreen(
                        context, AllMySubscriptionScreen(user: user)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        localization.all_button,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: context.activeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Category buttons
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...contentCategory.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TopActionButton(
                      isSelected: selectedCategory == category,
                      child: Text(
                        category.displayName(context),
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 16.0,
                          color: selectedCategory == category
                              ? context.primaryColor
                              : context.secondaryColor,
                        ),
                      ),
                      onPressed: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
