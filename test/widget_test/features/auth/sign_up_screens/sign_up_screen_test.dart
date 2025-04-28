import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/presentation/widgets/custom_icon_button.dart';
import 'package:ourtube/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ourtube/features/auth/presentation/widgets/logo_section.dart';

void main() {
  late AppLocalizations localization;

  /// Runs before each test to initialize localization
  setUp(() async {
    localization = await AppLocalizations.delegate.load(const Locale("en"));
  });

  /// A helper function to render the SignUpScreen
  Future<void> pumpLoginScreen(WidgetTester tester) async {
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
          home: SignUpScreen(),
        ),
      ),
    );
  }

  group("Widget test for SignUpScreen", () {
    testWidgets("Displays all widget correctly", (tester) async {
      await pumpLoginScreen(tester);

      /// Find the logo
      final logo = find.byType(LogoSection);
      final title = find.text(localization.sign_up_for_ourtube);

      /// Verify that the logo and title are present
      expect(logo, findsOne);
      expect(title, findsOne);

      /// Find the sign up option buttons
      final signUpWithGoogleButton =
          find.text(localization.continue_with_google);

      /// Verify that the buttons are present
      expect(find.byType(CustomIconButton), findsNWidgets(1));
      expect(signUpWithGoogleButton, findsOne);

      /// Find the login button
      final alreadyHaveAccount =
          find.text(localization.already_have_an_account);
      final signInButton = find.text(localization.log_in);

      /// Verify that the buttons are present
      expect(alreadyHaveAccount, findsOne);
      expect(signInButton, findsOne);
    });
  });
}
