import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../widgets/edit_body.dart';
import '../../widgets/edit_header.dart';

class MyChannelSettingScreen extends StatelessWidget {
  final AppLocalizations localization;

  const MyChannelSettingScreen({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomSliverAppBar(
        title: localization.channel_settings,
        showTitle: true,
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditHeader(localization: localization),
            EditBody(localization: localization),
          ],
        ),
      ),
    );
  }
}
