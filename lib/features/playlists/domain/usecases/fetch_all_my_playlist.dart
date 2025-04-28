import '../../data/models/playlist_model.dart';
import '../repositories/playlist_repository.dart';

class FetchAllMyPlaylistUseCase {
  final PlaylistRepository repository;

  FetchAllMyPlaylistUseCase(this.repository);

  Future<List<PlaylistModel>> execute(String userId) async {
    return await repository.fetchAllMyPlaylists(userId);
  }
}
