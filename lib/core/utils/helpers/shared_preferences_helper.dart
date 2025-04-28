import 'package:shared_preferences/shared_preferences.dart';

// final sharedPrefProvider = FutureProvider<SharedPreferences>((ref) {
//   return SharedPreferences.getInstance();
// });

class SharedPreferencesHelper {
  static const _isAuthenticatedKey = "isAuthenticated";
  static const _userIdKey = "userId";
  static const _isDarkKey = "isDark";
  static const _languageKey = "language";

  /// Save userId
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  /// Get userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Save authentication status
  static Future<void> setAuthenticationStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, status);
  }

  /// Get authentication status
  static Future<bool> getAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  static Future<void> saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkKey, isDark);
  }

  static Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkKey) ?? false;
  }

  static Future<void> saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? "en";
  }

  /// Clear all saved preferences (optional for logout)
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}


// class SharedPreferencesHelper {
//   final SharedPreferences _prefs;

//   SharedPreferencesHelper(this._prefs);

//   static const _isAuthenticatedKey = "isAuthenticated";
//   static const _userIdKey = "userId";
//   static const _isDarkKey = "isDark";
//   static const _languageKey = "language";

//   Future<void> setUserId(String userId) async {
//     await _prefs.setString(_userIdKey, userId);
//   }

//   String? getUserId() {
//     return _prefs.getString(_userIdKey);
//   }

//   Future<void> setAuthenticationStatus(bool status) async {
//     await _prefs.setBool(_isAuthenticatedKey, status);
//   }

//   bool getAuthenticationStatus() {
//     return _prefs.getBool(_isAuthenticatedKey) ?? false;
//   }

//   Future<void> saveThemePreference(bool isDark) async {
//     await _prefs.setBool(_isDarkKey, isDark);
//   }

//   bool getThemePreference() {
//     return _prefs.getBool(_isDarkKey) ?? false;
//   }

//   Future<void> saveLanguagePreference(String language) async {
//     await _prefs.setString(_languageKey, language);
//   }

//   String getLanguagePreference() {
//     return _prefs.getString(_languageKey) ?? "en";
//   }

//   Future<void> clearPreferences() async {
//     await _prefs.clear();
//   }
// }