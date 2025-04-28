import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'custom_action_row_button.dart';
import 'drag_handle_bottom_sheet.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const DragHandleBottomSheet(),

            // Button for hide notification
            CustomActionRowButton(
              title: localization.hide_notification,
              icon: Icons.visibility_off_outlined,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              onTap: () {},
            ),

            // Button for mute notification
            CustomActionRowButton(
              title: localization.turn_off_notification("Dummy"),
              icon: Icons.notifications_off_outlined,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
