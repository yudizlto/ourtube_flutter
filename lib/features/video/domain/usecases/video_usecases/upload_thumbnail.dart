import 'dart:io';

import '../../repositories/video_repository.dart';

class UploadThumbnailUseCase {
  final VideoRepository repository;

  UploadThumbnailUseCase(this.repository);

  Future<void> execute(File? imageFile, String userId, String videoId) async {
    if (imageFile == null) return;
    return repository.uploadThumbnail(imageFile, userId, videoId);
  }
}
