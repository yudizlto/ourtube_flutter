import 'package:uuid/uuid.dart';

import '../../../user/data/models/user_model.dart';
import '../../../video/data/datasources/firebase_video_data_source.dart';
import '../../../video/data/models/video_model.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource dataSource;
  final FirebaseVideoDataSource firebaseVideoDatasource;

  CommentRepositoryImpl({
    required this.dataSource,
    required this.firebaseVideoDatasource,
  });

  /// Method to create a comment
  @override
  Future<void> createComment(CommentModel comment, VideoModel video,
      String videoId, String userId) async {
    final commentId = const Uuid().v4();
    final commentModel = CommentModel(
      commentId: commentId,
      videoId: videoId,
      userId: userId,
      text: comment.text,
      likesCount: comment.likesCount,
      dislikesCount: comment.dislikesCount,
      repliesCount: comment.repliesCount,
      createdAt: comment.createdAt,
      isEdited: comment.isEdited,
    );

    /// Call the data source to add the comment to Firestore
    await dataSource.addCommentToFirestore(commentModel);

    /// Update the comment count of the video
    final updateCommentCount = video.commentsCount + 1;
    await dataSource.updateCommentCount(video, updateCommentCount);
  }

  /// Method to delete a comment
  @override
  Future<void> deleteComment(CommentModel comment, VideoModel video,
      String videoId, String userId) async {
    /// Call the data source to delete the comment to Firestore
    await dataSource.deleteCommentFromFirestore(comment.commentId, userId);

    /// Update the comment count of the video
    final updateCommentCount = video.commentsCount - 1;
    await dataSource.updateCommentCount(video, updateCommentCount);
  }

  /// Method to get a list of comments
  @override
  Stream<List<CommentModel>> getCommentList(String videoId) {
    return dataSource.getCommentList(videoId);
  }

  /// Method to get user details by comment id
  @override
  Future<UserModel?> getUserDetailsByCommentId(String commentId) async {
    return await dataSource.getUserDetailsByCommentId(commentId);
  }
}
