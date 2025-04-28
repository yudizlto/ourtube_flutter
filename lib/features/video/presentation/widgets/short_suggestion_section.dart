import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';

class ShortSuggestionSection extends StatelessWidget {
  final AppLocalizations localization;

  const ShortSuggestionSection({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          // Header: Logo & Title section
          Row(
            children: [
              Image.asset(AppAssets.coloredShortIcon, width: 50.0),
              const SizedBox(width: 8.0),
              Text(
                localization.shorts,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 20.0),
              ),
            ],
          ),

          // List of short video suggestions
          Container(
            height: 250.0,
            margin: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 150.0,
                  height: 250.0,
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.blackDark2,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Button for more options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.more_vert_outlined,
                                    color: AppColors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Video shorts section
                        const SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video short's title
                              Text(
                                "resep milikmochiaaaaaaaaaaaaaaaaaaaaaaa",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.0),

                              // Video short's views count
                              Text(
                                "4.3M views",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
