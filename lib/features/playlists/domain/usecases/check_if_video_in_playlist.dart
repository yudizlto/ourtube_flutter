import '../repositories/playlist_repository.dart';

class CheckIfVideoInPlaylistUseCase {
  final PlaylistRepository repository;

  CheckIfVideoInPlaylistUseCase(this.repository);

  Stream<bool> execute(String playlistId, String videoId) {
    return repository.isVideoInPlaylist(playlistId, videoId);
  }
}
