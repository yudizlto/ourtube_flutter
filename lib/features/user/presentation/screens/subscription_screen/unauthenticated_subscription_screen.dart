import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/notification_icon_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/presentation/widgets/main_app_bar.dart';
import '../../widgets/sign_in_for_content.dart';

class UnAuthenticatedSubscriptionScreen extends StatelessWidget {
  const UnAuthenticatedSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // App Bar
          const MainAppBar(
            actions: [NotificationIconButton(), SearchIconButton()],
          ),

          // Please Sign In For More Features
          SignInForContent(
            imagePath: AppAssets.folderIcon,
            title: localization.unauthenticatedSubscriptionTitle,
            subtitle: localization.unauthenticatedSubscriptionContent,
          ),
        ],
      ),
    );
  }
}
