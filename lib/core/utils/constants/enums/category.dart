import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// An enumeration representing different content categories.
///
/// [all] Represents all video categories
/// [gaming] Represents gaming-related content
enum Category {
  all,
  gaming;

  /// Returns the localized category name based on the app's selected language
  String displayName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case Category.all:
        return localizations.all_category;
      case Category.gaming:
        return localizations.gaming_category;
    }
  }
}
