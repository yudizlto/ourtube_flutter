import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/main_app_bar.dart';
import '../../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/my_subscription.dart';
import '../../widgets/no_subscription.dart';

class AuthenticatedSubscriptionScreen extends ConsumerWidget {
  const AuthenticatedSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserRef = ref.read(currentUserProvider);
    final userIdRef = currentUserRef.value!.userId;

    return RefreshIndicator(
      color: context.secondaryColor,
      onRefresh: () => _onRefresh(ref, userIdRef),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            const MainAppBar(
              actions: [NotificationIconButton(), SearchIconButton()],
            ),

            //
            Container(
              child: currentUserRef.value!.subscriptions.isEmpty
                  ? const NoSubscription()
                  : MySubscription(
                      currentUserId: userIdRef,
                      user: currentUserRef.value!,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the pull-to-refresh action
  Future<void> _onRefresh(WidgetRef ref, String currentUserId) async {
    await Future.delayed(const Duration(seconds: 2));
    ref.invalidate(currentUserProvider);
    ref.invalidate(mySubscriptionsListProvider(currentUserId));
    ref.invalidate(getMySubsContentsProvider);
  }
}
