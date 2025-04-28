import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/likes_model.dart';

abstract class LikesDataSource {
  Future<void> addLikesToFirestore(LikesModel likes);
  Future<void> deleteLikesFromFirestore(String likeId);
  Stream<bool> isLikedByUser(String videoId, String userId);
  Future<String?> getLikeId(String userId, String videoId);
}

class LikesRemoteDataSource implements LikesDataSource {
  final FirebaseFirestore _firestore;

  LikesRemoteDataSource(this._firestore);

  /// Adds a like document to the "likes" collection in Firestore
  @override
  Future<void> addLikesToFirestore(LikesModel likes) async {
    await _firestore.collection("likes").doc(likes.likeId).set(likes.toMap());
  }

  /// Deletes a like document from Firestore by [likeId]
  @override
  Future<void> deleteLikesFromFirestore(String likeId) async {
    await _firestore.collection("likes").doc(likeId).delete();
  }

  /// Streams a boolean value indicating whether a user likes a specific video
  @override
  Stream<bool> isLikedByUser(String videoId, String userId) {
    return _firestore
        .collection("likes")
        .where("userId", isEqualTo: userId)
        .where("videoId", isEqualTo: videoId)
        .snapshots()
        .map((e) => e.docs.isNotEmpty);
  }

  /// Retrieves the [likeId] of the like document for a user and video combination
  @override
  Future<String?> getLikeId(String userId, String videoId) async {
    final snapshot = await _firestore
        .collection("likes")
        .where("userId", isEqualTo: userId)
        .where("videoId", isEqualTo: videoId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }
}
