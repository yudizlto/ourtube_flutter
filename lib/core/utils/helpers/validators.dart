import 'dart:io';

import 'package:video_player/video_player.dart';

class ValidationUtils {
  static String? validateRequiredField(String? value,
      {String message = "This field is required"}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateWithRegex(String? value, String pattern,
      {String message = "Invalid format"}) {
    if (value == null || !RegExp(pattern).hasMatch(value)) {
      return message;
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength,
      {String message = "Too short"}) {
    if (value == null || value.length < minLength) {
      return message;
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength,
      {String message = "Too long"}) {
    if (value != null && value.length > maxLength) {
      return message;
    }
    return null;
  }

  static String? validateTitleCharacterCount(String value, String message) {
    if (value.length > 100) {
      return message;
    }
    return null;
  }

  static String? validatePlaylistNameCharacterCount(
      String value, String message) {
    if (value.length > 150) {
      return message;
    }
    return null;
  }

  static String? validateDescriptionCharacterCount(
      String value, String message) {
    if (value.length > 5000) {
      return message;
    }
    return null;
  }

  static String? validateEditCurrentTitle(
    String value,
    String countMessage,
    String requiredFieldMessage,
  ) {
    return validateRequiredField(value, message: requiredFieldMessage) ??
        validateTitleCharacterCount(value, countMessage);
  }

  static String? validateEditDisplayName(
      String? value, String requiredMessage, String maxLengthMessage) {
    return validateRequiredField(value, message: requiredMessage) ??
        validateMaxLength(value, 50, message: maxLengthMessage);
  }

  static String? validateEditHandle(
    String? value,
    String emptyMessage,
    String minLengthMessage,
    String invalidCharMessage,
    String endsWithDotMessage,
  ) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage;
    }

    if (value.length < 3) {
      return minLengthMessage;
    }

    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value)) {
      return invalidCharMessage;
    }

    if (value.endsWith(".")) {
      return endsWithDotMessage;
    }

    return null;
  }

  static Future<String?> validateVideoSize(File videoFile, int maxSize) async {
    if (await videoFile.length() > maxSize) {
      return "Ukuran video tidak boleh lebih dari ${maxSize ~/ (1024 * 1024)}MB.";
    }
    return null;
  }

  static Future<String?> validateVideoDuration(
      File videoFile, int maxDuration) async {
    VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    double durationInSeconds = controller.value.duration.inSeconds.toDouble();
    controller.dispose();

    if (durationInSeconds > maxDuration) {
      return "Durasi video tidak boleh lebih dari ${maxDuration ~/ 60} menit ${maxDuration % 60} detik.";
    }
    return null;
  }

  static Future<String?> validateVideoOrientation(File videoFile) async {
    VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    double width = controller.value.size.width;
    double height = controller.value.size.height;
    controller.dispose();

    if (width > height) {
      return "Video short harus dalam orientasi portrait.";
    }
    return null;
  }

  static Future<String?> validateShortVideo(
      File videoFile, int maxSize, int maxDuration) async {
    return await validateVideoSize(videoFile, maxSize) ??
        await validateVideoDuration(videoFile, maxDuration) ??
        await validateVideoOrientation(videoFile);
  }
}
