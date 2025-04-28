import 'dart:io';

import '../../../data/models/video_model.dart';

class VideoState {
  final File? selectedThumbnail;
  final String title;
  final String description;
  final String visibilityType;
  final bool audienceRestricted;
  final bool ageRestricted;
  final bool commentsEnabled;
  final String? descriptionError;
  final String? titleError;
  final bool isDataUnchanged;
  final VideoModel? originalVideo;

  VideoState({
    this.selectedThumbnail,
    this.title = "",
    this.description = "",
    this.visibilityType = "Public",
    this.audienceRestricted = false,
    this.ageRestricted = false,
    this.commentsEnabled = true,
    this.descriptionError,
    this.titleError,
    this.isDataUnchanged = true,
    this.originalVideo,
  });

  // Add the copyWith method
  VideoState copyWith({
    File? selectedThumbnail,
    String? title,
    String? description,
    String? visibilityType,
    bool? audienceRestricted,
    bool? ageRestricted,
    bool? commentsEnabled,
    String? descriptionError,
    String? titleError,
    bool? isDataUnchanged,
    VideoModel? originalVideo,
  }) {
    return VideoState(
      selectedThumbnail: selectedThumbnail ?? this.selectedThumbnail,
      title: title ?? this.title,
      description: description ?? this.description,
      visibilityType: visibilityType ?? this.visibilityType,
      audienceRestricted: audienceRestricted ?? this.audienceRestricted,
      ageRestricted: ageRestricted ?? this.ageRestricted,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
      descriptionError: descriptionError ?? this.descriptionError,
      titleError: titleError ?? this.titleError,
      isDataUnchanged: isDataUnchanged ?? this.isDataUnchanged,
      originalVideo: originalVideo ?? this.originalVideo,
    );
  }
}
