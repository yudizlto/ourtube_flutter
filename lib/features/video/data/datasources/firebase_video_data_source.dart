import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../user/data/models/user_model.dart';
import '../models/video_model.dart';

abstract class FirebaseVideoDataSource {
  Future<void> addVideoToFirestore(VideoModel video);
  Future<void> deleteVideoFromFirestore(String videoId);
  Future<Map<String, dynamic>?> getVideoSnapshot(String videoId);
  Future<UserModel?> getUserDetailsByVideoId(String videoId);
  Future<List<VideoModel>> getVideoSuggestions(String userId);
  Future<void> updateVideoChangesToFirestore(
      String videoId, Map<String, dynamic> fieldsToUpdate);
  Future<void> updateVideoViewCount(VideoModel video, int updateViewsCount);
}

class FirebaseVideoRemoteDatasource implements FirebaseVideoDataSource {
  final FirebaseFirestore _firestore;

  FirebaseVideoRemoteDatasource(this._firestore);

  /// Adds a video document to the Firestore "videos" collection with the provided video data
  @override
  Future<void> addVideoToFirestore(VideoModel video) async {
    await _firestore.collection("videos").doc(video.videoId).set(video.toMap());
  }

  /// Fetches a specific video snapshot based on the [videoId]
  @override
  Future<Map<String, dynamic>?> getVideoSnapshot(String videoId) async {
    final snapshot = await _firestore.collection("videos").doc(videoId).get();
    return snapshot.data();
  }

  /// Retrieves user details for the owner of a specific video
  @override
  Future<UserModel?> getUserDetailsByVideoId(String videoId) async {
    /// Retrieves the userId associated with the video from Firestore
    final videoData = await getVideoSnapshot(videoId);
    final userId = videoData!["userId"];

    /// Fetches user details based on the [userId]
    final userQuerySnapshot = await _firestore
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();
    final userDoc = userQuerySnapshot.docs.first;
    return UserModel.fromMap(userDoc.data());
  }

  /// Fetches video suggestions from the Firestore "videos" collection excluding the user's own videos
  @override
  Future<List<VideoModel>> getVideoSuggestions(String userId) async {
    final snapshot = await _firestore
        .collection("videos")
        .where("userId", isNotEqualTo: userId)
        .limit(5)
        .get();

    /// Filters the results to include only public videos
    final publicVideos = snapshot.docs
        .where((doc) => doc.data()["visibilityType"] == "Public")
        .map((e) => VideoModel.fromMap(e.data()))
        .toList();

    return publicVideos;
  }

  /// Deletes the Firestore document for a specific [videoId]
  @override
  Future<void> deleteVideoFromFirestore(String videoId) async {
    await _firestore.collection("videos").doc(videoId).delete();
  }

  /// Updates specific fields in an existing video document in Firestore
  @override
  Future<void> updateVideoChangesToFirestore(
    String videoId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    await _firestore.collection("videos").doc(videoId).update(fieldsToUpdate);
  }

  /// Updates the video views count of a video in Firestore
  @override
  Future<void> updateVideoViewCount(
      VideoModel video, int updateViewsCount) async {
    await _firestore
        .collection("videos")
        .doc(video.videoId)
        .update({"viewsCount": updateViewsCount});
  }
}
