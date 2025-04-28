import '../../repositories/likes_repository.dart';

class LikeStatusUseCase {
  final LikesRepository repository;

  LikeStatusUseCase(this.repository);

  Stream<bool> execute(String videoId, String userId) {
    return repository.isLikedByUser(videoId, userId);
  }
}
