import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/styles/app_theme.dart';
import '../../../../../core/utils/helpers/shared_preferences_helper.dart';
import 'settings_state.dart';

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingState> {
  @override
  SettingState build() {
    return SettingState(themeData: AppTheme.lightTheme, language: "en");
  }

  Future<void> toggleTheme(bool isDark) async {
    await SharedPreferencesHelper.saveThemePreference(isDark);
    state = state.copyWith(
      themeData: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
    );
  }

  Future<void> toggleLanguage(String language) async {
    await SharedPreferencesHelper.saveLanguagePreference(language);
    state = state.copyWith(language: language);
  }

  Future<void> loadPreferences() async {
    bool isDark = await SharedPreferencesHelper.getThemePreference();
    String language = await SharedPreferencesHelper.getLanguagePreference();
    state = state.copyWith(
      themeData: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      language: language,
    );
  }
}
