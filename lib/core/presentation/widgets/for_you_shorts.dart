import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/constants/app_assets.dart';
import '../styles/app_text_style.dart';
import 'shorts_grid.dart';

class ForYouShortsVideo extends StatelessWidget {
  final List shortsList;

  const ForYouShortsVideo({super.key, required this.shortsList});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppAssets.coloredShortIcon,
                width: 30.0,
                height: 30.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                localization.shorts,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
              ),
              const Spacer(),
              // MoreIconButton(
              //   padding: EdgeInsets.zero,
              //   onTap: () {},
              // ),
            ],
          ),
          const SizedBox(height: 10.0),
          ShortsGrid(
            shortsList: shortsList,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
