import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/presentation/widgets/custom_list_tile_button.dart';
import 'package:ourtube/features/user/presentation/screens/setting_screen/general_setting_screen.dart';
import 'package:ourtube/features/user/presentation/widgets/settings_app_language_option.dart';
import 'package:ourtube/features/user/presentation/widgets/settings_theme_option.dart';

import '../../helper/widget_test_helper.dart';

void main() {
  late AppLocalizations localization;

  /// Runs before each test to initialize localization
  setUp(() async {
    localization = await AppLocalizations.delegate.load(const Locale("en"));
  });

  group("Widget test for GeneralSettingScreen", () {
    testWidgets("Displays all general settings options correctly",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render the `GeneralSettingScreen`
      /// with the previously initialized `localization`
      await pumpTestableScreen(
          tester, GeneralSettingScreen(localization: localization));

      /// Check if the localized texts are displayed correctly
      expect(find.text(localization.general), findsOneWidget);
      expect(find.text(localization.appearance), findsOneWidget);
      expect(find.text(localization.app_language), findsOneWidget);

      /// Ensure that the CustomListTileButton widgets are found on the screen
      expect(find.byType(CustomListTileButton), findsNWidgets(2));
    });

    testWidgets("Opens the theme selection dialog when tapping 'Appearance'",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render the `GeneralSettingScreen`
      await pumpTestableScreen(
          tester, GeneralSettingScreen(localization: localization));

      await tester.tap(find.text(localization.appearance));
      await tester.pump();

      expect(find.text(localization.light_theme), findsOneWidget);
      expect(find.text(localization.dark_theme), findsOneWidget);
      expect(find.text(localization.cancel), findsOneWidget);
    });
  });

  group("Dialog Interaction Tests", () {
    testWidgets("Displays dialog for theme selection when tapping 'Appearance'",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render the `GeneralSettingScreen`
      await pumpTestableScreen(
          tester, GeneralSettingScreen(localization: localization));

      /// Find the 'Appearance' setting tile by its title text
      final appearanceTile = find.text(localization.appearance);
      await tester.tap(appearanceTile);
      await tester.pumpAndSettle();

      /// Ensure the SettingsThemeOption dialog appears
      expect(find.byType(SettingsThemeOption), findsOneWidget);

      /// Simulate selecting a theme option
      final darkThemeOption = find.text(localization.dark_theme);
      await tester.tap(darkThemeOption);
      await tester.pumpAndSettle();

      /// Verify that the dialog is closed by checking if SettingsThemeOption is no longer in the widget tree
      expect(find.byType(SettingsThemeOption), findsNothing);
    });

    testWidgets(
        "Displays dialog for language selection when tapping 'App Language'",
        (tester) async {
      /// Calls the `pumpTestableScreen` function to render the `GeneralSettingScreen`
      await pumpTestableScreen(
          tester, GeneralSettingScreen(localization: localization));

      /// Find the 'App Language' setting tile by its title text
      final appLanguageTile = find.text(localization.app_language);
      await tester.tap(appLanguageTile);
      await tester.pumpAndSettle();

      /// Ensure the SettingAppLanguageOption dialog appears
      expect(find.byType(SettingAppLanguageOption), findsOneWidget);

      /// Simulate selecting a language option
      final indonesiaOption = find.text(localization.language_indonesian);
      await tester.tap(indonesiaOption);
      await tester.pumpAndSettle();

      /// Find the warning dialog title and confirmation button
      final dialogTitle = find.text(localization.change_app_language);
      final changeButton = find.text(localization.change);

      /// Verify that the warning dialog is displayed
      expect(dialogTitle, findsOneWidget);
      expect(changeButton, findsOneWidget);

      /// Tap the 'Change' button to confirm the language selection
      await tester.tap(changeButton);
      await tester.pumpAndSettle();

      /// Verify that both the warning dialog and language selection dialog are closed
      expect(dialogTitle, findsNothing);
      expect(find.byType(SettingAppLanguageOption), findsNothing);
    });
  });
}
