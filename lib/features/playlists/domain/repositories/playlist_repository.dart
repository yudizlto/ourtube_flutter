import '../../../video/data/models/likes_model.dart';
import '../../data/models/playlist_model.dart';

abstract class PlaylistRepository {
  Future<void> createPlaylist(String userId, String name, bool isPublic);
  Future<void> deletePlaylist(String playlistId, String userId);
  Future<List<PlaylistModel>> fetchAllMyPlaylists(String userId);
  Future<List<LikesModel>> fetchAllMyLikes(String userId);
  Stream<bool> isVideoInPlaylist(String playlistId, String videoId);
  Future<void> addVideoToPlaylist(String playlistId, String videoId);
  Future<void> removeVideoFromPlaylist(String playlistId, String videoId);

  // edit
}
