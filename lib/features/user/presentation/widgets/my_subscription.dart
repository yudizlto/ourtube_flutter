import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/user_model.dart';
import 'my_subs_content.dart';
import 'subs_list_header.dart';

class MySubscription extends StatelessWidget {
  final String currentUserId;
  final UserModel user;

  const MySubscription({
    super.key,
    required this.currentUserId,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          SubsListHeader(
            localization: localization,
            currentUserId: currentUserId,
            user: user,
          ),
          MySubsContent(localization: localization),
        ],
      ),
    );
  }
}
