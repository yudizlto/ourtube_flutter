import '../repositories/playlist_repository.dart';

class RemoveVideoFromPlaylistUseCase {
  final PlaylistRepository repository;

  RemoveVideoFromPlaylistUseCase(this.repository);

  Future<void> execute(String playlistId, String videoId) async {
    await repository.removeVideoFromPlaylist(playlistId, videoId);
  }
}
