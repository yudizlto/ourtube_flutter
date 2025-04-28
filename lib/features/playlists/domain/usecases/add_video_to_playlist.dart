import '../repositories/playlist_repository.dart';

class AddVideoToPlaylistUseCase {
  final PlaylistRepository repository;

  AddVideoToPlaylistUseCase(this.repository);

  Future<void> execute(String playlistId, String videoId) async {
    await repository.addVideoToPlaylist(playlistId, videoId);
  }
}
