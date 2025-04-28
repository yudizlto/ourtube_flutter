import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/presentation/widgets/main_app_bar.dart';
import '../providers/home_provider.dart';
import '../widgets/category_buttons.dart';
import '../widgets/content_list.dart';
import '../widgets/home_drawer.dart';

class AuthenticatedHomeScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthenticatedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const MainAppBar(
        actions: [NotificationIconButton(), SearchIconButton()],
      ),
      drawer: const HomeDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        color: context.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Category Buttons
            CategoryButtons(scaffoldKey: _scaffoldKey),

            // Content List
            const Expanded(child: ContentList()),
          ],
        ),
      ),
    );
  }

  /// Handles the pull-to-refresh action
  Future<void> _onRefresh(WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 2)).then((_) {
      ref.invalidate(getAllVideosFromFirestore);
      ref.invalidate(getShortsVideos);
    });
  }
}
