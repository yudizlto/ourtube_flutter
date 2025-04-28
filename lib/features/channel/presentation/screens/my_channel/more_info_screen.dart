import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/helpers/string_helper.dart';
import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../user/data/models/user_model.dart';

class MoreInfoScreen extends StatelessWidget {
  final UserModel user;

  const MoreInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: context.primaryColor,
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description section
            user.description.isEmpty
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.description,
                          style:
                              AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          user.description,
                          style: AppTextStyles.bodyLarge.copyWith(height: 1.1),
                        ),
                      ],
                    ),
                  ),

            // More info section
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.more_info,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.public_outlined),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: Text(
                              "www.ourtube.com/@${user.username}",
                              style: AppTextStyles.bodyLarge
                                  .copyWith(color: Colors.blue[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded),
                          const SizedBox(width: 15.0),
                          Text(
                            "${localization.joined} ${StringHelpers.formattedDate(user.createdAt)}",
                            style: AppTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ],
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
