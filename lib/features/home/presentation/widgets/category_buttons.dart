import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/constants/enums/category.dart';
import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/presentation/widgets/top_action_button.dart';
import '../providers/home_provider.dart';

class CategoryButtons extends ConsumerWidget {
  /// A global key for controlling the scaffold state, used to open the drawer.
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CategoryButtons({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    /// Retrieves all available categories from the `Category` enum.
    const categoryList = Category.values;

    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending Button
            /// Opens the navigation drawer when clicked.
            TopActionButton(
              child: Image.asset(
                AppAssets.compassIcon,
                width: 26.0,
                fit: BoxFit.cover,
                color: context.secondaryColor,
              ),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(width: 15.0),

            // Category Buttons
            /// Generates a button for each category.
            ...categoryList.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TopActionButton(
                  isSelected: selectedCategory == category,
                  child: Text(
                    category.displayName(context),
                    style: AppTextStyles.titleSmall.copyWith(
                      fontSize: 18.0,
                      color: selectedCategory == category
                          ? context.primaryColor
                          : context.secondaryColor,
                    ),
                  ),
                  onPressed: () {
                    /// Updates the selected category state when clicked.
                    ref.read(selectedCategoryProvider.notifier).state =
                        category;
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
