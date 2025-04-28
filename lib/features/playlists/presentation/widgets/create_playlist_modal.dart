import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/helpers/modal_helpers.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../../../core/utils/helpers/validators.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/state/playlist_notifier.dart';

class CreatePlaylistModal extends ConsumerWidget {
  const CreatePlaylistModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playlistNotifier.notifier);
    final localization = AppLocalizations.of(context)!;

    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          /// Close modal and reset states
          Navigator.pop(context);
          notifier.reset();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: keyboardVisible),
          padding: const EdgeInsets.fromLTRB(18.0, 24.0, 18.0, 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: context.surfaceColor,
          ),
          child: _buildCreatePlaylistForm(context, ref, localization),
        ),
      ),
    );
  }

  /// Build create playlist form
  Widget _buildCreatePlaylistForm(
      BuildContext context, WidgetRef ref, AppLocalizations localization) {
    final playlistState = ref.watch(playlistNotifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label section
        Text(localization.new_playlist,
            style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0)),
        const SizedBox(height: 24.0),

        // Text field
        _buildPlaylistNameTextField(context, ref, localization),
        const SizedBox(height: 20.0),

        // Set visibility section
        GestureDetector(
          onTap: () =>
              ModalHelpers.showBottomSheetForPlaylistVisibility(context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: context.ternaryColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.visibility,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: context.ternaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      playlistState.isPublic
                          ? localization.public
                          : localization.private,
                      style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
                    ),
                  ],
                ),
                Image.asset(
                  AppAssets.downArrowIcon,
                  width: 24.0,
                  color: context.secondaryColor,
                ),
              ],
            ),
          ),
        ),

        // Cancel & create playlist button
        _buildActionButtons(context, ref, localization),
      ],
    );
  }

  /// Build playlist name text field
  Widget _buildPlaylistNameTextField(
      BuildContext context, WidgetRef ref, AppLocalizations localization) {
    final notifier = ref.read(playlistNotifier.notifier);
    final playlistState = ref.watch(playlistNotifier);

    final newErrorMessage = ValidationUtils.validatePlaylistNameCharacterCount(
        playlistState.playlistName, AppStrings.chooseShorterTitle);

    return Column(
      children: [
        // Text form field
        TextField(
          maxLines: 6,
          minLines: 1,
          cursorColor: context.secondaryColor,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
          decoration: InputDecoration(
            labelText: localization.title,
            labelStyle: TextStyle(
              color: newErrorMessage != null
                  ? AppColors.redDark4
                  : context.secondaryColor,
            ),
            contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 12.0, 12.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: newErrorMessage != null
                    ? AppColors.redDark4
                    : context.secondaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: newErrorMessage != null
                    ? AppColors.redDark4
                    : context.secondaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onChanged: (value) {
            notifier.createPlaylistName(value);
          },
        ),
        const SizedBox(height: 10.0),

        // Warning message and character count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Warning message (only show if there is an error)
            if (newErrorMessage != null)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outlined,
                      color: AppColors.redDark4,
                      size: 18.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        newErrorMessage,
                        style: const TextStyle(
                          color: AppColors.redDark4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),

            /// Character count (only show when length >= 140)
            if (playlistState.playlistName.length >= 140)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "${playlistState.playlistName.length} / 150",
                  style: TextStyle(
                    color: newErrorMessage != null
                        ? AppColors.redDark4
                        : AppColors.blackDark2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Build action buttons: cancel & create playlist
  Widget _buildActionButtons(
      BuildContext context, WidgetRef ref, AppLocalizations localization) {
    final notifier = ref.read(playlistNotifier.notifier);
    final playlistState = ref.watch(playlistNotifier);

    final isDisabled =
        playlistState.titleError != null || playlistState.playlistName.isEmpty;

    final disabledColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFCCCCCC)
        : const Color(0xFF606060);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Button for cancel create playlist
        ShrinkingButton(
          width: 90.0,
          text: localization.cancel,
          textColor: context.secondaryColor,
          fontWeight: FontWeight.w600,
          buttonColor: context.surfaceColor,
          borderColor: context.ternaryColor,
          onPressed: () {
            /// Close modal and reset playlist
            Navigator.pop(context);
            notifier.reset();
          },
        ),
        const SizedBox(width: 15.0),

        // Button for create playlist
        ShrinkingButton(
          width: 80.0,
          text: localization.create,
          textColor: context.surfaceColor,
          fontWeight: FontWeight.w600,
          buttonColor: isDisabled ? disabledColor : context.secondaryColor,
          onPressed: isDisabled
              ? null
              : () => _handleCreatePlaylist(context, ref,
                  playlistState.playlistName, playlistState.isPublic),
        ),
      ],
    );
  }

  /// Handles create playlist action
  Future<void> _handleCreatePlaylist(
      BuildContext context, WidgetRef ref, String name, bool isPublic) async {
    final currentUserId = ref.read(currentUserProvider).value!.userId;
    final createPlaylist = ref
        .read(createPlaylistUseCaseProvider)
        .excute(currentUserId, name, isPublic);

    await createPlaylist.then((_) {
      SnackbarHelpers.showCommonSnackBar(context, AppStrings.playlistCreated);
      Navigator.pop(context);
      ref.read(playlistNotifier.notifier).reset();
    });
  }
}
