import 'package:flutter/material.dart';

class SettingState {
  final ThemeData themeData;
  final String language;

  SettingState({
    required this.themeData,
    required this.language,
  });

  SettingState copyWith({ThemeData? themeData, String? language}) {
    return SettingState(
      themeData: themeData ?? this.themeData,
      language: language ?? this.language,
    );
  }
}
