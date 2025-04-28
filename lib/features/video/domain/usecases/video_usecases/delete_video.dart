import '../../repositories/video_repository.dart';

class DeleteVideoUseCase {
  final VideoRepository repository;

  DeleteVideoUseCase(this.repository);

  Future<void> execute(String videoId, String userId) async {
    await repository.deleteVideo(videoId, userId);
  }
}
