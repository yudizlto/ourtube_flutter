import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/enums/screen_type.dart';
import '../../data/models/video_model.dart';
import '../providers/state/video_notifier.dart';

class SetComment extends ConsumerWidget {
  final ScreenType screenType;
  final VideoModel? video;

  const SetComment({super.key, required this.screenType, this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    final notifier = screenType == ScreenType.editVideo
        ? ref.read(editVideoNotifierProvider(video!).notifier)
        : ref.read(createLongVideoNotifierProvider.notifier);

    final commentRef = screenType == ScreenType.editVideo
        ? ref.watch(editVideoNotifierProvider(video!)).commentsEnabled
        : ref.watch(createLongVideoNotifierProvider).commentsEnabled;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: localization.comments,
        showTitle: true,
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(localization.on),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<bool>(
                value: true,
                groupValue: commentRef,
                activeColor: context.activeColor,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return commentRef
                      ? context.activeColor
                      : AppColors.blackDark3;
                }),
                splashRadius: 20.0,
                onChanged: (value) {
                  screenType == ScreenType.editVideo
                      ? notifier.updateCommentsEnabled(value!)
                      : notifier.setCommentsEnabled(value!);
                },
              ),
              onTap: () {
                screenType == ScreenType.editVideo
                    ? notifier.updateCommentsEnabled(true)
                    : notifier.setCommentsEnabled(true);
              },
            ),
            ListTile(
              title: Text(localization.off),
              titleTextStyle: AppTextStyles.bodyLarge
                  .copyWith(color: context.secondaryColor),
              leading: Radio<bool>(
                value: false,
                groupValue: commentRef,
                activeColor: context.activeColor,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return commentRef
                      ? AppColors.blackDark3
                      : context.activeColor;
                }),
                splashRadius: 20.0,
                onChanged: (value) {
                  screenType == ScreenType.editVideo
                      ? notifier.updateCommentsEnabled(value!)
                      : notifier.setCommentsEnabled(value!);
                },
              ),
              onTap: () {
                screenType == ScreenType.editVideo
                    ? notifier.updateCommentsEnabled(false)
                    : notifier.setCommentsEnabled(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
