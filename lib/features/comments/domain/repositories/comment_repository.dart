import '../../../user/data/models/user_model.dart';
import '../../../video/data/models/video_model.dart';
import '../../data/models/comment_model.dart';

abstract class CommentRepository {
  Future<void> createComment(
      CommentModel comment, VideoModel video, String videoId, String userId);
  Future<void> deleteComment(
      CommentModel comment, VideoModel video, String videoId, String userId);
  Stream<List<CommentModel>> getCommentList(String videoId);
  Future<UserModel?> getUserDetailsByCommentId(String commentId);
}
