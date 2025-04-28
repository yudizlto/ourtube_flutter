import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';

class EditPrivacySection extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final AppLocalizations localization;

  const EditPrivacySection({
    super.key,
    required this.value,
    required this.onChanged,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child:
                    Text(localization.privacy, style: AppTextStyles.bodyLarge),
              ),
              const SizedBox(height: 10.0),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.keep_my_subscriptions_private,
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: context.ternaryColor),
                      ),
                      Switch(value: value, onChanged: onChanged),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Warning section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.info_outline, size: 18.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  localization.channel_changes_dialog,
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: context.ternaryColor),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
