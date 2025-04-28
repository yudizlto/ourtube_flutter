import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../video/data/models/likes_model.dart';
import '../models/playlist_model.dart';

abstract class PlaylistDataSource {
  Future<void> addPlaylistToFirestore(PlaylistModel playlist);
  Future<List<PlaylistModel>> getAllMyPlaylists(String userId);
  Future<void> deletePlaylistFromFirestore(String playlistId);
  Future<List<LikesModel>> getLikesPlaylist(String userId);
  Stream<bool> isVideoInPlaylist(String playlistId, String videoId);
}

class PlaylistRemoteDataSource implements PlaylistDataSource {
  final FirebaseFirestore _firestore;

  PlaylistRemoteDataSource(this._firestore);

  /// Adds a new playlist to the Firestore database
  @override
  Future<void> addPlaylistToFirestore(PlaylistModel playlist) async {
    await _firestore
        .collection("playlists")
        .doc(playlist.playlistId)
        .set(playlist.toMap());
  }

  /// Retrieves all playlists created by a specific user
  /// [userId]: The ID of the user whose playlists should be fetched
  @override
  Future<List<PlaylistModel>> getAllMyPlaylists(String userId) async {
    final snapshot = await _firestore
        .collection("playlists")
        .where("userId", isEqualTo: userId)
        .get();
    return snapshot.docs.map((e) => PlaylistModel.fromMap(e.data())).toList();
  }

  /// Deletes a playlist from Firestore
  /// [playlistId]: The ID of the playlist to delete
  @override
  Future<void> deletePlaylistFromFirestore(String playlistId) async {
    await _firestore.collection("playlists").doc(playlistId).delete();
  }

  /// Retrieves a list of likes associated with a specific user's playlists
  /// Ordered by creation time in descending order
  @override
  Future<List<LikesModel>> getLikesPlaylist(String userId) async {
    final snapshot = await _firestore
        .collection("likes")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();
    return snapshot.docs.map((e) => LikesModel.fromMap(e.data())).toList();
  }

  /// Streams a boolean value indicating whether a video is in a specific playlist
  /// [playlistId]: The ID of the playlist to check
  /// [videoId]: The ID of the video to check if it's in the playlist
  @override
  Stream<bool> isVideoInPlaylist(String playlistId, String videoId) {
    return _firestore
        .collection("playlists")
        .doc(playlistId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return false;
      final data = snapshot.data();
      if (data == null) return false;
      final videos = List<String>.from(data["videos"] ?? []);
      return videos.contains(videoId);
    });
  }
}
