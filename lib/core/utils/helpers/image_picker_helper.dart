import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../constants/enums/get_image_from.dart';
import '../constants/video_constants.dart';
import 'validators.dart';

/// A helper class for picking images and videos from the device.
class ImagePickerHelpers {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the selected source (gallery or camera).
  ///
  /// Returns a [File] object if an image is selected, otherwise returns `null`.
  Future<File?> pickImage(GetImageFrom source) async {
    final XFile? image = await _picker.pickImage(
      source: source == GetImageFrom.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
    );
    return image != null ? File(image.path) : null;
  }

  /// Picks a video from the selected source (gallery or camera).
  ///
  /// The video is validated against the maximum allowed size for long videos.
  /// If the validation fails, an error is returned.
  ///
  /// Returns a [File] object if a valid video is selected, otherwise returns `null`.
  Future<File?> pickVideo(GetImageFrom source) async {
    final XFile? video = await _picker.pickVideo(
      source: source == GetImageFrom.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
    );

    if (video != null) {
      File videoFile = File(video.path);

      /// Validate the video file size
      String? validationError = await ValidationUtils.validateVideoSize(
        videoFile,
        VideoConstants.longVidMaxSize,
      );

      if (validationError != null) return Future.error(validationError);
      return videoFile;
    }
    return null;
  }

  /// Picks a short video from the selected source (gallery or camera).
  ///
  /// The video is validated against the maximum allowed size and duration for short videos.
  /// If the validation fails, an error is returned.
  ///
  /// Returns a [File] object if a valid short video is selected, otherwise returns `null`.
  Future<File?> pickShorts(GetImageFrom source) async {
    final XFile? video = await _picker.pickVideo(
      source: source == GetImageFrom.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
    );

    if (video != null) {
      File videoFile = File(video.path);

      /// Validate the short video file size and duration
      String? validationError = await ValidationUtils.validateShortVideo(
        videoFile,
        VideoConstants.shortVidMaxSize,
        VideoConstants.shortMaxDuration,
      );

      if (validationError != null) return Future.error(validationError);
      return videoFile;
    }
    return null;
  }
}
