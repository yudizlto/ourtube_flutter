import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../features/search/presentation/screens/search_screen.dart';
import '../../utils/helpers/navigation_helpers.dart';
import 'circular_action_button.dart';

class SearchIconButton extends StatelessWidget {
  const SearchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularActionButton(
      icon: Icons.search,
      color: context.secondaryColor,
      onTap: () =>
          NavigationHelpers.navigateToScreen(context, const SearchScreen()),
    );
  }
}
