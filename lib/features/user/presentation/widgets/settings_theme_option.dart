import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/styles/app_theme.dart';
import '../../../../core/presentation/widgets/custom_radio_button.dart';
import '../providers/state/settings_notifier.dart';

class SettingsThemeOption extends ConsumerWidget {
  final AppLocalizations localization;

  const SettingsThemeOption({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingState = ref.watch(settingsNotifier);
    final settingsRef = ref.read(settingsNotifier.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomRadioButton<ThemeData>(
          title: localization.light_theme,
          value: AppTheme.lightTheme,
          groupValue: settingState.themeData,
          onTap: () {
            settingsRef.toggleTheme(false);
            if (context.mounted) Navigator.pop(context);
          },
        ),
        CustomRadioButton<ThemeData>(
          title: localization.dark_theme,
          value: AppTheme.darkTheme,
          groupValue: settingState.themeData,
          onTap: () {
            settingsRef.toggleTheme(true);
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
