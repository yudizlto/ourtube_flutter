import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/helpers/validators.dart';
import '../../../data/models/video_model.dart';
import 'video_state.dart';

/// A provider for managing video editing state.
/// Uses `family` to allow passing an initial [VideoModel] for editing.
final editVideoNotifierProvider =
    StateNotifierProvider.family<VideoNotifier, VideoState, VideoModel>(
  (ref, video) => VideoNotifier(
    VideoState(
      selectedThumbnail: null,
      title: video.title,
      description: video.description,
      visibilityType: video.visibilityType,
      audienceRestricted: video.audienceRestricted,
      ageRestricted: video.ageRestricted,
      commentsEnabled: video.commentsEnabled,
      titleError: null,
      descriptionError: null,
      isDataUnchanged: false,
      originalVideo: video,
    ),
  ),
);

/// A provider for managing video creation state.
/// Initializes default values for a new video.
final createLongVideoNotifierProvider =
    StateNotifierProvider<VideoNotifier, VideoState>(
  (ref) => VideoNotifier(
    VideoState(
      selectedThumbnail: null,
      title: "",
      description: "",
      visibilityType: "Public",
      audienceRestricted: false,
      ageRestricted: false,
      commentsEnabled: true,
      titleError: null,
      descriptionError: null,
      isDataUnchanged: false,
      originalVideo: null,
    ),
  ),
);

class VideoNotifier extends StateNotifier<VideoState> {
  VideoNotifier(super.initialState);

  /// Sets the selected thumbnail.
  void setThumbnail(File? selectedThumbnail) {
    state = state.copyWith(selectedThumbnail: selectedThumbnail);
  }

  /// Sets the title error message.
  void setTitleError(String? titleError) {
    state = state.copyWith(titleError: titleError);
  }

  /// Sets the description error message.
  void setDescriptionError(String? descriptionError) {
    state = state.copyWith(descriptionError: descriptionError);
  }

  /// Sets the video title and validates it.
  void createTitle(String title) {
    final titleError = ValidationUtils.validateTitleCharacterCount(
        title, AppStrings.chooseShorterTitle);
    setTitleError(titleError);

    state = state.copyWith(title: title, titleError: titleError);
  }

  /// Sets the video description.
  void createDescription(String description, {String? descError}) {
    state =
        state.copyWith(description: description, descriptionError: descError);
  }

  /// Sets the video visibility (e.g., public, private).
  void setVisibility(String visibility) {
    state = state.copyWith(visibilityType: visibility);
  }

  /// Enables or disables comments on the video.
  void setCommentsEnabled(bool isEnabled) {
    state = state.copyWith(commentsEnabled: isEnabled);
  }

  /// Restricts the video to a specific audience.
  void setAudienceRestricted(bool isRestricted) {
    state = state.copyWith(audienceRestricted: isRestricted);
  }

  /// Sets the age restriction for the video.
  void setAgeRestricted(bool isRestricted) {
    state = state.copyWith(ageRestricted: isRestricted);
  }

  /// Updates the selected thumbnail and checks for data changes.
  void updateSelectedThumbnail(File? newSelectedThumbnail) {
    state = state.copyWith(selectedThumbnail: newSelectedThumbnail);

    /// Check if the data is unchanged after updating the title
    _updateIsDataUnchanged();
  }

  /// Updates the video title, validates it, and checks for data changes.
  void updateTitle(String newTitle) {
    final errorMessage = ValidationUtils.validateEditCurrentTitle(
      newTitle,
      AppStrings.chooseShorterTitle,
      AppStrings.titleIsRequired,
    );
    updateTitleError(errorMessage);

    /// Update the title and error state
    state = state.copyWith(title: newTitle, titleError: errorMessage);

    /// Check if the data is unchanged after updating the title
    _updateIsDataUnchanged();
  }

  /// Updates the video description and checks for data changes.
  void updateDescription(String newDescription) {
    state = state.copyWith(description: newDescription);
    _updateIsDataUnchanged();
  }

  /// Updates the video visibility and checks for data changes.
  void updateVisibility(String newVisibility) {
    state = state.copyWith(visibilityType: newVisibility);
    _updateIsDataUnchanged();
  }

  /// Enables or disables comments and checks for data changes.
  void updateCommentsEnabled(bool isEnabled) {
    state = state.copyWith(commentsEnabled: isEnabled);
    _updateIsDataUnchanged();
  }

  /// Updates audience restriction and checks for data changes.
  void updateAudienceRestricted(bool isRestricted) {
    state = state.copyWith(audienceRestricted: isRestricted);
    _updateIsDataUnchanged();
  }

  /// Updates age restriction and checks for data changes.
  void updateAgeRestricted(bool isRestricted) {
    state = state.copyWith(ageRestricted: isRestricted);
    _updateIsDataUnchanged();
  }

  /// Updates the title error state and checks for data changes.
  void updateTitleError(String? newTitleError) {
    state = state.copyWith(titleError: newTitleError);
    _updateIsDataUnchanged();
  }

  /// Updates the description error state and checks for data changes.
  void updateDescriptionError(String? newDescriptionError) {
    state = state.copyWith(descriptionError: newDescriptionError);
    _updateIsDataUnchanged();
  }

  /// Checks whether the video data is unchanged compared to the original.
  void _updateIsDataUnchanged() {
    final isUnchanged = state.title == state.originalVideo!.title &&
        state.description == state.originalVideo!.description &&
        state.selectedThumbnail == null &&
        state.visibilityType == state.originalVideo!.visibilityType &&
        state.commentsEnabled == state.originalVideo!.commentsEnabled &&
        state.audienceRestricted == state.originalVideo!.audienceRestricted &&
        state.ageRestricted == state.originalVideo!.ageRestricted &&
        state.titleError == null &&
        state.descriptionError == null;

    state = state.copyWith(isDataUnchanged: isUnchanged);
  }

  /// Resets the video state based on the given `VideoModel` and edit mode or not.
  /// If `isEdit` is true, the state is reset with the provided `VideoModel`.
  /// If `isEdit` is false, the state is reset with default values.
  void reset(VideoModel? video, bool isEdit) {
    if (isEdit) {
      state = VideoState(
        selectedThumbnail: null,
        title: video!.title,
        description: video.description,
        visibilityType: video.visibilityType,
        audienceRestricted: video.audienceRestricted,
        ageRestricted: video.ageRestricted,
        commentsEnabled: video.commentsEnabled,
        titleError: null,
        descriptionError: null,
        isDataUnchanged: true,
        originalVideo: video,
      );
    } else {
      state = VideoState(
        selectedThumbnail: null,
        title: "",
        description: "",
        visibilityType: "Public",
        audienceRestricted: false,
        ageRestricted: false,
        commentsEnabled: true,
        titleError: null,
        descriptionError: null,
        isDataUnchanged: false,
        originalVideo: null,
      );
    }
  }
}
