import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A helper function to pump a widget for testing.
///
/// This function wraps the given widget inside:
/// - `ProviderScope` (for Riverpod state management)
/// - `MaterialApp` (to provide a proper app environment)
/// - Localization delegates (for internationalization support)
///
/// It is useful for testing individual screens.
///
/// Example usage:
/// ```dart
/// await pumpTestableWidget(tester, GeneralSettingScreen(localization: localization));
/// ```
Future<void> pumpTestableScreen(
  WidgetTester tester,
  Widget widgetUnderTest, {
  Locale locale = const Locale("en"),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale("en")],
        locale: locale,
        home: widgetUnderTest,
      ),
    ),
  );
}
