import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/circular_action_button.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/models/video_model.dart';
import '../providers/video_provider.dart';
import 'body_section_video_details_bottom_sheet.dart';

class VideoDetailsBottomSheet extends ConsumerWidget {
  final VideoModel video;
  final UserModel user;
  final AppLocalizations localization;

  const VideoDetailsBottomSheet({
    super.key,
    required this.video,
    required this.user,
    required this.localization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandleBottomSheet(),

          // Header section: Description & Close button
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        localization.summary_label,
                        style: AppTextStyles.headlineSmall
                            .copyWith(fontSize: 22.0),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CircularActionButton(
                          onTap: () {
                            ref
                                .read(isExpandedDescriptionProvider.notifier)
                                .state = false;
                            Navigator.pop(context);
                          },
                          icon: Icons.close,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: context.ternaryColor),
              ],
            ),
          ),

          // Body section: Video details, Channel details, etc
          BodySectionVideoDetailsBottomSheet(
            video: video,
            user: user,
            localization: localization,
          ),
        ],
      ),
    );
  }
}
