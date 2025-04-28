import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/video/data/models/video_model.dart';
import '../../../features/video/presentation/providers/state/video_notifier.dart';
import '../../../features/video/presentation/providers/video_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../../presentation/styles/app_text_style.dart';

class DialogHelpers {
  static Future<bool?> showDiscardChangesDialog({
    required BuildContext context,
    String? title,
    String? content,
    String? cancelTitle,
    String? titleButton,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onConfirm,
  }) {
    final localization = AppLocalizations.of(context)!;

    final titleButtonColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.blue
        : AppColors.white;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? localization.discard_changes,
            maxLines: maxLines,
            overflow: overflow,
          ),
          titleTextStyle:
              AppTextStyles.titleLarge.copyWith(color: context.secondaryColor),
          content: content != null ? Text(content) : const SizedBox(),
          contentTextStyle: AppTextStyles.bodyLarge
              .copyWith(color: context.ternaryColor, fontSize: 18.0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0.0,
          actions: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context, false),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                child: Text(
                  cancelTitle ?? localization.cancel,
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: titleButtonColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            InkWell(
              onTap: onConfirm ?? () => Navigator.pop(context, true),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                child: Text(
                  titleButton ?? localization.discard,
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: titleButtonColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showDiscardUploadVideoDialog(
      BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return showDiscardChangesDialog(
      context: context,
      content: localization.discard_changes_description,
      onConfirm: () {
        Navigator.pop(context, true);
        Navigator.pop(context, true);

        /// reset state
        final videoNotifier =
            ref.read(createLongVideoNotifierProvider.notifier);
        ref.read(titleErrorProvider.notifier).state = null;
        ref.read(descriptionErrorProvider.notifier).state = null;

        videoNotifier.reset(null, false);
      },
    );
  }

  static Future<bool?> showDiscardEditVideoDialog(
      BuildContext context, WidgetRef ref, VideoModel video) {
    final localization = AppLocalizations.of(context)!;

    return showDiscardChangesDialog(
      context: context,
      content: localization.discard_changes_description,
      onConfirm: () {
        Navigator.pop(context, true);
        Navigator.pop(context, true);

        /// reset state
        final videoNotifier =
            ref.read(editVideoNotifierProvider(video).notifier);
        ref.read(titleErrorProvider.notifier).state = null;
        ref.read(descriptionErrorProvider.notifier).state = null;

        videoNotifier.reset(video, true);
      },
    );
  }

  static Future<bool?> showDiscardCommentChangesDialog(BuildContext context) {
    return showDiscardChangesDialog(
      context: context,
      title: AppStrings.deleteComment,
      content: AppStrings.deleteYourCommentPermanently,
      titleButton: AppStrings.delete,
    );
  }

  static Future<bool?> showSimpleDiscardChangesDialog(BuildContext context) {
    return showDiscardChangesDialog(
      context: context,
      title: AppStrings.discardEdits,
      content: null,
      cancelTitle: AppStrings.keepWriting,
    );
  }

  static Future<bool?> showDialogDeleteVideo(
      BuildContext context, Function()? onDelete) {
    return showDiscardChangesDialog(
      context: context,
      title: AppStrings.deleteThisVideo,
      content: null,
      titleButton: AppStrings.delete,
      onConfirm: onDelete,
    );
  }

  static Future<bool?> showDialogDeleteSearchHistory(BuildContext context,
      String title, AppLocalizations localization, VoidCallback onRemove) {
    return showDiscardChangesDialog(
      context: context,
      title: title,
      content: localization.remove_from_search_history,
      titleButton: localization.remove,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      onConfirm: onRemove,
    );
  }

  static Future<bool?> showDialogDeletePlaylist(
      BuildContext context, Function()? onDelete) {
    return showDiscardChangesDialog(
      context: context,
      title: AppStrings.deletePlaylist,
      content: null,
      titleButton: AppStrings.delete,
      onConfirm: onDelete,
    );
  }

  static Future<bool?> showCustomDialog({
    required BuildContext context,
    required String title,
    Widget? content,
  }) {
    final localization = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final titleButtonColor =
            Theme.of(context).brightness == Brightness.light
                ? AppColors.blue
                : AppColors.white;

        return AlertDialog(
          title: Text(title),
          elevation: 0.0,
          titleTextStyle:
              AppTextStyles.titleLarge.copyWith(color: context.secondaryColor),
          content: content ?? const SizedBox(),
          contentTextStyle: AppTextStyles.bodyLarge
              .copyWith(color: context.secondaryColor, fontSize: 18.0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          actions: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context, false),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                child: Text(
                  localization.cancel,
                  style: TextStyle(
                    color: titleButtonColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
