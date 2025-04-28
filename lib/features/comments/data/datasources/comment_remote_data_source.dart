import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../user/data/models/user_model.dart';
import '../../../video/data/models/video_model.dart';
import '../models/comment_model.dart';

abstract class CommentDataSource {
  Future<void> addCommentToFirestore(CommentModel comment);
  Future<void> deleteCommentFromFirestore(String commentId, String userId);
  Future<void> updateCommentCount(VideoModel video, int updateCommentCount);
  Stream<List<CommentModel>> getCommentList(String videoId);
  Future<CommentModel> getCommentSnapshot(String commentId);
  Future<UserModel?> getUserDetailsByCommentId(String commentId);
}

class CommentRemoteDataSource implements CommentDataSource {
  final FirebaseFirestore _firestore;

  CommentRemoteDataSource(this._firestore);

  /// Adds a comment to Firestore by setting the data in the comments collection
  @override
  Future<void> addCommentToFirestore(CommentModel comment) async {
    await _firestore
        .collection("comments")
        .doc(comment.commentId)
        .set(comment.toMap());
  }

  /// Deletes a comment from Firestore by querying for the document with the specified [userId]
  @override
  Future<void> deleteCommentFromFirestore(
      String commentId, String userId) async {
    return await _firestore
        .collection("comments")
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) => value.docs.map((e) => e.reference.delete()));
  }

  /// Updates the comment count of a video in Firestore
  @override
  Future<void> updateCommentCount(
      VideoModel video, int updateCommentCount) async {
    await _firestore
        .collection("videos")
        .doc(video.videoId)
        .update({"commentsCount": updateCommentCount});
  }

  /// Streams a list of comments for a specific video by filtering the "comments" collection
  @override
  Stream<List<CommentModel>> getCommentList(String videoId) {
    return _firestore
        .collection("comments")
        .where("videoId", isEqualTo: videoId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data()))
            .toList());
  }

  /// Retrieves a snapshot of a specific comment from Firestore
  @override
  Future<CommentModel> getCommentSnapshot(String commentId) async {
    final snapshot =
        await _firestore.collection("comments").doc(commentId).get();
    return CommentModel.fromMap(snapshot.data()!);
  }

  /// Retrieves the details of a user with a specific [commentId]
  @override
  Future<UserModel?> getUserDetailsByCommentId(String commentId) async {
    final commentData = await getCommentSnapshot(commentId);
    final userId = commentData.userId;

    final userQuerySnapshot = await _firestore
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();
    final userDoc = userQuerySnapshot.docs.first;
    return UserModel.fromMap(userDoc.data());
  }
}
