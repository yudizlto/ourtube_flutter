import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/features/user/presentation/screens/library_screen/authenticated_library_screen.dart';
import 'package:ourtube/features/user/presentation/widgets/action_bar.dart';
import 'package:ourtube/features/user/presentation/widgets/action_button.dart';
import 'package:ourtube/features/user/presentation/widgets/history_section.dart';
import 'package:ourtube/features/user/presentation/widgets/playlist_section.dart';
import 'package:ourtube/features/user/presentation/widgets/user_info.dart';

void main() {
  /// A helper function to render the AuthenticatedLibraryScreen
  Future<void> pumpAuthenticatedLibraryScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale("en")],
          home: AuthenticatedLibraryScreen(),
        ),
      ),
    );
  }

  group("Widget test for AuthenticatedLibraryScreen", () {
    testWidgets("Displays all section in AuthenticatedLibraryScreen correctly",
        (tester) async {
      await pumpAuthenticatedLibraryScreen(tester);

      final actionBar = find.byType(ActionBar);
      final userInfoSection = find.byType(UserInfo);
      final actionButton = find.byType(ActionButton);
      final historySection = find.byType(HistorySection);
      final playlistSection = find.byType(PlaylistSection);

      expect(actionBar, findsOneWidget);
      expect(userInfoSection, findsOneWidget);
      expect(actionButton, findsOneWidget);
      expect(historySection, findsOneWidget);
      expect(playlistSection, findsOneWidget);
    });
  });
}
