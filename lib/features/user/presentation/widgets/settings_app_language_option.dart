import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/custom_radio_button.dart';
import '../../../../core/utils/helpers/dialog_helper.dart';
import '../providers/state/settings_notifier.dart';

class SettingAppLanguageOption extends ConsumerWidget {
  final AppLocalizations localization;

  const SettingAppLanguageOption({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingState = ref.watch(settingsNotifier);
    final settingsRef = ref.read(settingsNotifier.notifier);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomRadioButton<String>(
            title: localization.language_english,
            subtitle: localization.language_english_description,
            value: "en",
            groupValue: settingState.language,
            onTap: () {
              DialogHelpers.showDiscardChangesDialog(
                context: context,
                title: localization.change_app_language,
                content: localization.change_app_language_description,
                titleButton: localization.change,
                onConfirm: () {
                  settingsRef.toggleLanguage("en");
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          ),
          CustomRadioButton<String>(
            title: localization.language_indonesian,
            subtitle: localization.language_indonesian_description,
            value: "id",
            groupValue: settingState.language,
            onTap: () {
              DialogHelpers.showDiscardChangesDialog(
                context: context,
                title: localization.change_app_language,
                content: localization.change_app_language_description,
                titleButton: localization.change,
                onConfirm: () {
                  settingsRef.toggleLanguage("id");
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          ),
          CustomRadioButton<String>(
            title: localization.language_japanese,
            subtitle: localization.language_japanese_description,
            value: "ja",
            groupValue: settingState.language,
            onTap: () {
              DialogHelpers.showDiscardChangesDialog(
                context: context,
                title: localization.change_app_language,
                content: localization.change_app_language_description,
                titleButton: localization.change,
                onConfirm: () {
                  settingsRef.toggleLanguage("ja");
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
