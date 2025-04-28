import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.notificationIcon,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
          color: context.ternaryColor,
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: Column(
              children: [
                Text(
                  localization.your_notifications_live_here,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 20.0),
                ),
                const SizedBox(height: 15.0),
                Text(
                  localization.subscribe_to_favorite_channels,
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: context.ternaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
