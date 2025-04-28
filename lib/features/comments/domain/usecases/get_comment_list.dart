import '../../data/models/comment_model.dart';
import '../repositories/comment_repository.dart';

class GetCommentListUseCase {
  final CommentRepository repository;

  GetCommentListUseCase(this.repository);

  Stream<List<CommentModel>> call(String videoId) {
    return repository.getCommentList(videoId);
  }
}
