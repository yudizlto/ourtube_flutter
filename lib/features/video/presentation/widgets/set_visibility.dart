import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';
import 'visibility_option.dart';

class SetVisibility extends ConsumerWidget {
  final ScreenType screenType;
  final VideoModel? video;

  const SetVisibility({super.key, required this.screenType, this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final notifier = screenType == ScreenType.editVideo
        ? ref.read(editVideoNotifierProvider(video!).notifier)
        : ref.read(createLongVideoNotifierProvider.notifier);

    final visibilityRef = screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(video!)).visibilityType
        : ref.watch(createLongVideoNotifierProvider).visibilityType;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: localization.set_visibility,
        showTitle: true,
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 30.0),
              child: Text(
                localization.publish_now,
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              ),
            ),
            VisibilityOption(
              title: localization.public,
              subtitle: localization.public_description,
              value: AppStrings.public,
              visibilityRef: visibilityRef,
              onChanged: (value) {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(value)
                    : notifier.setVisibility(value);
              },
              onTap: () {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(AppStrings.public)
                    : notifier.setVisibility(AppStrings.public);
              },
            ),
            VisibilityOption(
              title: localization.unlisted,
              subtitle: localization.unlisted_description,
              value: AppStrings.unlisted,
              visibilityRef: visibilityRef,
              onChanged: (value) {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(value)
                    : notifier.setVisibility(value);
              },
              onTap: () {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(AppStrings.unlisted)
                    : notifier.setVisibility(AppStrings.unlisted);
              },
            ),
            VisibilityOption(
              title: localization.private,
              subtitle: localization.private_description,
              value: AppStrings.private,
              visibilityRef: visibilityRef,
              onChanged: (value) {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(value)
                    : notifier.setVisibility(value);
              },
              onTap: () {
                screenType == ScreenType.editVideo
                    ? notifier.updateVisibility(AppStrings.private)
                    : notifier.setVisibility(AppStrings.private);
              },
            ),
          ],
        ),
      ),
    );
  }
}
