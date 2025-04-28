import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../history/presentation/providers/history_provider.dart';
import '../../../../playlists/presentation/providers/playlist_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/action_bar.dart';
import '../../widgets/action_button.dart';
import '../../widgets/history_section.dart';
import '../../widgets/playlist_section.dart';
import '../../widgets/user_info.dart';
import '../../widgets/user_menu_section.dart';

class AuthenticatedLibraryScreen extends ConsumerWidget {
  const AuthenticatedLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(currentUserProvider);
    final userIdRef = userRef.value!.userId;
    final historyRef = ref.watch(myLatestVideoHistoryProvider(userIdRef));

    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(ref, userIdRef),
        color: context.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ActionBar(),
            Expanded(
              child: ListView(
                children: [
                  // User Info Section
                  UserInfo(user: userRef.value!, localization: localization),
                  ActionButton(localization: localization),

                  // History Section
                  historyRef.value == null || historyRef.value!.isEmpty
                      ? const SizedBox()
                      : HistorySection(localization: localization),

                  // Playlist Section
                  PlaylistSection(localization: localization),

                  // User Menu or Account Section
                  UserMenuSection(localization: localization),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Handles the pull-to-refresh action
/// Refreshes the latest video watch history and the current user data
/// to ensure that the screen reflects the most up-to-date information
Future<void> _onRefresh(WidgetRef ref, String userId) async {
  await Future.delayed(const Duration(seconds: 2));
  ref.invalidate(currentUserProvider);
  ref.invalidate(myLatestVideoHistoryProvider(userId));
  ref.invalidate(fetchAllMyPlaylistProvider(userId));
  ref.invalidate(fetchMyLikesProvider(userId));
}
