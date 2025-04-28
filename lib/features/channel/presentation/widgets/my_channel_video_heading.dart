import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../../core/presentation/widgets/top_action_button.dart';
import '../providers/my_channel_provider.dart';

class MyChannelVideoHeading extends ConsumerWidget {
  final AppLocalizations localization;

  const MyChannelVideoHeading({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedFilterProvider);

    const typeList = VideoType.values;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localization.your_videos, style: AppTextStyles.headlineLarge),

          // Action buttons
          Container(
            margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...typeList.map(
                  (type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TopActionButton(
                        isSelected: selectedType == type,
                        child: Text(
                          type.localizedDisplayName(context),
                          style: AppTextStyles.titleMedium.copyWith(
                              color: selectedType == type
                                  ? context.primaryColor
                                  : context.secondaryColor),
                        ),
                        onPressed: () {
                          /// Updates the selected category state when clicked.
                          final currentState = ref.read(selectedFilterProvider);
                          ref.read(selectedFilterProvider.notifier).state =
                              currentState == type ? null : type;
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
