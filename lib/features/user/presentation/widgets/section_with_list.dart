import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/shrinking_button.dart';

class SectionWithList extends StatelessWidget {
  final AppLocalizations localization;
  final String titleSection;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onViewAll;
  final Widget? createWidget;
  final Widget? widgetList;

  const SectionWithList({
    super.key,
    required this.localization,
    required this.titleSection,
    this.margin = EdgeInsets.zero,
    required this.onViewAll,
    this.createWidget,
    this.widgetList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Playlists title section and view all playlists button
        Container(
          margin: margin,
          child: InkWell(
            onTap: onViewAll,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleSection,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
                  ),
                  const Spacer(),

                  // Create new playlist button
                  createWidget ?? const SizedBox(),

                  // View all playlists button
                  Flexible(
                    flex: 0,
                    child: ShrinkingButton(
                      text: localization.view_all,
                      textColor: context.secondaryColor,
                      buttonColor: context.primaryColor,
                      borderColor: context.ternaryColor,
                      padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                      onPressed: onViewAll,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Horizontal list of playlists
        widgetList ?? const SizedBox(),
      ],
    );
  }
}
