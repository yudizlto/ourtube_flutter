import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ContentCategory {
  all,
  videos,
  shorts,
  posts;

  String displayName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case ContentCategory.all:
        return localizations.all_category;
      case ContentCategory.videos:
        return localizations.videos_label;
      case ContentCategory.shorts:
        return localizations.shorts;
      case ContentCategory.posts:
        return localizations.posts_label;
    }
  }
}
