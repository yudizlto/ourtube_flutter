import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/user/data/models/user_model.dart';
import '../../../features/video/data/models/video_model.dart';

abstract class FirebaseDataSource {
  Future<void> updateUserField(String userId, String field, dynamic value);
  Future<void> updateVideoField(String videoId, String field, dynamic value);
  Future<void> updatePlaylistField(String playlistId, String field, value);
  Future<VideoModel> getVideoDetailsByVideoId(String videoId);
  Future<UserModel> getUserDetailsByVideoId(String userId);
  Future<List<VideoModel>> getAllVideosSnapshot(List<String> subscriptions);
  Future<List<VideoModel>> getLongVideosSnapshot();
  Future<List<VideoModel>> getShortsSnapshot();
}

class FirebaseRemoteDataSource implements FirebaseDataSource {
  final FirebaseFirestore _firestore;

  FirebaseRemoteDataSource(this._firestore);

  /// Retrieves all public videos uploaded by users that the current user is subscribed to.
  ///
  /// - [subscriptions] : A list of user IDs representing the channels the user is subscribed to.
  /// - Returns: A list of [VideoModel] objects filtered by `visibilityType = Public`.
  ///
  /// Notes:
  /// - Firestore limits the `whereIn` query to a maximum of 10 elements.
  ///   Therefore, the list is divided into chunks of 10.
  @override
  Future<List<VideoModel>> getAllVideosSnapshot(
      List<String> subscriptions) async {
    List<VideoModel> allVideos = [];

    for (int i = 0; i < subscriptions.length; i += 10) {
      final chunk = subscriptions.sublist(
        i,
        (i + 10 > subscriptions.length) ? subscriptions.length : i + 10,
      );

      final snapshot = await _firestore
          .collection("videos")
          .where("visibilityType", isEqualTo: "Public")
          .where("userId", whereIn: chunk)
          .get();

      allVideos.addAll(
        snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())),
      );
    }

    return allVideos;
  }

  /// Updates a specific field of a user's data in the Firestore database
  @override
  Future<void> updateUserField(String userId, String field, value) async {
    await _firestore.collection("users").doc(userId).update({field: value});
  }

  /// Updates a specific field of a video's data in the Firestore database
  @override
  Future<void> updateVideoField(String videoId, String field, value) async {
    await _firestore.collection("videos").doc(videoId).update({field: value});
  }

  /// Updates a specific field of a playlist's data in the Firestore database
  @override
  Future<void> updatePlaylistField(
      String playlistId, String field, value) async {
    await _firestore
        .collection("playlists")
        .doc(playlistId)
        .update({field: value});
  }

  /// Retrieves a single video's details based on its [videoId].
  ///
  /// - The function queries the "videos" collection for a document where "videoId" matches.
  @override
  Future<VideoModel> getVideoDetailsByVideoId(String videoId) async {
    final snapshot = await _firestore
        .collection("videos")
        .where("videoId", isEqualTo: videoId)
        .get();
    return VideoModel.fromMap(snapshot.docs.first.data());
  }

  /// Retrieves the details of a video from Firestore based on its ID.
  ///
  /// - [videoId]: The unique identifier of the video.
  /// - Returns: A `Future` that resolves to a `VideoModel` object containing the video details.
  @override
  Future<UserModel> getUserDetailsByVideoId(String userId) async {
    final snapshot = await _firestore
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();
    return UserModel.fromMap(snapshot.docs.first.data());
  }

  /// Retrieves a list of public videos from Firestore and returns them in a randomized order.
  ///
  /// This function fetches all video documents from the "videos" collection where
  /// the `visibilityType` field is set to "Public". The retrieved list of videos
  /// is then shuffled to ensure a different order each time the function is called.
  ///
  /// - Returns: A `Future` that resolves to a `List<VideoModel>`, where each item
  ///   represents a video retrieved from Firestore.
  @override
  Future<List<VideoModel>> getLongVideosSnapshot() async {
    final videoSnapshot = await _firestore
        .collection("videos")
        .where("visibilityType", isEqualTo: "Public")
        .where("type", isEqualTo: "Long")
        .get();

    List<VideoModel> videoList = videoSnapshot.docs
        .map((doc) => VideoModel.fromMap(doc.data()))
        .toList();

    videoList.shuffle(Random());
    return videoList;
  }

  /// Retrieves a list of public short-form videos (shorts) from Firestore and shuffles them.
  ///
  /// - This function fetches all video documents where `visibilityType` is "Public"
  ///   and `type` is "Shorts".
  /// - The resulting list is shuffled before being returned.
  /// - Returns: A `Future` that resolves to a shuffled `List<VideoModel>`.
  @override
  Future<List<VideoModel>> getShortsSnapshot() async {
    final videoSnapshot = await _firestore
        .collection("videos")
        .where("visibilityType", isEqualTo: "Public")
        .where("type", isEqualTo: "Shorts")
        .get();

    List<VideoModel> videoList = videoSnapshot.docs
        .map((doc) => VideoModel.fromMap(doc.data()))
        .toList();

    videoList.shuffle(Random());
    return videoList;
  }
}
