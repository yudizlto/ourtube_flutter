import '../../../video/data/models/likes_model.dart';
import '../repositories/playlist_repository.dart';

class FetchMyLikesUseCase {
  final PlaylistRepository repository;

  FetchMyLikesUseCase(this.repository);

  Future<List<LikesModel>> execute(String userId) async {
    return await repository.fetchAllMyLikes(userId);
  }
}
