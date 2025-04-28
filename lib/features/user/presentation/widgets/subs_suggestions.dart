import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../channel/presentation/screens/user_channel/users_channel_screen.dart';
import '../providers/user_provider.dart';

class SubSuggestions extends StatelessWidget {
  const SubSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              "Sports",
              style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10.0),
          Consumer(
            builder: (context, ref, child) {
              final allUsersRef = ref.watch(allUsersProvider);

              return allUsersRef.when(
                data: (users) => Column(
                  children: users.map((user) {
                    return InkWell(
                      onTap: () => NavigationHelpers.navigateToScreen(
                        context,
                        UsersChannelScreen(user: user),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                                backgroundImage: NetworkImage(user.photoUrl),
                                radius: 40.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName,
                                  style: AppTextStyles.bodyLarge,
                                ),
                                Text(
                                  "${user.subscribers.length} subscribers",
                                  style: AppTextStyles.bodyLarge
                                      .copyWith(color: context.ternaryColor),
                                ),
                                Text(
                                  "${user.videos.length} videos",
                                  style: AppTextStyles.bodyLarge
                                      .copyWith(color: context.ternaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const Loader(),
                error: (error, stack) => Text('Error: $error'),
              );
            },
          ),
        ],
      ),
    );
  }
}
