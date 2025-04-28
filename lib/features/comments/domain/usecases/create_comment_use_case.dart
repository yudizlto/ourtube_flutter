import '../../../video/data/models/video_model.dart';
import '../../data/models/comment_model.dart';
import '../repositories/comment_repository.dart';

class CreateCommentUseCase {
  final CommentRepository repository;

  CreateCommentUseCase(this.repository);

  Future<void> call(CommentModel comment, VideoModel video, String videoId,
      String userId) async {
    await repository.createComment(comment, video, videoId, userId);
  }
}
