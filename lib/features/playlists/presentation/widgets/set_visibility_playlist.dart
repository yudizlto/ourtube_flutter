import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/drag_handle_bottom_sheet.dart';
import '../providers/state/playlist_notifier.dart';

class SetVisibilityPlaylist extends ConsumerWidget {
  const SetVisibilityPlaylist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playlistNotifier.notifier);
    final isPublicRef = ref.watch(playlistNotifier);

    final localization = AppLocalizations.of(context)!;

    return Material(
      color: context.surfaceColor,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24.0, bottom: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.ternaryColor),
                ),
              ),
              child: Text(
                localization.set_visibility,
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
              ),
            ),

            // Option public for the playlist
            ListTile(
              leading: const Icon(Icons.public_outlined),
              title: Text(localization.public),
              subtitle: Text(localization.public_description),
              trailing: isPublicRef.isPublic ? const Icon(Icons.check) : null,
              onTap: () => notifier.setIsPublic(true),
            ),

            // Option private for the playlist
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(localization.private),
              subtitle: Text(localization.private_description),
              trailing: isPublicRef.isPublic ? null : const Icon(Icons.check),
              onTap: () => notifier.setIsPublic(false),
            ),
          ],
        ),
      ),
    );
  }
}
