import 'dart:io';

import '../../repositories/video_repository.dart';

class UpdateThumbnailUseCase {
  final VideoRepository repository;

  UpdateThumbnailUseCase(this.repository);

  Future<void> execute(File imageFile, String userId, String videoId) async {
    return repository.updateThumbnail(imageFile, userId, videoId);
  }
}
