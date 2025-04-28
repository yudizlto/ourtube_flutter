import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../widgets/empty_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: Text(localization.notifications),
        backgroundColor: context.primaryColor,
        leading: const CustomBackButton(),
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      // body: const EmptyNotification(),
      body: RefreshIndicator(
          onRefresh: () => Future<void>.delayed(const Duration(seconds: 2)),
          color: context.secondaryColor,
          child: const EmptyNotification()),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
