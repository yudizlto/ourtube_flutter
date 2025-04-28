import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_view.dart';
import 'core/presentation/providers/app_provider.dart';
import 'core/presentation/styles/app_theme.dart';
import 'core/presentation/widgets/loader.dart';
import 'l10n/l10n.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsyncValue = ref.watch(settingsFutureProvider);

    return themeAsyncValue.when(
      data: (app) {
        final themeRef = app.themeData;
        final languageRef = app.language;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          theme: themeRef,
          supportedLocales: L10n.all,
          locale: Locale(languageRef),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AppView(),
        );
      },
      loading: () => const Loader(),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }
}
