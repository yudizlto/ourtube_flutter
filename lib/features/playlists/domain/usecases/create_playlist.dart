import '../repositories/playlist_repository.dart';

class CreatePlaylistUseCase {
  final PlaylistRepository repository;

  CreatePlaylistUseCase(this.repository);

  Future<void> excute(String userId, String name, bool isPublic) async {
    return repository.createPlaylist(userId, name, isPublic);
  }
}
