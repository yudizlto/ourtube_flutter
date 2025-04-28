import '../../../../user/data/models/user_model.dart';
import '../../../data/models/video_model.dart';
import '../../repositories/likes_repository.dart';

class UnLikeVideoUseCase {
  final LikesRepository repository;

  UnLikeVideoUseCase(this.repository);

  Future<void> execute(VideoModel video, UserModel user) async {
    await repository.unLikes(video, user);
  }
}
