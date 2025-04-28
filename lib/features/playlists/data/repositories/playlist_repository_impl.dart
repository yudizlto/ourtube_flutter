import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../video/data/models/likes_model.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/playlist_remote_data_source.dart';
import '../models/playlist_model.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistDataSource dataSource;
  final FirebaseDataSource firebaseDataSource;

  PlaylistRepositoryImpl({
    required this.dataSource,
    required this.firebaseDataSource,
  });

  /// Creates a new playlist for a user and updates their playlist list in Firebase
  @override
  Future<void> createPlaylist(String userId, String name, bool isPublic) async {
    final playlistId = const Uuid().v4();
    final playlistModel = PlaylistModel(
      playlistId: playlistId,
      userId: userId,
      name: name,
      description: "",
      videos: [],
      isPublic: isPublic,
      createdAt: DateTime.now(),
    );

    /// Add the new playlist to Firestore
    await dataSource.addPlaylistToFirestore(playlistModel);

    /// Update the user's playlists field in Firebase by adding the new [playlistId]
    await firebaseDataSource.updateUserField(
        userId, "playlists", FieldValue.arrayUnion([playlistId]));
  }

  /// Fetches all playlists created by a specific user
  @override
  Future<List<PlaylistModel>> fetchAllMyPlaylists(String userId) async {
    return await dataSource.getAllMyPlaylists(userId);
  }

  /// Deletes a playlist and updates the user's playlist field in Firebase
  @override
  Future<void> deletePlaylist(String playlistId, String userId) async {
    /// Delete the playlist from Firestore
    await dataSource.deletePlaylistFromFirestore(playlistId);

    /// Update the user's playlists field in Firebase by removing the deleted playlist
    await firebaseDataSource.updateUserField(
        userId, "playlists", FieldValue.arrayRemove([playlistId]));
  }

  /// Fetches all playlists liked by a specific user
  @override
  Future<List<LikesModel>> fetchAllMyLikes(String userId) async {
    return await dataSource.getLikesPlaylist(userId);
  }

  /// Streams a boolean indicating whether a specific video is part of a specific playlist
  /// [playlistId]: The ID of the playlist
  /// [videoId]: The ID of the video to check if it's in the playlist
  @override
  Stream<bool> isVideoInPlaylist(String playlistId, String videoId) {
    return dataSource.isVideoInPlaylist(playlistId, videoId);
  }

  /// Adds a video to a specific playlist and updates the playlist's [updatedAt] timestamp
  /// [videoId]: The ID of the video to add to the playlist
  @override
  Future<void> addVideoToPlaylist(String playlistId, String videoId) async {
    await firebaseDataSource.updatePlaylistField(
        playlistId, "videos", FieldValue.arrayUnion([videoId]));
    await firebaseDataSource.updatePlaylistField(
        playlistId, "updatedAt", DateTime.now());
  }

  /// Removes a video from a specific playlist and updates the playlist's [updatedAt] timestamp
  /// [videoId]: The ID of the video to remove from the playlist
  @override
  Future<void> removeVideoFromPlaylist(
      String playlistId, String videoId) async {
    await firebaseDataSource.updatePlaylistField(
        playlistId, "videos", FieldValue.arrayRemove([videoId]));
    await firebaseDataSource.updatePlaylistField(
        playlistId, "updatedAt", DateTime.now());
  }
}
