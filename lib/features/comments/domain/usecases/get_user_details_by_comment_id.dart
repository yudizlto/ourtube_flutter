import '../../../user/data/models/user_model.dart';
import '../repositories/comment_repository.dart';

class GetUserDetailsByCommentIdUseCase {
  final CommentRepository repository;

  GetUserDetailsByCommentIdUseCase(this.repository);

  Future<UserModel?> execute(String commentId) async {
    final userData = await repository.getUserDetailsByCommentId(commentId);
    return userData;
  }
}
