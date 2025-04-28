import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_strings.dart';

enum VideoType {
  long,
  short;

  String displayName() {
    switch (this) {
      case VideoType.long:
        return AppStrings.long;
      case VideoType.short:
        return AppStrings.shorts;
    }
  }

  String localizedDisplayName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case VideoType.long:
        return localizations.videos_label;
      case VideoType.short:
        return localizations.shorts;
    }
  }
}
