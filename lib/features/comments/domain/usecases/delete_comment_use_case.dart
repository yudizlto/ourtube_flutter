import '../../../video/data/models/video_model.dart';
import '../../data/models/comment_model.dart';
import '../repositories/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> call(CommentModel comment, VideoModel video, String videoId,
      String userId) async {
    return repository.deleteComment(comment, video, videoId, userId);
  }
}
