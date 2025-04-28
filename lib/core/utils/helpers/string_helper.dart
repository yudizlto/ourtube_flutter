import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/user/presentation/providers/state/settings_notifier.dart';

class StringHelpers {
  /// Formats a given DateTime object into a readable string ["Jan 17, 2025"]
  static String formattedDate(DateTime date) {
    return DateFormat("MMM d, yyyy").format(date);
  }

  /// Formats the view count based on the selected language
  /// - If the language is English ("en"), it returns: "1000 views"
  /// - If the language is Indonesian ("id"), it returns: "1.000 x ditonton"
  /// - If the language is Japanese ("ja"), it returns: "1000 回視聴"
  static String formattedViewCount(
      WidgetRef ref, int viewsCount, AppLocalizations localization) {
    final localRef = ref.watch(settingsNotifier);
    switch (localRef.language) {
      case "en":
        return "$viewsCount ${localization.views}";
      case "id":
        return "$viewsCount x ${localization.views}";
      case "ja":
        return "$viewsCount ${localization.views}";
      default:
        return "$viewsCount ${localization.views}";
    }
  }

  /// Formats a given DateTime into a string with separated year and month/day
  /// Example output: ["2025", "Jan 11"]
  static List<String> splitVideoUploadDate(DateTime date) {
    return [
      DateFormat("yyyy").format(date), // Year: 2025
      DateFormat("MMM d").format(date), // Month and day: Jan 11
    ];
  }

  /// Generates a unique username by appending a random number to a display name
  static String generateUsernameByName(String displayName) {
    final random = Random();
    final randomNumber = random.nextInt(9999);

    /// Removes spaces from the display name before appending the number
    return "${displayName.replaceAll(" ", "")}$randomNumber";
  }

  /// Generates a unique username using the local part of an email (before the '@')
  /// Removes non-alphanumeric characters and appends a random number
  static String generateUsernameByEmail(String email) {
    final random = Random();
    final randomNumber = random.nextInt(9999);
    final usernameBase = email.split("@")[0];
    final sanitizedBase =
        usernameBase.replaceAll(RegExp(r"[^a-zA-Z0-9]"), "''");
    return "$sanitizedBase$randomNumber";
  }

  /// Generates a default avatar URL based on the first letter of the display name
  static String generateDefaultAvatar(String displayName) {
    final initial = displayName[0].toUpperCase();

    /// The avatar background is randomized, and text color is white
    return "https://ui-avatars.com/api/?name=$initial&background=random&color=fff";
  }

  /// Calculates the time elapsed since a given date
  /// Example outputs: ["1 minute ago", "3 hours ago", "2 days ago"]
  static String timeAgo(BuildContext context, dynamic dateInput) {
    final localization = AppLocalizations.of(context)!;
    DateTime uploadedDate;

    if (dateInput is String) {
      uploadedDate = DateTime.parse(dateInput);
    } else if (dateInput is DateTime) {
      uploadedDate = dateInput;
    } else {
      return "Invalid date";
    }

    Duration diff = DateTime.now().difference(uploadedDate);

    if (diff.inSeconds < 60) {
      return diff.inSeconds == 1
          ? "1 ${localization.second_ago}"
          : "${diff.inSeconds} ${localization.seconds_ago}";
    } else if (diff.inMinutes < 60) {
      return diff.inMinutes == 1
          ? "1 ${localization.minute_ago}"
          : "${diff.inMinutes} ${localization.minutes_ago}";
    } else if (diff.inHours < 24) {
      return diff.inHours == 1
          ? "1 ${localization.hour_ago}"
          : "${diff.inHours} ${localization.hours_ago}";
    } else if (diff.inDays < 7) {
      return diff.inDays == 1
          ? "1 ${localization.day_ago}"
          : "${diff.inDays} ${localization.days_ago}";
    } else if (diff.inDays < 30) {
      int weeks = (diff.inDays / 7).floor();
      return weeks == 1
          ? "1 ${localization.week_ago}"
          : "$weeks ${localization.weeks_ago}";
    } else if (diff.inDays < 365) {
      int months = (diff.inDays / 30).floor();
      return months == 1
          ? "1 ${localization.month_ago}"
          : "$months ${localization.months_ago}";
    } else {
      int years = (diff.inDays / 365).floor();
      return years == 1
          ? "1 ${localization.year_ago}"
          : "$years ${localization.years_ago}";
    }
  }

  /// Method to format subscriber count
  /// Returns ["No Subscribers"] if the list is empty, otherwise "[count] subscribers"
  static String formattedSubsCount(BuildContext context, List subscribers) {
    final localization = AppLocalizations.of(context)!;
    return subscribers.isEmpty
        ? localization.no_subscribers
        : localization.channelSubscribers(subscribers.length);
  }

  /// Formats a duration in seconds into a MM:SS format string
  /// Example: 125 seconds becomes ["02:05"]
  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, "0")}:${remainingSeconds.toString().padLeft(2, "0")}';
  }

  /// Checks if a given DateTime is within the current day
  /// If it is, returns ["Updated today"]. Otherwise, returns null
  static String? formatDate(BuildContext context, DateTime createdAt) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final localization = AppLocalizations.of(context)!;

    if (createdAt.isAfter(todayStart) && createdAt.isBefore(tomorrowStart)) {
      return localization.updated_today;
    }
    return null;
  }

  /// Returns the localized visibility status based on the given [visibility].
  /// - "Unlisted" → localized "Unlisted"
  /// - "Private" → localized "Private"
  /// - Other values → localized "Public"
  static String getVisibilityStatus(
      String visibility, AppLocalizations localization) {
    switch (visibility) {
      case "Unlisted":
        return localization.unlisted;
      case "Private":
        return localization.private;
      default:
        return localization.public;
    }
  }
}
