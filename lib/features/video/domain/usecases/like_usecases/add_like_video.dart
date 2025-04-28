import '../../../../user/data/models/user_model.dart';
import '../../../data/models/video_model.dart';
import '../../repositories/likes_repository.dart';

class AddLikeVideoUseCase {
  final LikesRepository repository;

  AddLikeVideoUseCase(this.repository);

  Future<void> execute(VideoModel video, UserModel user) async {
    return repository.addLikes(video, user);
  }
}
