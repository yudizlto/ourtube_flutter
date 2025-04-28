import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourtube/features/search/presentation/screens/search_screen.dart';
import 'package:ourtube/features/search/presentation/widgets/custom_search_bar.dart';
import 'package:ourtube/features/search/presentation/widgets/search_history_tile.dart';

import '../helper/widget_test_helper.dart';

void main() {
  late AppLocalizations localization;

  /// Runs before each test to initialize localization
  setUp(() async {
    localization = await AppLocalizations.delegate.load(const Locale("en"));
  });

  group("Widget test for SearchScreen", () {
    testWidgets("Displays all widget in Search Screen correctly",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render `SearchScreen`
      await pumpTestableScreen(tester, const SearchScreen());

      /// Finds the search bar widget on the screen
      final searchBar = find.byType(CustomSearchBar);

      /// Finds at least one search history tile on the screen
      final searchHistoryTile = find.byType(SearchHistoryTile);

      /// Ensures that the search bar is present
      /// Ensures that at least one search history tile is present
      expect(searchBar, findsOneWidget);
      expect(searchHistoryTile, findsAtLeast(1));
    });
  });

  group("Widget test for CustomSearchBar", () {
    testWidgets("Back button is displayed correctly", (tester) async {
      /// Calls the `pumpTestableScreen` function to render `SearchScreen`
      await pumpTestableScreen(tester, const SearchScreen());

      /// Finds the back button icon
      final backButton = find.byIcon(Icons.arrow_back_sharp);

      /// Ensures that the back button is present
      expect(backButton, findsOne);
    });

    testWidgets("Allows user to type in the search field", (tester) async {
      /// Calls the `pumpTestableScreen` function to render `SearchScreen`
      await pumpTestableScreen(tester, const SearchScreen());

      /// Finds the text field inside the search bar
      final textField = find.byType(TextField);

      /// Ensures that the text field is present
      expect(textField, findsOneWidget);

      /// Simulates user typing "Flutter" into the search field
      await tester.enterText(textField, "Flutter");

      /// Rebuilds the widget tree after entering text
      await tester.pump();

      /// Verifies that the text is correctly entered into the field
      expect(find.text("Flutter"), findsOneWidget);
    });
  });

  group("Widget test for SearchHistoryTile", () {
    testWidgets("Opens confirmation dialog on long press", (tester) async {
      /// Calls the `pumpTestableScreen` function to render `SearchScreen`
      await pumpTestableScreen(tester, const SearchScreen());

      final tile = find.byType(SearchHistoryTile);

      /// Simulates a long press on the `SearchHistoryTile` to trigger the confirmation dialog
      await tester.longPress(tile);
      await tester.pumpAndSettle();

      /// Finds the text inside the confirmation dialog
      final dialogMessage = find.text(localization.remove_from_search_history);

      /// Verifies that an `AlertDialog` is displayed after the long press
      /// Ensures that the confirmation message appears within the dialog
      expect(find.byType(AlertDialog), findsAtLeast(1));
      expect(dialogMessage, findsOne);
    });

    testWidgets("Closes confirmation dialog when cancel is pressed",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render `SearchScreen`
      await pumpTestableScreen(tester, const SearchScreen());

      final tile = find.byType(SearchHistoryTile);

      /// Simulates a long press on the `SearchHistoryTile` to trigger the confirmation dialog
      await tester.longPress(tile);
      await tester.pumpAndSettle();

      /// Finds the cancel button within the confirmation dialog
      final cancelButton = find.text(localization.cancel);
      expect(cancelButton, findsOneWidget);

      /// Simulates a tap on the cancel button to close the dialog
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      /// Ensures that the `AlertDialog` is no longer present in the widget tree
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
