import '../repositories/playlist_repository.dart';

class DeletePlaylistUseCase {
  final PlaylistRepository repository;

  DeletePlaylistUseCase(this.repository);

  Future<void> execute(String playlistId, String userId) async {
    await repository.deletePlaylist(playlistId, userId);
  }
}
