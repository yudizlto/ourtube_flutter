import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';
import 'audience_option.dart';

class SetAudience extends ConsumerWidget {
  final ScreenType screenType;
  final VideoModel? video;

  const SetAudience({super.key, required this.screenType, this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final notifier = screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(video!).notifier)
        : ref.watch(createLongVideoNotifierProvider.notifier);

    final audienceRef = screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(video!)).audienceRestricted
        : ref.watch(createLongVideoNotifierProvider).audienceRestricted;

    final ageRef = screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(video!)).ageRestricted
        : ref.watch(createLongVideoNotifierProvider).ageRestricted;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: localization.select_audience,
        showTitle: true,
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select audience restriction
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
                    child: Text(
                      localization.this_video_is_set_to,
                      style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
                    ),
                  ),
                  AudienceOption(
                    title: localization.yes_its_made_for_kids,
                    value: true,
                    audienceRef: audienceRef,
                    onChanged: (value) {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAudienceRestricted(true)
                          : notifier.setAudienceRestricted(true);
                    },
                    onTap: () {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAudienceRestricted(true)
                          : notifier.setAudienceRestricted(true);
                    },
                  ),
                  AudienceOption(
                    title: localization.no_its_not_made_for_kids,
                    value: false,
                    audienceRef: audienceRef,
                    onChanged: (value) {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAudienceRestricted(false)
                          : notifier.setAudienceRestricted(false);
                    },
                    onTap: () {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAudienceRestricted(false)
                          : notifier.setAudienceRestricted(false);
                    },
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.blackDark4),

            // Select age restriction
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 20.0),
                    child: Text(
                      localization.age_restriction,
                      style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: Text(
                      localization.age_restriction_question,
                      style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
                    ),
                  ),
                  AudienceOption(
                    title: localization.yes_restrict_to_adults,
                    value: true,
                    audienceRef: ageRef,
                    onChanged: (value) {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAgeRestricted(value)
                          : notifier.setAgeRestricted(value);
                    },
                    onTap: () {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAgeRestricted(true)
                          : notifier.setAgeRestricted(true);
                    },
                  ),
                  AudienceOption(
                    title: localization.no_restrict_to_adults,
                    value: false,
                    audienceRef: ageRef,
                    onChanged: (value) {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAgeRestricted(value)
                          : notifier.setAgeRestricted(value);
                    },
                    onTap: () {
                      screenType == ScreenType.editVideo
                          ? notifier.updateAgeRestricted(false)
                          : notifier.setAgeRestricted(false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
