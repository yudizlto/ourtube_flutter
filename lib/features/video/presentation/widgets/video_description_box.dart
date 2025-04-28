import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';

class VideoDescriptionBox extends ConsumerWidget {
  final AppLocalizations localization;
  final VideoModel video;

  const VideoDescriptionBox({
    super.key,
    required this.localization,
    required this.video,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedDescriptionProvider);
    final isExpandedNotifier = ref.read(isExpandedDescriptionProvider.notifier);

    final boxColor = context.secondarySurfaceColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 30.0),
      child: Material(
        color: boxColor,
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          onTap: () => isExpandedNotifier.state = !isExpanded,
          borderRadius: BorderRadius.circular(15.0),
          splashColor: AppColors.blackDark4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  video.description,
                  style: AppTextStyles.bodyLarge,
                  maxLines: isExpanded ? null : 7,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.fade,
                ),
              ),

              /// Displays a "more" button if the description is longer than 360 characters
              /// and the box is not expanded
              if (video.description.length > 360)
                isExpanded
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => isExpandedNotifier.state = !isExpanded,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                            child: Text(
                              localization.more,
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                        ),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
