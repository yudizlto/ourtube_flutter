import 'dart:io';

import '../../repositories/video_repository.dart';

class UploadVideoUseCase {
  final VideoRepository repository;

  UploadVideoUseCase(this.repository);

  Future<void> execute(
    File videoFile,
    String videoId,
    String userId,
    String title,
    String desc,
    String visibility,
    bool isCommentsEnabled,
    bool isAgeRestricted,
    bool isAudienceRestricted,
    int duration,
    String videoType,
  ) async {
    return repository.uploadVideo(
      videoFile,
      videoId,
      userId,
      title,
      desc,
      visibility,
      isCommentsEnabled,
      isAgeRestricted,
      isAudienceRestricted,
      duration,
      videoType,
    );
  }
}
