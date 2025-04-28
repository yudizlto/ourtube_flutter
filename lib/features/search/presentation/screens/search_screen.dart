import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/custom_search_bar.dart';
import '../widgets/search_history_tile.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            CustomSearchBar(localization: localization),

            // Search history list
            Expanded(
              child: ListView.builder(
                itemCount: 1, // max 50
                itemBuilder: (context, index) {
                  return SearchHistoryTile(localization: localization);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
